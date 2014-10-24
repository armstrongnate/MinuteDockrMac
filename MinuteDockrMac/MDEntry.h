//
//  MDEntry.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/14/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Resource.h"

typedef struct MDDuration {
  NSUInteger hours;
  NSUInteger minutes;
  NSUInteger seconds;
} MDDuration;

static inline MDDuration MDDurationMakeWithSeconds(NSUInteger seconds) {
  struct MDDuration duration;
  duration.hours = floor(seconds / 3600);
  duration.minutes = (long)floor(seconds / 60) % 60;
  duration.seconds = seconds % 60;
  return duration;
}

static inline MDDuration MDDurationMake(NSUInteger hours, NSUInteger minutes, NSUInteger seconds) {
  struct MDDuration duration;
  duration.hours = hours;
  duration.minutes = minutes;
  duration.seconds = seconds;
  return duration;
}

@interface MDEntry : Resource

@property (assign) NSUInteger contactId;
@property (assign) NSUInteger projectId;
@property (getter=isActive, assign) BOOL active;
@property (getter=isLogged, assign) BOOL logged;
@property (assign) struct MDDuration duration;
@property (nonatomic, strong) NSString *entryDescription;

+ (void)current:(void (^)(Resource *response, NSError *error))block;
- (void)tick;

@end
