//
//  NSString+URLEncode.h
//  Feezly
//
//  Created by Paul Antonelli on 01/02/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncode)

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

@end
