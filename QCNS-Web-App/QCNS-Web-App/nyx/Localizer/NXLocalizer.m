//
//  NXLocalizer.m
//  NXFramework
//
//  Created by Paul Antonelli on 05/05/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

#import "NXLocalizer.h"
#import "NSDictionary+Cascade.h"



@interface NXLocalizer ()

// Localized data
@property (nonatomic, strong) NSMutableDictionary *data;

@end



@implementation NXLocalizer

#pragma mark - Shared instance
+ (instancetype)sharedInstance
{
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });}

#pragma amark - Constructor
- (id)init
{
    if (self = [super init])
    {
        // Default language
        self.currentLocale = NX_LOCALIZER_DEFAULT_LOCALE;
        
        // Default invalid string
        self.invalidString = NX_LOCALIZER_DEFAULT_INVALID_STRING;
        
        // Instantiate data dic
        self.data = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark - Localizer
- (NSString *)localizedString:(NSString *)key
{
    return [self localizedString:key fallback:nil];
}

- (NSString *)localizedString:(NSString *)key fallback:(NSString *)fallback;
{
//    NSLog(@"key : %@", key);
    id obj = [[_data objectForKey:_currentLocale] objectForCascadeKey:key];
    if (!obj || ![obj isKindOfClass:[NSString class]])
        return fallback ?: _invalidString;
    
    return obj;
}

- (void)loadLocalizationData:(NSDictionary *)data forLocale:(NSString *)locale
{
    // Insert new data
    [_data setObject:data forKey:locale];
    _currentLocale = [locale copy];
    
    // Notify if necessary
    if ([locale isEqualToString:_currentLocale])
        [NOTIFICATION_CENTER postNotificationName:NX_LOCALIZER_CURRENT_LOCALE_DATA_UPDATED_NOTIFICATION object:nil];
}

#pragma mark - Getters
- (NSArray *)availableLocales
{
    return [_data allKeys];
}

#pragma mark - Setters
- (void)setCurrentLanguage:(NSString *)newCurrentLocale
{
    if (!newCurrentLocale || [_currentLocale isEqualToString:newCurrentLocale])
        return;
    
    // Hold new language as current language
    _currentLocale = newCurrentLocale;
    
    // Notify that language as changed
    [NOTIFICATION_CENTER postNotificationName:NX_LOCALIZER_CURRENT_LOCALE_CHANGED_NOTIFICATION object:_currentLocale];
}

@end
