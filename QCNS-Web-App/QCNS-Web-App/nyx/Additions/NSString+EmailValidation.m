//
//  NSString+EmailValidation.m
//  Key4Lead
//
//  Created by Paul Antonelli on 19/10/2015.
//  Copyright © 2015 NYX INFO. All rights reserved.
//

#import "NSString+EmailValidation.h"


static BOOL regExpIsSetUp;
static NSRegularExpression *regExp;


@implementation NSString (EmailValidation)

- (BOOL)isValidEmailAddress:(NSString **)resEmailAddr
{
    DDLogWarn(@"self : %@", self);
    
    if (!regExpIsSetUp)
    {
        regExpIsSetUp = YES;
        [self setupRegExp];

    }
    
    
    *resEmailAddr = [self copy];
    if (nil != self && [self length] >= 5)
    {
        
        NSString *tmp = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        *resEmailAddr =  [tmp copy];
        
        if (nil != tmp && [tmp length] >= 5)
        {
            NSRange tmpRange = NSMakeRange(0, [tmp length]);
            NSRange range = [regExp rangeOfFirstMatchInString:tmp options:0 range:NSMakeRange(0, [tmp length])];
            
//            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
//            if ([emailTest evaluateWithObject:tmp])
            if (NSEqualRanges(range, tmpRange))
            {
                
                return YES;
            }
        }
    }

    return NO;
}

- (void)setupRegExp
{
//    NSString *atom = @"[-a-zA-Z0-9!#$%\\&\'*+\\/=?\\^_`{|}~]";
//    NSString *domain = @"([a-zA-Z0-9]([-a-zA-Z0-9]*[a-zA-Z0-9]+)?)";
//    NSString *emailRegEx = [NSString stringWithFormat:@"^%@+(\\.%@+)*@(%@{1,63}\\.)+%@{2,6}", atom, atom, domain, domain];
    
//    NSString *emailRegEx = @"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\\])";
    
//    NSString *emailRegEx = @"^\\s*[a-zA-Z0-9!#$%&'*+\\-/=?^_`{|}~]+(\\.[a-zA-Z0-9!#$%&'*+\\-/=?^_`{|}~]+)*@((\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})\\s*$";
//         NSString *emailRegEx = @"^*[a-zA-Z0-9!#$%&'*+\\-/=?^_`{|}~]+(\\.[a-zA-Z0-9!#$%&'*+\\-/=?^_`{|}~]+)*@((\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})*$";
    
    NSString *emailRegEx =  @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
                            @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
                            @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
                            @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
                            @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
                            @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
                            @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";

    NSError *error = nil;
    regExp = [[NSRegularExpression alloc] initWithPattern:emailRegEx options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSLog(@"########### REG EX : %@", regExp);
    NSLog(@"########### ERROR : %@", error);
}


@end
