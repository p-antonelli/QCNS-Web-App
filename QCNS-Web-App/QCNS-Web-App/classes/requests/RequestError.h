//
//  RequestError.h
//  Feezly
//
//  Created by Paul Antonelli on 10/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestError : NSObject

@property (nonatomic, readonly) NSInteger code;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSDictionary *fields;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message fields:(NSDictionary *)fields;

@end
