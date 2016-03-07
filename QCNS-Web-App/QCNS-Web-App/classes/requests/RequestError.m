//
//  RequestError.m
//  Feezly
//
//  Created by Paul Antonelli on 10/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "RequestError.h"

@interface RequestError ()

@property (nonatomic, readwrite) NSInteger code;
@property (nonatomic, readwrite) NSString *message;
@property (nonatomic, readwrite) NSDictionary *fields;

@end

@implementation RequestError

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        NSNumber *numTMP = [dict objectForKey:kCodeKey];
        NilCheck(numTMP);
        _code = [numTMP integerValue];
        
        NSString *strTMP = [dict objectForKey:kMessageKey];
        NilCheck(strTMP);
        _message = [strTMP copy];
        
        NSDictionary *dictTMP = [dict objectForKey:kErrorFieldsKey];
        NilCheck(dictTMP);
        _fields = [dictTMP copy];
    }
    return self;
}

- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message fields:(NSDictionary *)fields
{
    self = [super init];
    if (self)
    {
        _code = code;
        _message = [message copy];
        _fields = [fields copy];
    }
    return self;
}

@end
