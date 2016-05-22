//
//  AppController.h
//  Feezly
//
//  Created by Paul Antonelli on 10/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IQKeyboardManager.h"


static NSString * const QCNSErrorDomain = @"QCNSErrorDomain";
typedef NS_ENUM(NSInteger, QCNSErrorCode) {
    QCNSPrefetchImagesErrorCode,
};

@protocol AppImageDelegate;


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

- (void)callButtonPressed:(id)sender;

- (void)processFetchAllImageWithDelegate:(id<AppImageDelegate>)delegate;

@end



@protocol AppImageDelegate <NSObject>

@required

- (void)applicationImagesDidFetchAtURLs:(NSArray *)imageURLs;
- (void)applicationImagesDidFailFetching:(NSError *)error;

@end