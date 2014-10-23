//
//  PopoverViewController.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/14/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MDEntry;

@interface PopoverViewController : NSViewController

@property (nonatomic, strong) MDEntry *entry;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSArray *projects;

@end
