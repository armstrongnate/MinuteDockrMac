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
  HTTPMethodPost,
  HTTPMethodPut,
} HTTPMethod;

@interface Resource : NSObject

@property (assign) NSUInteger unique;

+ (void)query:(void (^)(NSArray *response, NSError *error))block;
+ (void)get:(NSUInteger)unique withBlock:(void (^)(Resource *response, NSError *error))block;
+ (void)requestURL:(NSString *)urlString as:(HTTPMethod)method expectArray:(BOOL)isArray sendParams:(NSDictionary *)params
         withBlock:(void (^)(id response, NSError *error))block;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)updateAttribute:(NSString *)attribute withValue:(id)value block:(void (^)(Resource *response, NSError *error))block;
- (void)updateAttributes:(NSDictionary *)attributes block:(void (^)(Resource *response, NSError *error))block;

@end

typedef void (^ObjectResourceBlock)(Resource *response, NSError *error);
typedef void (^ArrayResourceBlock)(NSArray *response, NSError *error);