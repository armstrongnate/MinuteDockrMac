//
//  AppDelegate.m
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/8/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "AppDelegate.h"
#import "MinuteDockCredentialStorage.h"
#import "CurrentEntry.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [self login];

  [[CurrentEntry sharedInstance] start];

  self.statusItemManager = [[StatusItemManager alloc] init];
  self.statusItemManager.delegate = self;
  self.popoverManager = [[PopoverManager alloc] initWithPopoverViewController:self.popoverViewController detachedWindow:self.detachedWindow];
}

- (void)login {
  NSURLCredential *credential = [NSURLCredential credentialWithUser:@"username"
                                                           password:@"password"
                                                        persistence:NSURLCredentialPersistenceNone];
  [[MinuteDockCredentialStorage sharedCredentialStorage] setCredential:credential];
}


#pragma mark - StatusItemDelegate

- (void)statusItemPressed:(id)sender {
  NSStatusBarButton *button = (NSStatusBarButton *)sender;
  [self.popoverManager showPopoverRelativeToRect:[button bounds] ofView:sender preferredEdge:NSMaxYEdge];
}

@end
