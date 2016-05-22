//
//  RequestModel.h
//  Key4Lead
//
//  Created by Paul Antonelli on 06/08/2015.
//  Copyright (c) 2015 NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestModel : NSObject

+ (NSURL *)urlWithPath:(NSString *)path;
+ (NSURL *)urlWithPath:(NSString *)path cacheKiller:(BOOL)useCacheKiller;


// Params : {@"paramName" : @"paramValue", ...}   ONLY NSSTRING
+ (NSURL *)urlWithPath:(NSString *)path params:(NSDictionary *)params;
+ (NSURL *)urlWithPath:(NSString *)path params:(NSDictionary *)params cacheKiller:(BOOL)useCacheKiller;
//+ (NSURL *)urlWithPath:(NSString *)path params:(NSDictionary *)params cacheKiller:(BOOL)useCacheKiller hash:(BOOL)useHash;

//+ (WSErrorCode)wsErrorFromHTTPErrorCode:(HTTPErrorCode)httpErrorCode;
//+ (HTTPErrorCode)httpErrorFromWSErrorCode:(WSErrorCode)wsErrorCode;

@end
