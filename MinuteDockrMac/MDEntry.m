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

+ (void)current:(void (^)(Resource *response, NSError *error))block {
  NSLog(@"in here man");
  NSString *path = @"entries/current.json";
  [self requestURL:path as:HTTPMethodGet expectArray:NO sendParams:nil withBlock:block];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super initWithDictionary:dictionary]) {
    self.unique = [[dictionary objectForKey:@"id"] integerValue];
    self.duration = MDDurationMakeWithSeconds([[dictionary objectForKey:@"duration"] integerValue]);
    self.contactId = [[dictionary objectForKey:@"contact_id"] integerValue];
    self.active = [[dictionary objectForKey:@"timer_active"] boolValue];
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

@end
