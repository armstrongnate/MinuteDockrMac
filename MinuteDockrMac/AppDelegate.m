//
//  AppDelegate.m
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/8/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "AppDelegate.h"
#import "MinuteDockClient.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) NSDictionary *currentEntry;
@property (nonatomic, strong) MinuteDockClient *minuteDockClient;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"MDCurrentEntryRefreshInterval": @120}];

  [self setupStatusItem];
  [self getCurrentEntry:nil];

  self.detachedWindow.contentView = self.detachedWindowViewController.view;

  NSTimeInterval ti = [[NSUserDefaults standardUserDefaults] doubleForKey:@"MDCurrentEntryRefreshInterval"];
  [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(getCurrentEntry:) userInfo:nil repeats:YES];
}

- (void)setupStatusItem {
  self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
  self.statusItem.title = @"";
  NSImage *image = [NSImage imageNamed:@"status_item"];
  [image setTemplate:YES];
  self.statusItem.button.image = image;
  self.statusItem.button.action = @selector(statusItemPressed:);
  self.statusItem.target = self;
  self.statusItem.highlightMode = NO;
  [self.statusItem setDoubleAction:@selector(toggleCurrentEntry:)];
}

- (void)toggleCurrentEntry:(id)sender {
  if (self.currentEntry) {
    BOOL active = [[self.currentEntry objectForKey:@"timer_active"] isEqual: @1];
    __weak typeof(self) weakSelf = self;
    [self.minuteDockClient setCurrentEntryActive:!active withCompletionHandler:^(NSDictionary *entry, NSError *error) {
      weakSelf.currentEntry = entry;
    }];
  }
}

- (void)getCurrentEntry:(id)sender {
  [self.minuteDockClient getCurrentEntryWithCompletionHandler:^(NSDictionary *entry, NSError *error) {
    if (error != nil) {
      NSLog(@"Error: %@", error);
    } else {
      self.currentEntry = entry;
    }
  }];
}

- (MinuteDockClient *)minuteDockClient {
  if (!_minuteDockClient) {
    _minuteDockClient = [[MinuteDockClient alloc] init];
  }
  return _minuteDockClient;
}

- (void)setCurrentEntry:(NSDictionary *)currentEntry {
  NSLog(@"current entry: %@", currentEntry);
  _currentEntry = currentEntry;
  BOOL active = [[currentEntry objectForKey:@"timer_active"] isEqual: @1];
  self.statusItem.button.appearsDisabled = !active;
}

- (void)createPopover {
  if (self.popover == nil) {
    self.popover = [[NSPopover alloc] init];
    self.popover.contentViewController = self.popoverViewController;
    self.popover.animates = YES;
    self.popover.behavior = NSPopoverBehaviorTransient;
    self.popover.delegate = self;
  }
}

- (void)statusItemPressed:(id)sender {
  [self createPopover];
  NSStatusBarButton *button = (NSStatusBarButton *)sender;
  [self.popover showRelativeToRect:[button bounds] ofView:sender preferredEdge:NSMaxYEdge];
}

- (NSWindow *)detachableWindowForPopover:(NSPopover *)popover {
  return self.detachedWindow;
}

@end
