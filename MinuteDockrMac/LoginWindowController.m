//
//  LoginWindowController.m
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/23/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "LoginWindowController.h"

@interface LoginWindowController ()

@property (copy, nonatomic) void (^completionHandler)(NSURLCredential *credential);
@property (weak) IBOutlet NSTextField *email;
@property (weak) IBOutlet NSSecureTextField *password;

@end

@implementation LoginWindowController

- (instancetype)init {
  return [self initWithWindowNibName:@"LoginWindow" owner:self];
}

- (void)showWindowWithCompletionHandler:(void (^)(NSURLCredential *credential))completionHandler {
  [self showWindow:nil];
  self.completionHandler = completionHandler;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)loginButtonPressed:(id)sender {
  if (self.completionHandler) {
    NSURLCredential *credential = [NSURLCredential credentialWithUser:self.email.stringValue password:self.password.stringValue persistence:NSURLCredentialPersistenceNone];
    self.completionHandler(credential);
    [self close];
  }
}

@end
