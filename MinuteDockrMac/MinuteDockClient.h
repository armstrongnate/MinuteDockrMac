//
//  MinuteDockClient.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/10/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinuteDockClient : NSObject

- (void)getCurrentEntryWithCompletionHandler:(void (^)(NSDictionary *entry, NSError *error))completionHandler;
- (void)setCurrentEntryActive:(BOOL)active withCompletionHandler:(void (^)(NSDictionary *entry, NSError *error))completionHandler;

@end
