//
//  SetupResponse.m
//  Feezly
//
//  Created by Paul Antonelli on 21/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "SetupResponse.h"

@interface SetupResponse ()

@property (nonatomic, readwrite) NSDictionary *jsonDict;
@property (nonatomic, readwrite) BOOL askRating;
@property (nonatomic, readwrite) BOOL askPush;

@end

@implementation SetupResponse

- (instancetype)initWithDict:(NSDictionary *)dict error:(NSError *)error
{
    self = [super initWithDict:dict error:error];
    if (self)
    {
        
        NSNumber *numTMP = [self.data objectForKey:kAskPuskKey];
        NilCheck(numTMP);
        _askPush = [numTMP boolValue];
        
        numTMP = [self.data objectForKey:kAskRatingsKey];
        NilCheck(numTMP);
        _askRating = [numTMP boolValue];
        
        
        NSDictionary *dictTMP = [self.data objectForKey:kTextsKey];
        NilCheck(dictTMP);
        _jsonDict = [dictTMP copy];

    }
    
    return self;
}

@end
