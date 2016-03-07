//
//  UIView+Description.m
//  Feezly
//
//  Created by Paul Antonelli on 04/12/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "UIView+Description.h"

@implementation UIView (Description)

//- (NSString *)debugDescription
//{
//    return [[super description] stringByAppendingFormat:@" <translatesAutoresizingMaskIntoConstraints : %d, hasAmbiguousLayout : %d> ", self.translatesAutoresizingMaskIntoConstraints, self.hasAmbiguousLayout];
//}

- (void)printRecursiveDescription
{
#ifdef DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    NSLog(@"%@", [self performSelector:@selector(recursiveDescription)]);
#pragma clang diagnostic pop
#endif
}

- (void)printAutoLayoutTrace
{
#ifdef DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    NSLog(@"%@", [self performSelector:@selector(_autolayoutTrace)]);
#pragma clang diagnostic pop
#endif
}
//
//- (void)exerciseAmbiguityInLayoutRepeatedly:(BOOL)recursive
//{
//#ifdef DEBUG
//    if (self.hasAmbiguousLayout) {
//        [NSTimer scheduledTimerWithTimeInterval:.5
//                                         target:self
//                                       selector:@selector(exerciseAmbiguityInLayout)
//                                       userInfo:nil
//                                        repeats:YES];
//    }
//    if (recursive) {
//        for (UIView *subview in self.subviews) {
//            [subview exerciseAmbiguityInLayoutRepeatedly:YES];
//        }
//    }
//#endif
//}


@end
