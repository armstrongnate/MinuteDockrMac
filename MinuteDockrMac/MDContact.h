//
//  MDContact.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/22/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "Resource.h"
#import "NSMenuItemResourceProtocol.h"

@interface MDContact : Resource <NSMenuItemResource>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shortCode;

@end
