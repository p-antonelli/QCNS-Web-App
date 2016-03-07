//
//  NSURL+PathParameters.h
//  Feezly
//
//  Created by Paul Antonelli on 17/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (PathParameters)


- (NSURL *)URLByReplacingPathWithPath:(NSString *)path;
- (NSURL *)URLByAppendingPathWithRelativePath:(NSString *)path;
- (NSURL *)URLByAppendingParameters:(NSDictionary *)parameters;
- (NSURL *)URLByAppendingParameterName:(NSString *)parameter value:(id)value;

@end
