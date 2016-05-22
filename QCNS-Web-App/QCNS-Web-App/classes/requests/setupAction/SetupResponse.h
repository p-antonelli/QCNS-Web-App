//
//  SetupResponse.h
//  Feezly
//
//  Created by Paul Antonelli on 21/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "RequestResponse.h"
#import "MenuSection.h"

@interface SetupResponse : RequestResponse

@property (nonatomic, readonly) NSString *baseURL;
@property (nonatomic, readonly) NSString *backgroundImageURL;
@property (nonatomic, readonly) BOOL shouldCallDirectly;

@property (nonatomic, readonly) NSString *phoningTitle;
@property (nonatomic, readonly) NSString *phoningNumber;
@property (nonatomic, readonly) NSString *phoningHours;

@property (nonatomic, readonly) NSArray<MenuSection *> *menuSections;


@end
