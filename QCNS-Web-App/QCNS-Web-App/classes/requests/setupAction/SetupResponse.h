//
//  SetupResponse.h
//  Feezly
//
//  Created by Paul Antonelli on 21/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "RequestResponse.h"


@interface SetupResponse : RequestResponse

@property (nonatomic, readonly) NSDictionary *jsonDict;
@property (nonatomic, readonly) BOOL askRating;
@property (nonatomic, readonly) BOOL askPush;

@end
