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
#import "LoginWindowController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) LoginWindowController *loginWindowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

  NSURLCredential *credential = [[MinuteDockCredentialStorage sharedCredentialStorage] credential];
  if (credential.hasPassword) {
    [[CurrentEntry sharedInstance] beginRefreshing];
  } else {
    [self login];
  }

  self.statusItemManager = [[StatusItemManager alloc] init];
  self.statusItemManager.delegate = self;
  self.popoverManager = [[PopoverManager alloc] initWithDetachedWindow:self.detachedWindow];
}

- (void)login {
  if (!_loginWindowController) {
    _loginWindowController = [[LoginWindowController alloc] init];
  }

  [self.loginWindowController showWindowWithCompletionHandler:^(NSURLCredential *credential) {
    [[MinuteDockCredentialStorage sharedCredentialStorage] setCredential:credential];
    [[CurrentEntry sharedInstance] beginRefreshing];
  }];
}


#pragma mark - StatusItemDelegate

- (void)statusItemPressed:(id)sender {
  NSStatusBarButton *button = (NSStatusBarButton *)sender;
  [self.popoverManager showPopoverRelativeToRect:[button bounds] ofView:sender preferredEdge:NSMaxYEdge];
}

@end
