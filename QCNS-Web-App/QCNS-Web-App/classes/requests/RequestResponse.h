//
//  RequestResponse.h
//  Key4Lead
//
//  Created by Paul Antonelli on 06/08/2015.
//  Copyright (c) 2015 NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestError.h"

@interface RequestResponse : NSObject

@property (nonatomic, readonly) NSDictionary *data;
@property (nonatomic, readonly) NSDictionary *meta;

@property (nonatomic, readonly) NSString *message;

@property (nonatomic, readonly) NSError *httpError;
@property (nonatomic, readonly) RequestError *reqError;

@property (nonatomic, readonly) BOOL shouldLogout;

- (instancetype)initWithDict:(NSDictionary *)dict error:(NSError *)error;

@end
