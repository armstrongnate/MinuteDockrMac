//
//  MinuteDockCredentialStorage.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/20/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinuteDockCredentialStorage : NSObject

+ (instancetype)sharedCredentialStorage;

- (NSURLCredential *)credential;
- (void)setCredential:(NSURLCredential *)credential;
- (void)removeCredential;

@end
