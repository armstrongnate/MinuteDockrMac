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

  NSTimeInterval ti = [[NSUserDefaults standardUserDefaults] doubleForKey:@"MDCurrentEntryRefreshInterval"];
  [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(getCurrentEntry:) userInfo:nil repeats:YES];
}

- (void)setupStatusItem {
  _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
  _statusItem.title = @"";
  _statusItem.image = [NSImage imageNamed:@"status_item_image_inactive"];
  _statusItem.highlightMode = YES;
  [_statusItem setDoubleAction:@selector(toggleCurrentEntry:)];
}

- (void)toggleCurrentEntry:(id)sender {
  if (self.currentEntry) {
    if ((BOOL)[self.currentEntry objectForKey:@"timer_active"]) {
    }
  }
}

- (void)getCurrentEntry:(id)sender {
  [self.minuteDockClient getCurrentEntryWithCompletionHandler:^(NSDictionary *entry, NSError *error) {
    BOOL active = false;
    if (error != nil) {
      NSLog(@"Error: %@", error);
    } else {
      NSLog(@"current entry: %@", entry);
      self.currentEntry = entry;
      active = (BOOL)[entry objectForKey:@"timer_active"];
      _statusItem.image = [NSImage imageNamed:active ? @"status_item_image_active" : @"status_item_image_inactive"];
    }
  }];
}

- (MinuteDockClient *)minuteDockClient {
  if (!_minuteDockClient) {
    _minuteDockClient = [[MinuteDockClient alloc] init];
  }
  return _minuteDockClient;
}

@end
