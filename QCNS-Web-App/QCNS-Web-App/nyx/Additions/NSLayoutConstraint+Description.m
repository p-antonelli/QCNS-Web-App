//
//  NSLayoutConstraint+Description.m
//  Feezly
//
//  Created by Paul Antonelli on 04/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NSLayoutConstraint+Description.h"

@implementation NSLayoutConstraint (Description)

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@"< id: %@, constant: %f, firstItem : %@, secondItem : %@, firstAttr : %ld, secondAttr : %ld", self.identifier, self.constant, self.firstItem, self.secondItem, (long)self.firstAttribute, (long)self.secondAttribute];
}

@end