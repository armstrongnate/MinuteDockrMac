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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    [[CurrentEntry sharedInstance] refreshWithBlock:^(Resource *response, NSError *error) {
      MDEntry *entry = (MDEntry *)response;
      self.entry = entry;
    }];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self queryContacts];
  [self queryProjects];
  __weak PopoverViewController *weakSelf = self;
  self.responseHandler = ^void(Resource *response, NSError *error) {
    if (error != nil) {
      // handle error
    } else {
      MDEntry *entry = (MDEntry *)response;
      weakSelf.entry = entry;
      [[CurrentEntry sharedInstance] setEntry:weakSelf.entry];
    }
  };
  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (IBAction)didSelectContact:(id)sender {
  MDContact *contact = [self selectedContact];
  NSDictionary *attributes = @{
    @"contactId": [NSNumber numberWithInteger:contact.unique],
    @"entryDescription": self.descriptionTextField.stringValue,
  };
  [self.entry updateAttributes:attributes block:self.responseHandler];
  [self filterProjects];
}

- (IBAction)didSelectProject:(id)sender {
  MDProject *project = [self selectedProject];
  [self.contactSelect selectItemWithTag:project.contactId];
  NSDictionary *attributes = @{
    @"projectId": [NSNumber numberWithInteger:project.unique],
    @"contactId": [NSNumber numberWithInteger:project.contactId],
    @"entryDescription": self.descriptionTextField.stringValue,
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
  } else {
    [self.descriptionTextField setStringValue:@""];
  }
  [self tick];
}

- (void)setButtonTitleForActive:(BOOL)active {
  self.startStopButton.title = active ? @"Stop" : @"Start";
}

- (void)filterProjects {
  MDContact *contact = [self selectedContact];
  if (contact != nil) {
    NSPredicate *contactPredicate = [NSPredicate predicateWithFormat:@"contactId == %@", [NSNumber numberWithInteger:contact.unique]];
    self.filteredProjects = [self.projects filteredArrayUsingPredicate:contactPredicate];
  } else {
    self.filteredProjects = self.projects;
  }
  [self.projectSelect removeAllItems];
  [self.projectSelect addResourceItems:self.filteredProjects];
  [self.projectSelect selectItemAtIndex:-1];
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
          self.entry = [[MDEntry alloc] init];
          [[CurrentEntry sharedInstance] setEntry:self.entry];
        }
      }];
    }
  }];
}

@end
