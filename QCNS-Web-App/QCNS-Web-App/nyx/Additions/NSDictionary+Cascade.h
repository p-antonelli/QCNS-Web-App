//
//  NSDictionary+Cascade.h
//  NXFramework
//
//  Created by Paul Antonelli on 05/05/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

@interface NSDictionary (Cascade)

// Returns an object according to a given cascade key, default separator is dot
- (id)objectForCascadeKey:(NSString *)key;

// Returns an object according to a given cascade key using a custom separator
- (id)objectForCascadeKey:(NSString *)key separator:(NSString *)separator;

@end
