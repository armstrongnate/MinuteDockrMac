//
//  StatusItemManager.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/21/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@class MDEntry;

@protocol StatusItemManagerDelegate <NSObject>

- (void)statusItemPressed:(id)sender;

@end

@interface StatusItemManager : NSObject

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (weak) id <StatusItemManagerDelegate> delegate;

- (void)setEntry:(MDEntry *)entry;

@end
