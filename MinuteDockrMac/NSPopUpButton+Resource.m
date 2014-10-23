//
//  NSPopUpButton+Resource.m
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/22/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "NSPopUpButton+Resource.h"
#import "NSMenuItemResourceProtocol.h"

@implementation NSPopUpButton (Resource)

- (void)addResourceItems:(NSArray *)items {
  [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    id<NSMenuItemResource> resource = (id<NSMenuItemResource>)obj;
    [self addItemWithTitle:[resource menuItemTitle]];
    [[self itemWithTitle:[resource menuItemTitle]] setTag:[resource menuItemTag]];
  }];
}

- (void)selectResourceWithTag:(NSInteger)tag {
  if (tag <= 0) {
    [self selectItemAtIndex:-1];
    return;
  }
  [self selectItemWithTag:tag];
}

@end
