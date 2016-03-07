//
//  AppPrefs.m
//  Feezly
//
//  Created by Paul Antonelli on 09/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "AppPrefs.h"


/**
 * Environment variables
 */

#if (APP_DEV)

// fbID PoloBBStudio : 100004858780676

NSString * const kDefaultBaseUrl                    = @"http://www.feezly.com/api/v1/";
NSString * const kDefaultImgBaseUrl                 = @"http://www.feezly.com";

const NSInteger kRequestTimeoutDuration             = 40;


#elif (APP_RECETTE)

NSString * const kDefaultBaseUrl                    = @"http://www.feezly.com/api/v1/";
NSString * const kDefaultImgBaseUrl                 = @"http://www.feezly.com";

const NSInteger kRequestTimeoutDuration             = 40;

#elif (APP_PROD)

#warning TODO CONFIG
//NSString * const kDefaultBaseUrl                    = @"http://192.168.1.43:8087/api/";
//NSString * const kDefaultImgBaseUrl                 = @"http://www.feezly.com/";

//const NSInteger kRequestTimeoutDuration             = 40;

#else

#error "No Configuration set in AppPrefs.h (APP_DEV | APP_RECETTE | APP_PROD)"

#endif
