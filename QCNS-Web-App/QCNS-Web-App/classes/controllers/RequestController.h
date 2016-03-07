//
//  RequestController.h
//  Feezly
//
//  Created by Paul Antonelli on 10/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestController : NSObject

+ (instancetype)sharedInstance;

- (void)processSetupAction;


@end
