//
//  NSObject+RunTimeDescription.m
//  Key4Lead
//
//  Created by Paul Antonelli on 20/08/2015.
//  Copyright (c) 2015 NYX INFO. All rights reserved.
//

#import "NSObject+RunTimeDescription.h"
#import <objc/runtime.h>

@implementation NSObject (RunTimeDescription)

- (NSString *)nx_description
{
    NSMutableString *debugDescription = [NSMutableString string];
    [debugDescription appendFormat:@"\n<%@ %p:\n", [self class], self];
    
    unsigned int outCount = -1;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (unsigned int i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char * propertyName = property_getName(property);
        
        NSString *propertyNameAsString = [NSString stringWithUTF8String:propertyName];
        id value = [self valueForKey:propertyNameAsString];
        
        [debugDescription appendFormat:@"\n\t%@ = %@", propertyNameAsString, value];
    }
    
    [debugDescription appendString:@" >\n"];
    
    free(properties);
    
    return [NSString stringWithString:debugDescription];
}

@end
