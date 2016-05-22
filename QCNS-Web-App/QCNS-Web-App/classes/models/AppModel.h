//
//  AppModel.h
//  Feezly
//
//  Created by Paul Antonelli on 10/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MenuItem.h"

#import "SetupAction.h"

@interface AppModel : NSObject


//@property (nonatomic, readonly) NSString *locale;
//@property (nonatomic, readonly) NSString *language;
//
// App data
//@property (nonatomic, readonly) BOOL askPush;
//@property (nonatomic, readonly) BOOL askRating;

@property (nonatomic, readonly) NSArray<MenuItem *> *menuItems;

@property (nonatomic, readonly) QCNSBrandType currentBrand;


+ (instancetype)sharedInstance;

- (void)updateWithSetupAction:(SetupAction *)action;



@end
