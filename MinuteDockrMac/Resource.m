//
//  Resource.m
//  MinuteDockrMac
//
//  Created by Nate Armstrong on 10/20/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

#import "Resource.h"
#import "MinuteDockCredentialStorage.h"
#import "NSString+ActiveSupportInflector.h"

NSString * const kMINUTE_DOCK_API_VERSION = @"v1";

@interface Resource ()

@end

@implementation Resource

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  return [super init];
}

+ (void)query:(ArrayResourceBlock)block {
  NSString *path = [NSString stringWithFormat:@"%@.json", [self pluralResourceName]];
  [self requestURL:path as:HTTPMethodGet expectArray:YES sendParams:nil withBlock:block];
}

+ (void)get:(NSUInteger)unique withBlock:(ObjectResourceBlock)block {
  NSString *path = [NSString stringWithFormat:@"%@/%ld.json", [self pluralResourceName], (long)unique];
  [self requestURL:path as:HTTPMethodGet expectArray:NO sendParams:nil withBlock:block];
}

+ (void)requestURL:(NSString *)urlString as:(HTTPMethod)method expectArray:(BOOL)isArray sendParams:(NSDictionary *)params
         withBlock:(void (^)(id response, NSError *error))block {
  NSURLComponents *urlComponents = [self URLComponents];
  urlComponents.path = [NSString stringWithFormat:@"/api/%@/%@", kMINUTE_DOCK_API_VERSION, urlString];
  NSURL *url = [urlComponents URL];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  switch (method) {
    case HTTPMethodPost:
      request.HTTPMethod = @"POST";
      request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
      break;
    case HTTPMethodPut:
      request.HTTPMethod = @"PUT";
      request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
      break;
    default:
      break;
  }
  NSOperationQueue *queue = [NSOperationQueue mainQueue];
  [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    if (data) {
      if (isArray) {
        NSMutableArray *resources = [[NSMutableArray alloc] init];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          NSDictionary *resourceDictionary = (NSDictionary *)obj;
          [resources addObject:[[self alloc] initWithDictionary:resourceDictionary]];
        }];
        block(resources, error);
      } else {
        NSDictionary *resourceDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        Resource *resource = [[self alloc] initWithDictionary:resourceDictionary];
        block(resource, error);
      }
    } else {
      block(nil, error);
    }
  }];
}

+ (NSURLComponents *)URLComponents{
  NSURLComponents *components = [NSURLComponents componentsWithString:@"https://minutedock.com"];
  components.user = self.credential.user;
  components.password = self.credential.password;
  return components;
}

+ (NSString *)pluralResourceName {
  return [self.resourceName pluralizeString];
}

+ (NSString *)resourceName {
  return @"";
}

- (NSString *)memberPath {
  return [NSString stringWithFormat:@"%@/%lu.json", [[self class] pluralResourceName], (unsigned long)self.unique];
}

+ (NSURLCredential *)credential {
  return [[MinuteDockCredentialStorage sharedCredentialStorage] credential];
}

- (void)updateAttribute:(NSString *)attribute withValue:(id)value block:(ObjectResourceBlock)block {
  [self setValue:value forKey:attribute];
  [self putWithBlock:block];
}

- (void)updateAttributes:(NSDictionary *)attributes block:(ObjectResourceBlock)block {
  [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    [self setValue:obj forKey:key];
  }];
  [self putWithBlock:block];
}

- (void)putWithBlock:(ObjectResourceBlock)block {
  [[self class] requestURL:[self memberPath] as:HTTPMethodPut expectArray:NO sendParams:@{[[self class] resourceName]: [self safeAttributes]} withBlock:block];
}

- (NSDictionary *)safeAttributes {
  return @{};
}

@end