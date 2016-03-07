//
//  NSDictionary+JSONFile.m
//  Axalfred
//
//  Created by Paul Antonelli on 11/06/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import "NSDictionary+JSONFile.h"

@implementation NSDictionary (JSONFile)

+ (NSDictionary *)dictionaryWithContentsOfJSONFile:(NSString *)fileLocation
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileLocation stringByDeletingPathExtension] ofType:[fileLocation pathExtension]];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    
    if (error)
    {
        DDLogError(@"JSON error : %@", error);
    }


    return result;
}

@end
