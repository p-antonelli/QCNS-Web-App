//
//  BBDevice.h
//  Axalfred
//
//  Created by Paul Antonelli on 22/05/2014.
//  Copyright (c) 2014 BBS. All rights reserved.
//

#import <Foundation/Foundation.h>

// if set to 1, clean custom UDID stored in keychain
#define CLEAN_KEYCHAIN  0

@interface NXDevice : NSObject

@property (strong, nonatomic, readwrite) NSString *keychainServiceName;
@property (strong, nonatomic, readwrite) NSString *keychainAccountName;

+ (instancetype)sharedInstance;

+ (CGSize)screenSize;

+ (BOOL)has3dot5InchScreen;
+ (BOOL)has4InchScreen;
+ (BOOL)has4dot7InchScreen;
+ (BOOL)has5dot5InchScreen;

+ (BOOL)isRetina;
+ (BOOL)isIPhone;
+ (BOOL)isIPad;
+ (BOOL)isIPod;

+ (BOOL)isJailbroken;
+ (BOOL)appIsPirated;

+ (NSString *)documentsDirectory;

+ (void)printAllFontsAvailable;
+ (void)printAllPNGsInBundle;

// UIDevice name helper, eg : iPhone de Bibi
+ (NSString *)name;

// UIDevice systemVersion helper,eg : 7.0.1
+ (NSString *)osVersion;

// UIDevice model helper,eg : iPod Touch
+ (NSString *)modelName;

// eg : iPhone4,1
+ (NSString *)modelType;

// UIDevice bundleVersion helper
+ (NSString *)bundleVersion;

// custom UDID stored in keychain (base on keychainServiceName & keychain account name)
+ (NSString *)uniqueID;

// UIDevice identifierForVender helper
+ (NSString *)vendorID;

// eg : fr_FR, en_US
+ (NSString *)currentLocaleISO;

@end
