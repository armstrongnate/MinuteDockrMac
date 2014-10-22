//
//  CurrentEntry.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/21/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MDEntry;

@interface CurrentEntry : NSObject

@property (nonatomic, strong) MDEntry *entry;

+ (instancetype)sharedInstance;
- (void)start;

@end
