//
//  PopoverManager.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/14/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopoverViewController.h"

@interface PopoverManager : NSObject <NSPopoverDelegate>

@property (strong) PopoverViewController *popoverViewController;
@property (strong) NSWindow *detachedWindow;
@property (strong) NSPopover *popover;

- (void)showPopoverRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView preferredEdge:(NSRectEdge)preferredEdge;
- (instancetype)initWithDetachedWindow:(NSWindow *)detachedWindow;

@end
