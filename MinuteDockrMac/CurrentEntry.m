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

- (void)beginRefreshing {
  [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"MDCurrentEntryRefreshInterval": @30}];
  NSTimeInterval ti = [[NSUserDefaults standardUserDefaults] doubleForKey:@"MDCurrentEntryRefreshInterval"];
  [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tickCurrentEntry:) userInfo:nil repeats:YES];
  [self refresh:nil];
}

- (void)tickCurrentEntry:(id)sender {
  if (self.entry.isActive) {
    [self.entry tick];
  }
}

- (void)refresh:(id)sender {
  [MDEntry current:^(Resource *response, NSError *error) {
    if (error != nil) {
      NSLog(@"Error: %@", error);
    } else {
      MDEntry *entry = (MDEntry *)response;
      self.entry = entry;
    }
  }];
}

- (void)resume:(BOOL)active withBlock:(ObjectResourceBlock)block {
  NSString *path = active ? @"entries/current/start.json" : @"entries/current/pause.json";
  [MDEntry requestURL:path as:HTTPMethodPost expectArray:NO sendParams:@{} withBlock:block];
}

- (void)logWithBlock:(ObjectResourceBlock)block {
  NSString *path = @"entries/current/log.json";
  [MDEntry requestURL:path as:HTTPMethodPost expectArray:NO sendParams:@{} withBlock:block];
}

- (void)setEntry:(MDEntry *)entry {
  _entry = entry;
  [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentEntryDidUpdate" object:self.entry];
}

@end
