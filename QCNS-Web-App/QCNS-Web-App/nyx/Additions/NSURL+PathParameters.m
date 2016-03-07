//
//  NSURL+PathParameters.m
//  Feezly
//
//  Created by Paul Antonelli on 17/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NSURL+PathParameters.h"


#import "NSURL+PathParameters.h"

@interface NSString (URLParameters)

- (NSString *)stringByEscapingForURLArgument;

@end

@implementation NSString (URLParameters)

- (NSString *)stringByEscapingForURLArgument {
    // Encode all the reserved characters, per RFC 3986 (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *escapedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                  (CFStringRef)self,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'\"();:@&=+$,/?%#[] ",
                                                                                  kCFStringEncodingUTF8);
    return escapedString;
}

@end

@implementation NSURL (PathParameters)

- (NSURL *)URLByReplacingPathWithPath:(NSString *)path {
    // scheme://username:password@domain:port/path?query_string#fragment_id
    
    // Chop off path, query and fragment from absoluteString, then add new path and put back query and fragment
    
    NSString *absoluteString = [self absoluteString];
    NSUInteger endIndex = [absoluteString length];
    
    NSString *fragment = [self fragment];
    if (fragment) {
        endIndex -= [fragment length];
        endIndex--; // The # character
    }
    
    NSString *query = [self query];
    if (query) {
        endIndex -= [query length];
        endIndex--; // The ? character
    }
    
    // Check if the last character of the path is a slash (range must be valid as endIndex must be smaller or equal to length)
    BOOL trailingSlashOnPath = [[absoluteString substringWithRange:NSMakeRange(endIndex - 1, 1)] isEqualToString:@"/"];
    
    NSString *originalPath = [self path]; // This method strips any trailing slash "/"
    if (originalPath) {
        endIndex -= [originalPath length];
        if (trailingSlashOnPath && [originalPath length] > 1) { // Don't get confused with the starting slash
            endIndex--;
        }
    }
    
    absoluteString = [absoluteString substringToIndex:endIndex];
    absoluteString = [absoluteString stringByAppendingString:path];
    if (query) {
        absoluteString = [absoluteString stringByAppendingString:@"?"];
        absoluteString = [absoluteString stringByAppendingString:query];
    }
    if (fragment) {
        absoluteString = [absoluteString stringByAppendingString:@"#"];
        absoluteString = [absoluteString stringByAppendingString:fragment];
    }
    
    return [NSURL URLWithString:absoluteString];
}

- (NSURL *)URLByAppendingPathWithRelativePath:(NSString *)path {
    NSString *originalPath = [self path];
    NSString *combinedPath = [[originalPath stringByAppendingPathComponent:path] stringByStandardizingPath];
    // Don't standardize away a trailing slash
    if ([path length] > 1 && [path hasSuffix:@"/"]) {
        combinedPath = [combinedPath stringByAppendingString:@"/"];
    }
    return [self URLByReplacingPathWithPath:combinedPath];
}

- (NSURL *)URLByAppendingParameters:(NSDictionary *)parameters {
    NSMutableString *query = [[self query] mutableCopy];
    
    if (!query) {
        query = [NSMutableString stringWithString:@""];
    }
    
    // Sort parameters to be appended so that our solution is stable (and testable)
    NSArray *parameterNames = [parameters allKeys];
    parameterNames = [parameterNames sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSString *parameterName in parameterNames) {
        id value = [parameters objectForKey:parameterName];
        NSAssert3([parameterName isKindOfClass:[NSString class]], @"Got '%@' of type %@ as key for parameter with value '%@'. Expected an NSString.", parameterName, NSStringFromClass([parameterName class]), value);
        
        // The value needs to be an NSString, or be able to give us an NSString
        if (![value isKindOfClass:[NSString class]]) {
            if ([value respondsToSelector:@selector(stringValue)]) {
                value = [value stringValue];
            } else {
                // Fallback to simply giving the description
                value = [value description];
            }
        }
        
        if ([query length] == 0) {
            [query appendFormat:@"%@=%@", [parameterName stringByEscapingForURLArgument], [value stringByEscapingForURLArgument]];
        } else {
            [query appendFormat:@"&%@=%@", [parameterName stringByEscapingForURLArgument], [value stringByEscapingForURLArgument]];
        }
    }
    
    // scheme://username:password@domain:port/path?query_string#fragment_id
    
    // Chop off query and fragment from absoluteString, then add new query and put back fragment
    
    NSString *absoluteString = [self absoluteString];
    NSUInteger endIndex = [absoluteString length];
    
    
    NSString *fragment = [self fragment];
    if (fragment) {
        endIndex -= [fragment length];
        endIndex--; // The # character
    }
    
    NSString *originalQuery = [self query];
    if (originalQuery) {
        endIndex -= [originalQuery length];
        endIndex--; // The ? character
    }
    
    absoluteString = [absoluteString substringToIndex:endIndex];
    absoluteString = [absoluteString stringByAppendingString:@"?"];
    absoluteString = [absoluteString stringByAppendingString:query];
    if (fragment) {
        absoluteString = [absoluteString stringByAppendingString:@"#"];
        absoluteString = [absoluteString stringByAppendingString:fragment];
    }
    
    return [NSURL URLWithString:absoluteString];
}

- (NSURL *)URLByAppendingParameterName:(NSString *)parameter value:(id)value {
    return [self URLByAppendingParameters:[NSDictionary dictionaryWithObjectsAndKeys:value, parameter, nil]];
}

@end
