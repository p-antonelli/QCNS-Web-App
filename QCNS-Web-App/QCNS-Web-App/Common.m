//
//  Common.m
//  Feezly
//
//  Created by Paul Antonelli on 09/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "Common.h"


#if (APP_DEV)
const int ddLogLevel = LOG_LEVEL_DEBUG;
#elif (APP_RECETTE)
const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
const int ddLogLevel = LOG_LEVEL_OFF;
#endif


// unused
NSString* NXLocalizedStringWithCode(NSString* key, NSString* def, NSString* code)
{
    
    static NSString *path;
    path = nil;
    
    static NSBundle *languageBundle;
    languageBundle = nil;
    
    //    NSLog(@"#### KEY : %@ CODE : %@", key, code);
    
    if (nil != key && nil != code) {
        
        path = [[NSBundle mainBundle] pathForResource:code ofType:@"lproj"];
        languageBundle = [NSBundle bundleWithPath:path];
        
        static NSString *resTmp = nil;
        resTmp = [languageBundle localizedStringForKey:key value:key table:nil];
        
        return (nil != resTmp) ? resTmp : NSLocalizedString(key, def);
        
    }else {
        return def;
    }
}

