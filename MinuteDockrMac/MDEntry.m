//
//  MDEntry.m
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/14/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "MDEntry.h"

@implementation MDEntry

+ (NSString *)resourceName {
  return @"entry";
}

+ (void)current:(ObjectResourceBlock)block {
  NSString *path = @"entries/current.json";
  [self requestURL:path as:HTTPMethodGet expectArray:NO sendParams:nil withBlock:block];
}

+ (void)setCurrentActive:(BOOL)active withBlock:(ObjectResourceBlock)block {
  NSString *path = active ? @"entries/current/start.json" : @"entries/current/pause.json";
  [self requestURL:path as:HTTPMethodPost expectArray:NO sendParams:@{} withBlock:block];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super initWithDictionary:dictionary]) {
    self.unique = [[dictionary objectForKey:@"id"] integerValue];
    self.duration = MDDurationMakeWithSeconds([[dictionary objectForKey:@"duration"] integerValue]);
    self.contactId = [[dictionary objectForKey:@"contact_id"] integerValue];
    self.projectId = [[dictionary objectForKey:@"project_id"] integerValue];
    self.active = [[dictionary objectForKey:@"timer_active"] boolValue];
    NSString *description = (NSString *)[dictionary objectForKey:@"description"];
    if (!(description == (id)[NSNull null]) && ![description isEqualToString:@"<null>"]) {
      self.entryDescription = (NSString *)[dictionary objectForKey:@"description"];
    }
    self.logged = [dictionary objectForKey:@"logged_at"] != (id)[NSNull null];
  }
  return self;
}

- (void)tick {
  NSUInteger seconds = self.duration.seconds + 1;
  NSUInteger minutes = self.duration.minutes;
  NSUInteger hours = self.duration.hours;
  if (seconds > 59) {
    minutes += 1;
    seconds = 0;
  }
  if (minutes > 59) {
    hours += 1;
    minutes = 0;
  }
  self.duration = MDDurationMake(hours, minutes, seconds);
}

- (NSInteger)durationInSeconds {
  return (self.duration.hours * 3600) + (self.duration.minutes * 60) + self.duration.minutes;
}

- (NSDictionary *)safeAttributes {
  return @{
    @"contact_id": [NSNumber numberWithInteger:self.contactId],
    @"project_id": [NSNumber numberWithInteger:self.projectId],
    @"duration": [NSNumber numberWithInteger:[self durationInSeconds]],
    @"description": self.entryDescription,
  };
}

@end
