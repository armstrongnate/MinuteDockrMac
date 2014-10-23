//
//  CurrentEntry.m
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/21/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "CurrentEntry.h"
#import "MDEntry.h"

@implementation CurrentEntry

+ (instancetype)sharedInstance {
  static id sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (void)start {
  [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"MDCurrentEntryRefreshInterval": @30}];
  NSTimeInterval ti = [[NSUserDefaults standardUserDefaults] doubleForKey:@"MDCurrentEntryRefreshInterval"];
  [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(getCurrentEntry:) userInfo:nil repeats:YES];
  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tickCurrentEntry:) userInfo:nil repeats:YES];
  [self getCurrentEntry:nil];
}

- (void)tickCurrentEntry:(id)sender {
  if (self.entry.isActive) {
    [self.entry tick];
  }
}

- (void)getCurrentEntry:(id)sender {
  [MDEntry current:^(Resource *response, NSError *error) {
    if (error != nil) {
      NSLog(@"Error: %@", error);
    } else {
      MDEntry *entry = (MDEntry *)response;
      self.entry = entry;
    }
  }];
}

- (void)setEntry:(MDEntry *)entry {
  _entry = entry;
  [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentEntryDidUpdate" object:self.entry];
}

@end
