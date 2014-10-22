//
//  StatusItemManager.m
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/21/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "StatusItemManager.h"
#import "MDEntry.h"

@interface StatusItemManager ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) MDEntry *entry;

@end

@implementation StatusItemManager

- (instancetype)init {
  if (self = [super init]) {
    [self setupStatusItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentEntryDidUpdate:) name:@"CurrentEntryDidUpdate" object:nil];
  }
  return self;
}

- (void)setupStatusItem {
  self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  NSImage *image = [NSImage imageNamed:@"status_item"];
  [image setTemplate:YES];
  self.statusItem.button.image = image;
  self.statusItem.button.imagePosition = NSImageLeft;
  self.statusItem.button.action = @selector(statusItemPressed:);
  self.statusItem.button.target = self.delegate;
}

- (void)currentEntryDidUpdate:(NSNotification *)notification {
  if ([notification.name isEqualToString:@"CurrentEntryDidUpdate"]) {
    MDEntry *entry = (MDEntry *)notification.object;
    self.entry = entry;
    [self updateUI];
    [self.timer invalidate];
    if (self.entry.isActive) {
      self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    }
  }
}

- (void)tick {
  [self updateUI];
}

- (void)updateUI {
  self.statusItem.button.appearsDisabled = !self.entry.isActive;
  self.statusItem.button.title = [NSString stringWithFormat:@"%02ld:%02ld", (long)self.entry.duration.hours, (long)self.entry.duration.minutes];
}

@end
