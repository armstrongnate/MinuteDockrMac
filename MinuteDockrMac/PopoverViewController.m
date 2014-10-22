//
//  PopoverViewController.m
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/14/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "PopoverViewController.h"
#import "MDEntry.h"
#import "CurrentEntry.h"

@interface PopoverViewController ()

@property (weak) IBOutlet NSTextField *durationLabel;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PopoverViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.entry = [[CurrentEntry sharedInstance] entry];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentEntryDidUpdate:) name:@"CurrentEntryDidUpdate" object:nil];
}

- (void)currentEntryDidUpdate:(NSNotification *)notification {
  if ([notification.name isEqualToString:@"CurrentEntryDidUpdate"]) {
    MDEntry *entry = (MDEntry *)notification.object;
    self.entry = entry;
  }
}

- (void)setEntry:(MDEntry *)entry {
  _entry = entry;
  [self updateUI];
  [self.timer invalidate];
  if (self.entry.isActive) {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
  }
}

- (void)tick {
  [self updateUI];
}

- (void)updateUI {
  [self.durationLabel setStringValue:[NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)self.entry.duration.hours, (long)self.entry.duration.minutes, (long)self.entry.duration.seconds]];
}


- (IBAction)startStopButtonPressed:(id)sender {
}

@end
