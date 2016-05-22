//
//  RequestResponse.m
//  Key4Lead
//
//  Created by Paul Antonelli on 06/08/2015.
//  Copyright (c) 2015 NYX INFO. All rights reserved.
//

#import "RequestResponse.h"

@interface RequestResponse ()

//@property (nonatomic, readwrite) NSDictionary *data;
//@property (nonatomic, readwrite) NSDictionary *meta;
//
//@property (nonatomic, readwrite) NSString *message;
//
//@property (nonatomic, readwrite) NSError *httpError;
//@property (nonatomic, readwrite) RequestError *reqError;
//
//@property (nonatomic, readwrite) BOOL shouldLogout;

@end

@implementation RequestResponse

- (instancetype)initWithDict:(NSDictionary *)dict error:(NSError *)error;
{
//    DDLogDebug(@"class %@ dict : %@", [self class], dict);
    DDLogDebug(@"class %@", [self class]);
    self = [super init];
    if (self)
    {
//        // http error
//        _httpError = [error copy];
//        
//        // data
//        NSDictionary *dictTMP = [dict objectForKey:kDataKey];
//        id tmp = nil;
//        NilCheck(dictTMP);
//        if (dictTMP)
//        {
//            _data = [NSDictionary dictionaryWithDictionary:dictTMP];
//        }
//        
//        // meta
//        dictTMP = [dict objectForKey:kMetaKey];
//        NilCheck(dictTMP);
//        if (dictTMP)
//        {
//            _meta = [NSDictionary dictionaryWithDictionary:dictTMP];
//        }
//        
//        // api error
//        tmp = [dict objectForKey:kErrorKey];
//        NilCheck(tmp);
//        if (tmp)
//        {
//            if ([tmp isKindOfClass:[NSString class]])
//            {
//                _reqError = [[RequestError alloc] initWithCode:0 message:tmp fields:nil];
//            }
//            else if ([tmp isKindOfClass:[NSDictionary class]])
//            {
//                _reqError = [[RequestError alloc] initWithDict:tmp];
//            }
//        }
//        
//        // message (optional)
//        NSString *strTMP = [dict objectForKey:kMessageKey];
//        NilCheck(strTMP);
//        if (strTMP)
//        {
//            _message = [strTMP copy];
//        }
//        
//        // check if message key is present in data dict
//        if ([_message length] == 0 && _data)
//        {
//            strTMP = [_data objectForKey:kMessageKey];
//            NilCheck(strTMP);
//            if (strTMP)
//            {
//                _message = [strTMP copy];
//            }
//        }
//        
//        if ([_message length] == 0 && error)
//        {
//            _message = [error localizedDescription];
//        }
//        
//        DDLogError(@"######### LOGOUT CODE : %ld %ld", (long)self.httpError.code, (long)self.reqError.code);
//        
//        if (self.reqError.code == WSInvalidUserTokenErrorCode)
//        {
//            DDLogError(@"####### SHOULD LOGOUT ! ! ! ! !");
//            _shouldLogout = YES;
//        }
    }
    return self;
}

@end