//
//  Resource.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/20/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//
// methods to override:
//  * + (instancetype)initWithDictionary:
//  * + (NSString *)resourceName

#import <Foundation/Foundation.h>
#import "NSNull+Resource.h"

typedef enum {
  HTTPMethodGet,
  HTTPMethodPost
} HTTPMethod;

@interface Resource : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (void)query:(void (^)(NSArray *response, NSError *error))block;
+ (void)get:(NSUInteger)unique withBlock:(void (^)(Resource *response, NSError *error))block;
+ (void)requestURL:(NSString *)urlString as:(HTTPMethod)method expectArray:(BOOL)isArray sendParams:(NSDictionary *)params
         withBlock:(void (^)(id response, NSError *error))block;

@end
