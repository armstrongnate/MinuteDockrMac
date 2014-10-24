//
//  PopoverViewController.m
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/14/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "PopoverViewController.h"
#import "MDEntry.h"
#import "MDContact.h"
#import "MDProject.h"
#import "CurrentEntry.h"
#import "NSPopUpButton+Resource.h"

@interface PopoverViewController ()

@property (weak) IBOutlet NSTextField *durationLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (weak) IBOutlet NSPopUpButton *contactSelect;
@property (weak) IBOutlet NSPopUpButton *projectSelect;
@property (nonatomic, copy) void (^responseHandler)(Resource *response, NSError *error);
@property (nonatomic, strong) NSArray *filteredProjects;
@property (weak) IBOutlet NSButton *startStopButton;

@end

@implementation PopoverViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.entry = [[CurrentEntry sharedInstance] entry];
  [self queryContacts];
  [self queryProjects];
  __weak PopoverViewController *weakSelf = self;
  self.responseHandler = ^void(Resource *response, NSError *error) {
    if (error != nil) {
      // handle error
    } else {
      MDEntry *entry = (MDEntry *)response;
      entry.entryDescription = [weakSelf.descriptionTextField stringValue];
      [[CurrentEntry sharedInstance] setEntry:entry];
    }
  };
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentEntryDidUpdate:) name:@"CurrentEntryDidUpdate" object:nil];
  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)currentEntryDidUpdate:(NSNotification *)notification {
  if ([notification.name isEqualToString:@"CurrentEntryDidUpdate"]) {
    MDEntry *entry = (MDEntry *)notification.object;
    self.entry = entry;
  }
}

- (void)reset {
  [self.contactSelect selectItemAtIndex:-1];
  [self.projectSelect selectItemAtIndex:-1];
  [self.descriptionTextField setStringValue:@""];
  MDDuration duration;
  duration.hours = 0;
  duration.minutes = 0;
  duration.seconds = 0;
  self.entry = [[MDEntry alloc] init];
  self.entry.duration = duration;
  self.entry.active = NO;
  [[CurrentEntry sharedInstance] setEntry:self.entry];
}

- (IBAction)didSelectContact:(id)sender {
  MDContact *contact = [self selectedContact];
  [self.entry updateAttribute:@"contactId" withValue:[NSNumber numberWithInteger:contact.unique] block:self.responseHandler];
  [self filterProjects];
}

- (IBAction)didSelectProject:(id)sender {
  MDProject *project = [self selectedProject];
  [self.contactSelect selectItemWithTag:project.contactId];
  NSDictionary *attributes = @{
    @"projectId": [NSNumber numberWithInteger:project.unique],
    @"contactId": [NSNumber numberWithInteger:project.contactId],
  };
  [self.entry updateAttributes:attributes block:self.responseHandler];
}

- (void)setEntry:(MDEntry *)entry {
  _entry = entry;
  [self updateUI];
}

- (void)updateUI {
  if (self.entry == nil) {
    return;
  };
  if (self.contacts != nil && self.projects != nil) {
    [self.contactSelect selectResourceWithTag:self.entry.contactId];
    [self filterProjects];
    [self.projectSelect selectResourceWithTag:self.entry.projectId];
  }
  [self setButtonTitleForActive:self.entry.isActive];
  if (self.entry.entryDescription != nil) {
    [self.descriptionTextField setStringValue:self.entry.entryDescription];
  }
}

- (void)setButtonTitleForActive:(BOOL)active {
  self.startStopButton.title = active ? @"Stop" : @"Start";
}

- (void)filterProjects {
  MDContact *contact = [self selectedContact];
  if (contact != nil) {
    NSPredicate *contactPredicate = [NSPredicate predicateWithFormat:@"contactId == %@", [NSNumber numberWithInteger:contact.unique]];
    self.filteredProjects = [self.projects filteredArrayUsingPredicate:contactPredicate];
    [self.projectSelect removeAllItems];
    [self.projectSelect addResourceItems:self.filteredProjects];
    [self.projectSelect selectItemAtIndex:-1];
  } else {
    self.filteredProjects = self.projects;
  }
}

- (void)tick {
  [self.durationLabel setStringValue:[NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)self.entry.duration.hours, (long)self.entry.duration.minutes, (long)self.entry.duration.seconds]];
}

- (void)queryContacts {
  [self.contactSelect removeAllItems];
  [MDContact query:^(NSArray *response, NSError *error) {
    self.contacts = response;
    [self.contactSelect addResourceItems:self.contacts];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self updateUI];
    });
  }];
}

- (void)queryProjects {
  [self.projectSelect removeAllItems];
  [MDProject query:^(NSArray *response, NSError *error) {
    self.projects = response;
    [self.projectSelect addResourceItems:self.projects];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self updateUI];
    });
  }];
}

- (MDProject *)selectedProject {
  NSArray *projects = [self selectedContact] == nil ? self.projects : self.filteredProjects;
  if ([self.projectSelect selectedItem] != nil) {
    return [projects objectAtIndex:[self.projectSelect indexOfSelectedItem]];
  }
  return nil;
}

- (MDContact *)selectedContact {
  if ([self.contactSelect selectedItem] != nil) {
    return [self.contacts objectAtIndex:[self.contactSelect indexOfSelectedItem]];
  }
  return nil;
}

- (IBAction)startStopButtonPressed:(id)sender {
  [self setButtonTitleForActive:!self.entry.isActive];
  [[CurrentEntry sharedInstance] resume:!self.entry.isActive withBlock:self.responseHandler];
}

- (IBAction)logButtonPressed:(id)sender {
  [self.entry updateAttribute:@"entryDescription" withValue:[self.descriptionTextField stringValue] block:^(Resource *response, NSError *error) {
    if (error == nil) {
      [[CurrentEntry sharedInstance] logWithBlock:^(Resource *response, NSError *error) {
        if (error == nil) {
          [self reset];
        }
      }];
    }
  }];
}

@end
