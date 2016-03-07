//
//  NSString+NXContainsString.h
//  Feezly
//
//  Created by Paul Antonelli on 03/03/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NXContainsString)

- (BOOL)nx_containsString:(NSString *)aString;
- (BOOL)nx_containsStringCaseInsensitive:(NSString *)aString;

@end
