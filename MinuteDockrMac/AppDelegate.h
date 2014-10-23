//
//  AppDelegate.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/8/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PopoverManager.h"
#import "StatusItemManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, StatusItemManagerDelegate>

@property (strong, nonatomic) PopoverManager *popoverManager;
@property (weak) IBOutlet NSWindow *detachedWindow;
@property (weak) IBOutlet PopoverViewController *popoverViewController;
@property (nonatomic, strong) StatusItemManager *statusItemManager;

@end

