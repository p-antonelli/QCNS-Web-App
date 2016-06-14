//
//  AppController.m
//  Feezly
//
//  Created by Paul Antonelli on 10/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "AppController.h"
#import <SDWebImage/SDWebImagePrefetcher.h>
#import "NXLocalizer.h"
#import "MRProgress.h"

#import "AppModel.h"
#import "RequestController.h"

#import "SlideNavigationController.h"
#import "LeftMenuViewController.h"

#import "UIApplication+LocalNotification.h"


@import MessageUI;



@interface AppController ()

@property (nonatomic, readwrite) UIImageView *splashImageView;
@property (nonatomic, readwrite) BOOL splashImageIsShowing;

@property (nonatomic, readwrite) MRProgressOverlayView *progressOverlay;

@property (nonatomic, readwrite) NSInteger waitingViewShowCount;

@end

@implementation AppController

#pragma mark - Public

+ (instancetype)sharedInstance
{
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initInternal];
    });
}

- (void)setupLog
{
    // Start logging
    setenv("XcodeColors", "YES", 0);
    NXCustomFormatter *formatter = [[NXCustomFormatter alloc] init];
    
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [[DDASLLogger sharedInstance] setLogFormatter:formatter];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:LOG_FLAG_ERROR];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor orangeColor] backgroundColor:nil forFlag:LOG_FLAG_WARN];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor yellowColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:LOG_FLAG_DEBUG];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    // Test log
    NSLog(@"NSLog");
    DDLogError(@"LOG ERROR");
    DDLogWarn(@"LOG WARN");
    DDLogInfo(@"LOG INFO");
    DDLogDebug(@"LOG DEBUG");
}

- (void)showSplashImageWithCompletion:(void(^)())completionBlock
{
    DDLogInfo(@"");
    if (_splashImageIsShowing)
    {
        if (completionBlock)
        {
            completionBlock();
        }
        return;
    }
    
    _splashImageIsShowing = YES;
    
    if (!_splashImageView)
    {
        [self setupSplashImage];
    }
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_splashImageView];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         _splashImageView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         
                         if (completionBlock)
                         {
                             completionBlock();
                         }
                     }];

}
- (void)hideSplashImageWithCompletion:(void(^)())completionBlock
{
    if (!_splashImageIsShowing)
    {
        if (completionBlock)
        {
            completionBlock();
        }
        return;
    }
    
    _splashImageIsShowing = NO;
    [UIView animateWithDuration:0.5f
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionOverrideInheritedDuration
                     animations:^{
                         
                         _splashImageView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         DDLogDebug(@"########## ANIM FINISHED : %d", finished);
                         [_splashImageView removeFromSuperview];
                         
                         if (completionBlock)
                         {
                             completionBlock();
                         }
                     }];

}

- (void)showSplashImage
{ 
    DDLogInfo(@"");
    [self showSplashImageWithCompletion:nil];
}
- (void)hideSplashImage
{
    DDLogInfo(@"");
    [self hideSplashImageWithCompletion:nil];
}


- (void)showWaitingView
{
    [self showWaitingViewWithTitle:nil mode:MRProgressOverlayViewModeIndeterminateSmall];
}
- (void)showWaitingViewWithTitle:(NSString *)title
{
    [self showWaitingViewWithTitle:title mode:MRProgressOverlayViewModeIndeterminateSmall];
}
- (void)showSuccessWaitingViewWithTitle:(NSString *)title
{
    [self showWaitingViewWithTitle:title mode:MRProgressOverlayViewModeCheckmark];
}
- (void)showErrorWaitingViewWithTitle:(NSString *)title
{
    [self showWaitingViewWithTitle:title mode:MRProgressOverlayViewModeCross];
}
- (void)hideWaitingView
{
    [self hideWaitingViewWithCompletion:nil];
}

- (void)hideWaitingViewWithCompletion:(void(^)())completionBlock
{
    DDLogError(@"_waitingViewShowCount : %ld", (long)_waitingViewShowCount);
    
    @synchronized(self)
    {
        if (!self.progressOverlay)
        {
            DDLogError(@"##### Try hiding progressOverlay but is nil : %@ %ld", self.progressOverlay, (long)_waitingViewShowCount);
            
            if (completionBlock)
            {
                completionBlock();
            }
            return;
        }
        
        if (_waitingViewShowCount == 1)
        {
            [self.progressOverlay dismiss:YES completion:completionBlock];
            self.progressOverlay = nil;
        }
        
        if (_waitingViewShowCount == 0)
        {
            DDLogError(@"#### TRYING TO HIDE WAITING VIEW TO MUCH....");
            if (completionBlock)
            {
                completionBlock();
            }
            
            return;
        }
        
        _waitingViewShowCount--;
    }
}


- (void)enableIQKeyboardAutoToolbar
{
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
- (void)disableIQKeyboardAutoToolbar
{
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)callButtonPressed:(id)sender
{
    DDLogDebug(@"");
    [NXAlertViewFactory alertWithTitle:NX_LOCALIZED_STRING(@"common.call")
                               message:[[AppModel sharedInstance] phoningNumber]
                            yesCaption:NX_LOCALIZED_STRING(@"common.yes")
                             noCaption:NX_LOCALIZED_STRING(@"common.no")
                              yesBlock:^{
                                  
                                  NSString *phoneNumber = [[[AppModel sharedInstance] phoningNumber] stringByReplacingOccurrencesOfString:@" " withString:@""];
                                  NSString *telURL = [@"tel:" stringByAppendingString:phoneNumber];
                                  NSURL *url = [NSURL URLWithString:telURL];
                                  DDLogError(@"###### PHONE URL : %@ %@ %@", phoneNumber, telURL, url);
                                  [[UIApplication sharedApplication] openURL:url];
                                  
                              } noBlock:nil];
}

- (void)processFetchAllImageWithDelegate:(id<AppImageDelegate>)delegate
{
    AppModel *model = [AppModel sharedInstance];
    SDWebImagePrefetcher *fetcher = [SDWebImagePrefetcher sharedImagePrefetcher];
    fetcher.options = SDWebImageLowPriority | SDWebImageAllowInvalidSSLCertificates;
    
    
    __block NSArray *urlArray = [NSArray arrayWithArray:model.imageURLs];
    
    NSLog(@"image urls : %@", model.imageURLs);
    __block NSMutableArray *failedURLArr = [NSMutableArray arrayWithCapacity:0];
    
    DDLogDebug(@"url to fetch : %@", urlArray);
    
    [fetcher prefetchURLs:urlArray
                 progress:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls, NSString *url, BOOL success) {
                     
                     DDLogDebug(@"processing image : %@", url);
                     if (!success)
                     {
                         [failedURLArr addObject:url];
                     }
                     
                 }
                completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
                    
                    if (noOfSkippedUrls == 0)
                    {
                        if ([delegate respondsToSelector:@selector(applicationImagesDidFetchAtURLs:)])
                        {
                            [delegate applicationImagesDidFetchAtURLs:urlArray];
                        }
                    }
                    else
                    {
                        if ([delegate respondsToSelector:@selector(applicationImagesDidFailFetching:)]) {
                            
                            NSString *msg = [NSString stringWithFormat:@"Error prefetching image at URL : %@", failedURLArr];
                            
                            NSError *error = [NSError errorWithDomain:QCNSErrorDomain
                                                                 code:QCNSPrefetchImagesErrorCode
                                                             userInfo:@{ NSLocalizedDescriptionKey : msg}];
                            
                            [delegate applicationImagesDidFailFetching:error];
                        }
                    }
                }];
}

#pragma mark - Private

- (id)initInternal
{
    self = [super init];
    if (self)
    {
        
        [self setupNavigationBar];
        
//        [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
        [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
        
    }
    return self;
}


- (void)flushImageCaches
{
    DDLogWarn(@"#### FLUSHING IMAGE CACHES");
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)setupSplashImage
{
    DDLogDebug(@"");
    NSString *imageName = [[AppModel sharedInstance] splashImageName];
    _splashImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    _splashImageView.alpha = 0.0;
}

- (void)showWaitingViewWithTitle:(NSString *)title mode:(MRProgressOverlayViewMode)mode
{
    DDLogError(@"_waitingViewShowCount : %ld", (long)_waitingViewShowCount);
    @synchronized(self)
    {
        
        if (_waitingViewShowCount == 0)
        {

            UIWindow *currentWindow = [[UIApplication sharedApplication] keyWindow];
            if (!self.progressOverlay)
            {
                self.progressOverlay = [MRProgressOverlayView showOverlayAddedTo:currentWindow
                                                                           title:title ?: @""
                                                                            mode:mode
                                                                        animated:YES
                                        //                                                               stopBlock:^(MRProgressOverlayView *progressOverlayView){}];
                                                                       stopBlock:nil];
            }
            else
            {
                self.progressOverlay.titleLabelText = title ?: @"";
                self.progressOverlay.mode = mode;
                [self.progressOverlay show:YES];
            }
        }
        else if (_waitingViewShowCount > 0)
        {
            self.progressOverlay.titleLabelText = title ?: @"";
            self.progressOverlay.mode = mode;
        }
        
        _waitingViewShowCount++;
    }
}

- (void)setupNavigationBar
{
    DDLogDebug(@"");
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: BOLD_FONT(19.0f)
                                                           }];
}

- (void)dealloc
{
    DDLogWarn(@"");
}

@end
