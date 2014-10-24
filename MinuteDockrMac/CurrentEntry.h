//
//  CurrentEntry.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/21/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MDEntry;
@class Resource;

@interface CurrentEntry : NSObject

@property (nonatomic, strong) MDEntry *entry;

+ (instancetype)sharedInstance;
- (void)beginRefreshing;
- (void)resume:(BOOL)active withBlock:(void (^)(Resource *response, NSError *error))block;
- (void)logWithBlock:(void (^)(Resource *response, NSError *error))block;
- (void)refreshWithBlock:(void (^)(Resource *response, NSError *error))block;

@end
