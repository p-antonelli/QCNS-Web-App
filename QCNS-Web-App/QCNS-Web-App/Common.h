//
//  Common.h
//  Feezly
//
//  Created by Paul Antonelli on 09/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>
//
// Log level
//

extern const int ddLogLevel;

//
// Shortcuts
//

#define MAIN_BUNDLE             [NSBundle mainBundle]
#define MAIN_SCREEN             [UIScreen mainScreen]
#define MAIN_SCREEN_BOUNDS      [[UIScreen mainScreen] bounds]
#define MAIN_SCREEN_WIDTH       CGRectGetWidth([[UIScreen mainScreen] bounds])
#define MAIN_SCREEN_HEIGHT      CGRectGetHeight([[UIScreen mainScreen] bounds])

#define NIB_NAMED(className)    [UINib nibWithNibName:NSStringFromClass([className class]) bundle:MAIN_BUNDLE]

#define NOTIFICATION_CENTER     [NSNotificationCenter defaultCenter]
#define FILE_MANAGER            [NSFileManager defaultManager]
#define USER_DEFAULTS           [NSUserDefaults standardUserDefaults]
#define APPLICATION             [UIApplication sharedApplication]


#define APPLICATION_IN_BG       ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)



//
// Localized string macro overide
//
//#define LOCALIZED_STRING(key)               NSLocalizedString(key, @"")
//#define LOCALIZED_STRING_FALL(key, fall)    NSLocalizedString(key, fall)

NSString *NXLocalizedStringWithCode(NSString *key, NSString *def, NSString *code);

#define LOCALIZED_STRING(key)               NXLocalizedStringWithCode(key, @"", [[AppModel sharedInstance] currentLangCode])

// Localized string macro overide
#define NX_LOCALIZED_STRING(key)   [[NXLocalizer sharedInstance] localizedString:key fallback:key]


//
// System version utils
//

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define INTEGRAL_FRAME(view)                           do { view.frame = CGRectIntegral(view.frame); } while(0)


//
// Singleton utils
//

#define SHARED_INSTANCE_USING_BLOCK(block)  \
static dispatch_once_t pred = 0;        \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{                 \
_sharedObject = block();            \
});                                     \
return _sharedObject;                   \

//
// JSON Utils
//

// set object to nil if isEqual [NSNull null]
#define NullCheck(__POINTER) do { if ([(NSObject *)__POINTER isEqual:[NSNull null]]) { __POINTER = nil; } } while(0)
// set object to nil if isEqual @""
#define StrCheck(__POINTER) do { if ([(NSObject *)__POINTER isEqual:@""]) { __POINTER = nil; } } while(0)
// set object to nil if (isEqual @"" or [NSNull null])
#define NilCheck(__POINTER) do { if ([(NSObject *)__POINTER isEqual:[NSNull null]] || [(NSObject *)__POINTER isEqual:@""]) { __POINTER = nil; } } while(0)

//
// colors utils
//

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define RGBCOLOR_A(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RANDOM_COLOR [UIColor colorWithRed:(rand()%255)/255.0f green:(rand()%255)/255.0 blue:(rand()%255)/255.0f alpha:0.5f]

//
// NSCoding Utils
//

#define OBJC_STRINGIFY(x) @#x

#define encodeObject(x) [aCoder encodeObject:x forKey:OBJC_STRINGIFY(x)]
#define decodeObject(x) x = [aDecoder decodeObjectForKey:OBJC_STRINGIFY(x)]

#define encodeFloat(x) [aCoder encodeFloat:x forKey:OBJC_STRINGIFY(x)]
#define decodeFloat(x) x = [aDecoder decodeFloatForKey:OBJC_STRINGIFY(x)]

#define encodeDouble(x) [aCoder encodeDouble:x forKey:OBJC_STRINGIFY(x)]
#define decodeDouble(x) x = [aDecoder decodeDoubleForKey:OBJC_STRINGIFY(x)]

#define encodeBool(x) [aCoder encodeBool:x forKey:OBJC_STRINGIFY(x)]
#define decodeBool(x) x = [aDecoder decodeBoolForKey:OBJC_STRINGIFY(x)]

#define encodeInteger(x) [aCoder encodeInteger:x forKey:OBJC_STRINGIFY(x)]
#define decodeInteger(x) x = [aDecoder decodeIntegerForKey:OBJC_STRINGIFY(x)]

#define encodeSize(x) [aCoder encodeCGSize:x forKey:OBJC_STRINGIFY(x)]
#define decodeSize(x) x = [aDecoder decodeCGSizeForKey:OBJC_STRINGIFY(x)]

//
//  Random
//

#define RANDOM_NUMBER(smallNumber, bigNumber) ((((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (bigNumber - smallNumber)) + smallNumber)

//
// Utils 
//
