//
//  MinuteDockCredentialStorage.m
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/20/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "MinuteDockCredentialStorage.h"

NSString * const kUSER_DEFAULTS_KEY = @"MinuteDockrUser";
NSString * const kSECURITY_SERVICE = @"MinuteDockr";

@implementation MinuteDockCredentialStorage

+ (instancetype)sharedCredentialStorage {
  static id sharedCredentialStorage;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedCredentialStorage = [[self alloc] init];
  });
  return sharedCredentialStorage;
}

- (NSURLCredential *)credential {
  NSString *user = [[NSUserDefaults standardUserDefaults] stringForKey:kUSER_DEFAULTS_KEY];

  NSDictionary *query = @{
                          (id)kSecClass: (id)kSecClassGenericPassword,
                          (id)kSecAttrService: kSECURITY_SERVICE,
                          (id)kSecAttrAccount: user ? user : @"",
                          (id)kSecReturnData: @YES,
                          };

  CFTypeRef result;
  SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
  NSString *password = [[NSString alloc] initWithData:(__bridge_transfer NSData *)result encoding:NSUTF8StringEncoding];

  if (![password length]) {
    password = nil;
  }

  return [NSURLCredential credentialWithUser:user password:password persistence:NSURLCredentialPersistenceNone];
}

- (void)setCredential:(NSURLCredential *)credential {
  [[NSUserDefaults standardUserDefaults] setObject:credential.user forKey:kUSER_DEFAULTS_KEY];

  NSDictionary *query = @{
                          (id)kSecClass: (id)kSecClassGenericPassword,
                          (id)kSecAttrService: kSECURITY_SERVICE,
                          (id)kSecAttrAccount: credential.user,
                          (id)kSecValueData: [credential.password dataUsingEncoding:NSUTF8StringEncoding]
                          };

  SecItemAdd((__bridge CFDictionaryRef)query, NULL);
}

- (void)removeCredential {
  NSString *user = [[NSUserDefaults standardUserDefaults] stringForKey:kUSER_DEFAULTS_KEY];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUSER_DEFAULTS_KEY];

  NSDictionary *query = @{
                          (id)kSecClass: (id)kSecClassGenericPassword,
                          (id)kSecAttrService: kSECURITY_SERVICE,
                          (id)kSecAttrAccount: user ? user : @""
                          };
  
  SecItemDelete((__bridge CFDictionaryRef)query);
}

@end
