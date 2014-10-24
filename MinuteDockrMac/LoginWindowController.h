//
//  LoginWindowController.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/23/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LoginWindowController : NSWindowController

- (void)showWindowWithCompletionHandler:(void (^)(NSURLCredential *credential))completionHandler;

@end
