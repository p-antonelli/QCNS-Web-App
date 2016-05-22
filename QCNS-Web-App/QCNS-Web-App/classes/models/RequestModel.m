//
//  RequestModel.m
//  Key4Lead
//
//  Created by Paul Antonelli on 06/08/2015.
//  Copyright (c) 2015 NYX INFO. All rights reserved.
//

#import "RequestModel.h"
//#import "NSString+MD5.h"
#import "NSString+URLEncode.h"

@implementation RequestModel

static NSDictionary *errorDict;
//static NSDictionary *stateDict;
+ (void)initialize
{
    if (self == [RequestModel class])
    {
        errorDict = @{
                      @(WSBadRequestErrorCode)          : @(HTTPBadRequestErrorCode),
                      @(WSBadParamsErrorCode)           : @(HTTPBadParamsErrorCode),
                      @(WSMissingParamErrorCode)        : @(HTTPMissingParamErrorCode),
                      @(WSInvalidAPITokenErrorCode)     : @(HTTPInvalidAPITokenErrorCode),
                      @(WSInvalidUserTokenErrorCode)    : @(HTTPInvalidUserTokenErrorCode),

                      @(WSInvalidLoginParamsErrorCode)  : @(HTTPAuthAPIErrorCode),
                      @(WSAccountNotConfirmedErrorCode) : @(HTTPAuthAPIErrorCode),
                      @(WSAccountBlockedErrorCode)      : @(HTTPAuthAPIErrorCode),
                      @(WSUnknownEmailAddressErrorCode) : @(HTTPAuthAPIErrorCode),
                      @(WSInvalidActionOnAccount)       : @(HTTPAuthAPIErrorCode),
                      };
    }
}

+ (NSURL *)urlWithPath:(NSString *)path
{
    return [[self class] urlWithPath:path cacheKiller:NO];
}
+ (NSURL *)urlWithPath:(NSString *)path cacheKiller:(BOOL)useCacheKiller
{
    return [[self class] urlWithPath:path params:nil cacheKiller:useCacheKiller];
}


+ (NSURL *)urlWithPath:(NSString *)path params:(NSDictionary *)params
{
    return [[self class] urlWithPath:path params:params cacheKiller:NO];
}
+ (NSURL *)urlWithPath:(NSString *)path params:(NSDictionary *)params cacheKiller:(BOOL)useCacheKiller
{
    if (!path || [path length] == 0) {
        DDLogError(@"### Invalid Path : %@", path);
        return nil;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kDefaultBaseUrl, path];
    
    if (params)
    {
        NSMutableString *paramStr = [NSMutableString stringWithCapacity:0];
        id objectTMP = nil;
        for (NSString *key in params)
        {
            // get param value
            objectTMP = params[key];
            
            if ([objectTMP isKindOfClass:[NSArray class]])
            {
                // add param name
                [paramStr appendFormat:@"%@=", [key urlEncodeUsingEncoding:NSUTF8StringEncoding]];
                
                // add param value
                NSArray *arr = objectTMP;
                for (id val in arr)
                {
                    if ([val isKindOfClass:[NSNumber class]])
                    {
                        [paramStr appendFormat:@"%ld,", (long)[val integerValue]];
                    }
                    else
                    {
                        [paramStr appendFormat:@"%@,", [val urlEncodeUsingEncoding:NSUTF8StringEncoding]];
                    }
                }
                
                // remove last ','
                [paramStr deleteCharactersInRange:NSMakeRange([paramStr length] - 1, 1)];
//                paramStr = [[paramStr urlEncodeUsingEncoding:NSUTF8StringEncoding] mutableCopy];
                
                // add '&' for new param if needed
                [paramStr appendString:@"&"];
            }
            else if ([objectTMP isKindOfClass:[NSString class]])
            {
                [paramStr appendFormat:@"%@=%@&", [key urlEncodeUsingEncoding:NSUTF8StringEncoding], [objectTMP urlEncodeUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            {
                [paramStr appendFormat:@"%@=%@&", [key urlEncodeUsingEncoding:NSUTF8StringEncoding], objectTMP];
            }
        }

        // remove last '&'
        [paramStr deleteCharactersInRange:NSMakeRange([paramStr length] - 1, 1)];
        
        if (useCacheKiller)
        {
            [paramStr appendFormat:@"&vvvv=%d",(int)RANDOM_NUMBER(0, 10000)];
        }
        
//        paramStr = [[paramStr urlEncodeUsingEncoding:NSUTF8StringEncoding] mutableCopy];
        
        urlStr = [urlStr stringByAppendingFormat:@"?%@", paramStr];
    }
    else
    {
        if (useCacheKiller)
        {
            urlStr = [urlStr stringByAppendingFormat:@"?vvvv=%d",(int)RANDOM_NUMBER(0, 10000)];
        }
    }
    
//    if (useHash)
//    {
//        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
//        if ([array count] == 2)
//        {
//            NSString *hashStr = [array objectAtIndex:1];
//            urlStr = [urlStr stringByAppendingFormat:@"&hash=%@", [hashStr HASH]];
//        }
//    }

//    DDLogDebug(@"### URL STR : %@", urlStr);
    DDLogDebug(@"### URL : %@",[[NSURL URLWithString:urlStr] absoluteString]);
    
    return [NSURL URLWithString:urlStr];
}


//+ (WSErrorCode)wsErrorFromHTTPErrorCode:(HTTPErrorCode)httpErrorCode
//{
//    if (httpErrorCode == HTTPAuthAPIErrorCode)
//    {
//        return WSAuthGenericErrorCode;
//    }
//    
//    return [[[errorDict allKeysForObject:@(httpErrorCode)] objectAtIndex:0] integerValue];
//}
//
//+ (HTTPErrorCode)httpErrorFromWSErrorCode:(WSErrorCode)wsErrorCode
//{
//    return [[errorDict objectForKey:@(wsErrorCode)] integerValue];
//}


@end
