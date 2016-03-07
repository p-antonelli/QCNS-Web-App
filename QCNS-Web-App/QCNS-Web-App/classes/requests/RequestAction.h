//
//  RequestAction.h
//  Key4Lead
//
//  Created by Paul Antonelli on 06/08/2015.
//  Copyright (c) 2015 NYX INFO. All rights reserved.
//

#import "NXHTTPJSONAction.h"
#import "RequestResponse.h"

@interface RequestAction : NXHTTPJSONAction

@property (nonatomic, readonly) RequestResponse *response;

@end
