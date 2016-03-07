//
//  NSDictionary+JSONFile.h
//  Axalfred
//
//  Created by Paul Antonelli on 11/06/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONFile)

+ (NSDictionary *)dictionaryWithContentsOfJSONFile:(NSString *)fileLocation;

@end
