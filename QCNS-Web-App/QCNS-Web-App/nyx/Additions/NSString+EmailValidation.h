//
//  NSString+EmailValidation.h
//  Key4Lead
//
//  Created by Paul Antonelli on 19/10/2015.
//  Copyright © 2015 NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EmailValidation)

- (BOOL)isValidEmailAddress:(NSString **)resEmailAddr;

@end
