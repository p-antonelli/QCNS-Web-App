//
//  NSObject+RequestObserver.h
//  Feezly
//
//  Created by Paul Antonelli on 17/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXHTTPAction.h"

@interface NSObject (NXActionObserver)

- (void)addObserverForActionClass:(Class)actionClass
                      actionState:(NXHTTPActionState)state
                         selector:(SEL)selector;

- (void)removeObserverForActionClass:(Class)actionClass
                         actionState:(NXHTTPActionState)state;


@end
