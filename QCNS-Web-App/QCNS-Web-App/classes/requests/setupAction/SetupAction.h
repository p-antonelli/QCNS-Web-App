//
//  SetupAction.h
//  Feezly
//
//  Created by Paul Antonelli on 21/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "RequestAction.h"
#import "SetupResponse.h"

@interface SetupAction : RequestAction

@property (nonatomic, readonly) SetupResponse *response;

- (instancetype)init;


@end
