//
//  AppPrefs.h
//  Feezly
//
//  Created by Paul Antonelli on 09/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

@import Foundation;

// Define App Environment

#define APP_DEV         1
#define APP_RECETTE     0
#define APP_PROD        0




/**
 * Configuration
 */

// Base url where we hit, based on configuration (APP_DEV | APP_RECETTE | APP_PROD)

extern NSString * const kDefaultBaseUrl;
extern NSString * const kDefaultImgBaseUrl;

extern const NSInteger kRequestTimeoutDuration;
