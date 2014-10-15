//
//  AppDelegate.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/8/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSPopoverDelegate>

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (weak) IBOutlet NSWindow *detachedWindow;
@property (weak) IBOutlet NSViewController *detachedWindowViewController;
@property (weak) IBOutlet NSViewController *popoverViewController;
@property (retain) NSPopover *popover;

@end

