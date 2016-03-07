//
//  NSObject+RequestObserver.m
//  Feezly
//
//  Created by Paul Antonelli on 17/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NSObject+NXActionObserver.h"

@implementation NSObject (NXActionObserver)

- (void)addObserverForActionClass:(Class)actionClass
                     actionState:(NXHTTPActionState)state
                        selector:(SEL)selector
{
    NSString *name = [actionClass notificationNameForState:state];
    [NOTIFICATION_CENTER addObserver:self selector:selector name:name object:nil];
}

- (void)removeObserverForActionClass:(Class)actionClass
                        actionState:(NXHTTPActionState)state
{
    NSString *name = [actionClass notificationNameForState:state];
    [NOTIFICATION_CENTER removeObserver:self name:name object:nil];
}


@end
