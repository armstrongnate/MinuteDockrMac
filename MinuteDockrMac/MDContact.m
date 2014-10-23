//
//  MDContact.m
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/22/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "MDContact.h"

@implementation MDContact

+ (NSString *)resourceName {
  return @"contact";
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super initWithDictionary:dictionary]) {
    self.unique = [[dictionary objectForKey:@"id"] integerValue];
    self.name = (NSString *)[dictionary objectForKey:@"name"];
    self.shortCode = (NSString *)[dictionary objectForKey:@"short_code"];
  }
  return self;
}

- (NSUInteger)menuItemTag {
  return self.unique;
}

- (NSString *)menuItemTitle {
  return self.shortCode;
}

@end
