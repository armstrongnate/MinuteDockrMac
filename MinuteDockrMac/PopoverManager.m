//
//  PopoverManager.m
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/14/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "PopoverManager.h"

@implementation PopoverManager


- (instancetype)initWithPopoverViewController:(PopoverViewController *)popoverViewController detachedWindow:(NSWindow *)detachedWindow {
  self = [super init];
  if (self) {
    self.popoverViewController = popoverViewController;
    self.detachedWindow = detachedWindow;
    [self createPopover];
  }
  return self;
}

- (void)createPopover {
  if (self.popover == nil) {
    self.popover = [[NSPopover alloc] init];
    self.popover.contentViewController = self.popoverViewController;
    self.popover.animates = NO;
    self.popover.behavior = NSPopoverBehaviorTransient;
    self.popover.delegate = self;
  }
}

- (NSWindow *)detachableWindowForPopover:(NSPopover *)popover {
  return self.detachedWindow;
}

- (void)showPopoverRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView preferredEdge:(NSRectEdge)preferredEdge {
  [self.popover showRelativeToRect:positioningRect ofView:positioningView preferredEdge:preferredEdge];
}

@end
