//
//  NSDictionary+Cascade.m
//  NXFramework
//
//  Created by Paul Antonelli on 05/05/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

#import "NSDictionary+Cascade.h"



@implementation NSDictionary (Cascade)

#pragma mark - Cascade key object accessors
/**
 * Returns an object according to a given cascade key, default separator is dot
 */
- (id)objectForCascadeKey:(NSString *)key
{
    return [self objectForCascadeKey:key separator:@"."];
}

/**
 * Returns an object according to a given cascade key using a custom separator
 * This method is adapted from the work of Paul Antonelli (NSDictionary+JSONText category in Axalfred)
 */
- (id)objectForCascadeKey:(NSString *)key separator:(NSString *)separator
{
    // No available keys in dictionary
    if ([self count] == 0)
    {
        return nil;
    }
    
    // nil / empty key
    if (!key || [key length] == 0)
    {
        return nil;
    }
    
    // Malformed key
    NSArray *keysArray = [key componentsSeparatedByString:separator];
    if (!keysArray || [keysArray count] == 0)
    {
        return nil;
    }
    
    // Prepare loop variables
    NSInteger count = [keysArray count];
    NSString *keyTmp = nil;
    NSDictionary *dictTmp = [NSDictionary dictionaryWithDictionary:self];
    id objTmp = nil;
    
    // Loop over key components
    for (NSInteger i = 0; i < count; i++)
    {
        // Get key part
        keyTmp = keysArray[i];
        
        // Get associated object in json dict
        objTmp = [dictTmp objectForKey:keyTmp];
        
        // Test current iteration
        if (i < count - 1)
        {
            // Not the last iteration
            if (objTmp && [objTmp isKindOfClass:[NSDictionary class]])
            {
                dictTmp = (NSDictionary *)objTmp; // it is a valid NSDictionary, go deeper...
            }
            else
            {
                break; // Invalid object
            }
        }
        else
        {
            // Last iteration
            if (objTmp)
            {
                return objTmp;
            }
        }
    }
    
    return nil;
}

@end
