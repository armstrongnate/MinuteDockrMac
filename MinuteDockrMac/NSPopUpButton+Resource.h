//
//  NSPopUpButton+Resource.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/22/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol NSMenuItemResource;

@interface NSPopUpButton (Resource)

- (void)addResourceItems:(NSArray *)items;
- (void)selectResourceWithTag:(NSInteger)tag;

@end
