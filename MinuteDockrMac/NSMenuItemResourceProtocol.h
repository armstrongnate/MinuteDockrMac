//
//  NSMenuItemResourceProtocol.h
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/22/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#ifndef MinuteDockrMac_NSMenuItemResourceProtocol_h
#define MinuteDockrMac_NSMenuItemResourceProtocol_h

@protocol NSMenuItemResource <NSObject>

- (NSString *)menuItemTitle;
- (NSUInteger)menuItemTag;

@end

#endif
