//
//  MinuteDockClient.m
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/10/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "MinuteDockClient.h"

@interface MinuteDockClient ()

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end

@implementation MinuteDockClient

- (instancetype)init {
  if (self = [super init]) {
    self.username = @"nate@custombit.com";
    self.password = @"Armstrong!0";
  }
  return self;
}

- (void)getCurrentEntryWithCompletionHandler:(void (^)(NSDictionary *entry, NSError *error))completionHandler {
  NSURLComponents *URLComponents = [self URLComponents];
  URLComponents.path = @"/api/v1/entries/current.json";
  NSURL *URL = [URLComponents URL];

  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
  NSOperationQueue *queue = [NSOperationQueue mainQueue];

  [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    if (data) {
      NSDictionary *entry = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
      completionHandler(entry, error);
    } else {
      completionHandler(nil, error);
    }
  }];
}

- (void)setCurrentEntryActive:(BOOL)active withCompletionHandler:(void (^)(NSDictionary *entry, NSError *error))completionHandler {
  NSURLComponents *URLComponents = [self URLComponents];
  URLComponents.path = @"/api/v1/entries/current/start.json";
  NSURL *URL = [URLComponents URL];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
  request.HTTPMethod = @"POST";
  NSOperationQueue *queue = [NSOperationQueue mainQueue];

  [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    if (data) {
      NSDictionary *entry = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
      completionHandler(entry, error);
    } else {
      completionHandler(nil, error);
    }
  }];
}

- (void)stopCurrentEntryWithCompletionHandler:(void (^)(NSDictionary *entry, NSError *error))completionHandler {
}

- (NSURLComponents *)URLComponents {
  NSURLComponents *components = [NSURLComponents componentsWithString:@"https://minutedock.com"];
  components.user = self.username;
  components.password = self.password;
  return components;
}

@end
