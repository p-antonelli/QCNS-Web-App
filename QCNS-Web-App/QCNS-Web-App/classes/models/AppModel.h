//
//  AppModel.h
//  Feezly
//
//  Created by Paul Antonelli on 10/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MenuSection.h"
#import "MenuItem.h"

#import "SetupAction.h"

@interface AppModel : NSObject

@property (nonatomic, readonly) QCNSBrandType currentBrand;
@property (nonatomic, readonly) NSString *splashImageName;
@property (nonatomic, readonly) NSString *navBarImageName;
@property (nonatomic, readonly) UIColor *navBarBGColor;

@property (nonatomic, readonly) NSString *locale;
@property (nonatomic, readonly) NSString *language;

@property (nonatomic, readonly) NSString *baseURL;
@property (nonatomic, readonly) NSString *backgroundImageURL;
@property (nonatomic, readonly) BOOL shouldCallDirectly;

@property (nonatomic, readonly) NSString *phoningTitle;
@property (nonatomic, readonly) NSString *phoningNumber;
@property (nonatomic, readonly) NSString *phoningHours;

@property (nonatomic, readonly) NSArray<MenuSection *> *menuSections;

@property (nonatomic, readonly) NSArray<NSString *> *imageURLs;



+ (instancetype)sharedInstance;

- (void)updateWithSetupAction:(SetupAction *)action;



@end
