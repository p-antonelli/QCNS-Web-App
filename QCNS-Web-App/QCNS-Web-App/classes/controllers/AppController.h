//
//  AppController.h
//  Feezly
//
//  Created by Paul Antonelli on 10/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IQKeyboardManager.h"



@interface AppController : NSObject

+ (instancetype)sharedInstance;

- (void)setupLog;

- (void)showSplashImage;
- (void)hideSplashImage;

- (void)showSplashImageWithCompletion:(void(^)())completionBlock;
- (void)hideSplashImageWithCompletion:(void(^)())completionBlock;


- (void)showWaitingView;
- (void)showWaitingViewWithTitle:(NSString *)title;
- (void)showSuccessWaitingViewWithTitle:(NSString *)title;
- (void)showErrorWaitingViewWithTitle:(NSString *)title;

- (void)hideWaitingView;
- (void)hideWaitingViewWithCompletion:(void(^)())completionBlock;


- (void)enableIQKeyboardAutoToolbar;
- (void)disableIQKeyboardAutoToolbar;


@end
