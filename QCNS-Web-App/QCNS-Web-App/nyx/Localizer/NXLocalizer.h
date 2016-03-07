//
//  NXLocalizer.h
//  NXFramework
//
//  Created by Paul Antonelli on 05/05/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

#define NX_LOCALIZER_DEFAULT_INVALID_STRING        @"Invalid"
#define NX_LOCALIZER_DEFAULT_LOCALE                @"fr_FR"

#define NX_LOCALIZER_CURRENT_LOCALE_CHANGED_NOTIFICATION           @"NX_LOCALIZER_CURRENT_LOCALE_CHANGED"
#define NX_LOCALIZER_CURRENT_LOCALE_DATA_UPDATED_NOTIFICATION      @"NX_LOCALIZER_CURRENT_LOCALE_DATA_UPDATED"

#define REGISTER_FOR_LOCALE_DATA_UPDATE [NOTIFICATION_CENTER addObserver:self selector:@selector(refreshLanguageUI) name:NX_LOCALIZER_CURRENT_LOCALE_DATA_UPDATED_NOTIFICATION object:nil]

#import <Foundation/Foundation.h>


@interface NXLocalizer : NSObject

// Shared instance
+ (instancetype)sharedInstance;

// Returns localized string according to given key, with or without fallback
- (NSString *)localizedString:(NSString *)key;
- (NSString *)localizedString:(NSString *)key fallback:(NSString *)fallback;

// Insert localization data into localizer to be served by the localizedString: method
- (void)loadLocalizationData:(NSDictionary *)data forLocale:(NSString *)locale;

// List of all available locales
- (NSArray *)availableLocales;

// Currently used language, initialized with default: en
@property (nonatomic, strong) NSString *currentLocale;

// Invalid string, initialized with default: Invalid
@property (nonatomic, strong) NSString *invalidString;

@end
