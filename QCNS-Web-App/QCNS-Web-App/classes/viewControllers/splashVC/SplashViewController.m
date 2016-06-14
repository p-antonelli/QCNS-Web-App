//
//  SplashViewController.m
//  Feezly
//
//  Created by Paul Antonelli on 10/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "SplashViewController.h"

#import "MainViewController.h"

#import "NSObject+NXActionObserver.h"

#import "AppModel.h"
#import "AppController.h"

#import "SlideNavigationController.h"
#import "LeftMenuViewController.h"

#import "RequestController.h"
#import "AppDelegate.h"

#import "UIImageView+WebCache.h"

@interface SplashViewController () <AppImageDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *splashImageView;

@end

@implementation SplashViewController

#pragma mark - UIViewController LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DDLogDebug(@"");
    [self buildUIElements];
    
    [[SlideNavigationController sharedInstance] prepareMenuForReveal:MenuLeft];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogDebug(@"");
    [self addRequestsObservers];
    [[AppController sharedInstance] showSplashImage];
    [[AppController sharedInstance] showWaitingView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DDLogDebug(@"");
    [[RequestController sharedInstance] processSetupAction];
//    dispatch_after_delay_on_main_queue(3.0f, ^{
//        
//        [self pushHomeVC];
//    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    DDLogDebug(@"");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    DDLogDebug(@"");    
    [self removeRequestObservers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    DDLogWarn(@"");
    [self removeRequestObservers];
}

#pragma mark - Private

- (void)addRequestsObservers
{
    DDLogDebug(@"");
    [self addObserverForActionClass:[SetupAction class] actionState:NXHTTPActionStateSucceeded selector:@selector(setupActionDidSucceed:)];
    [self addObserverForActionClass:[SetupAction class] actionState:NXHTTPActionStateFailed selector:@selector(setupActionDidFail:)];
}
- (void)removeRequestObservers
{
    DDLogDebug(@"");
    [self removeObserverForActionClass:[SetupAction class] actionState:NXHTTPActionStateSucceeded];
    [self removeObserverForActionClass:[SetupAction class] actionState:NXHTTPActionStateFailed];
}

- (void)buildUIElements
{
    self.splashImageView.image = [UIImage imageNamed:[[AppModel sharedInstance] splashImageName]];
//    DDLogError(@"splash image : %@ %@",  [[AppModel sharedInstance] splashImageName], [UIImage imageNamed:[[AppModel sharedInstance] splashImageName]]);
}

- (void)pushHomeVC
{
    DDLogInfo(@"");

    [[AppController sharedInstance] hideWaitingViewWithCompletion:^{
        
        LeftMenuViewController *leftMenuVC = (LeftMenuViewController *)[[SlideNavigationController sharedInstance] leftMenu];
        [leftMenuVC selectFirstMenuRow];
        
        MainViewController *mainVC = [[MainViewController alloc] initWithNibName:nil bundle:nil];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            
            if ([[self.navigationController.viewControllers firstObject] isKindOfClass:[SplashViewController class]]) {
                
                NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
                [mutArr addObjectsFromArray:self.navigationController.viewControllers];
                [mutArr removeObjectAtIndex:0];
                [self.navigationController setViewControllers:mutArr];
                
                mainVC.urlToLoad = [NSURL URLWithString:[[AppModel sharedInstance] baseURL]];
            }
            
            dispatch_after_delay_on_main_queue(1.5, ^{
                [[AppController sharedInstance] hideSplashImage];
            });
            
        }];
        
        [[self navigationController] pushViewController:mainVC animated:YES];
        [CATransaction commit];
    }];
    
}

#pragma mark - Request Notification

- (void)setupActionDidSucceed:(NSNotification *)notification
{
    DDLogDebug(@"notif : %@", notification);
    LeftMenuViewController *leftVC = (LeftMenuViewController *)[[SlideNavigationController sharedInstance] leftMenu];
    [leftVC updateTexts];
    
    [[AppController sharedInstance] processFetchAllImageWithDelegate:self];
    
}
- (void)setupActionDidFail:(NSNotification *)notification
{
    DDLogError(@"notif : %@", notification);
    
//    SetupAction *action = [notification object];
    
    [[AppController sharedInstance] hideWaitingViewWithCompletion:^{
        
        [NXAlertViewFactory alertWithTitle:NX_LOCALIZED_STRING(@"common.error")
                                   message:NX_LOCALIZED_STRING(@"common.request_error_message")
                                yesCaption:NX_LOCALIZED_STRING(@"common.retry")
                                 noCaption:nil
                                  yesBlock:^{
                                      
                                      [[RequestController sharedInstance] processSetupAction];
                                      
                                  } noBlock:nil];
    }];
}

#pragma mark - AppImageDelegate

- (void)applicationImagesDidFetchAtURLs:(NSArray *)imageURLs
{
    DDLogInfo(@"");
    
    NSURL *url = [NSURL URLWithString:[[AppModel sharedInstance] backgroundImageURL]];
    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appD.backgroundImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"main-bg"]];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self pushHomeVC];
    });
}
- (void)applicationImagesDidFailFetching:(NSError *)error
{
    DDLogError(@"error : %@", error);
    
    NSURL *url = [NSURL URLWithString:[[AppModel sharedInstance] backgroundImageURL]];
    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appD.backgroundImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"main-bg"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self pushHomeVC];
    });
    
    
//    [[AppController sharedInstance] hideWaitingViewWithCompletion:^{
//        
//        [NXAlertViewFactory alertWithTitle:NX_LOCALIZED_STRING(@"common.error")
//                                   message:NX_LOCALIZED_STRING(@"common.request_error_message")
//                                yesCaption:NX_LOCALIZED_STRING(@"common.retry")
//                                 noCaption:nil
//                                  yesBlock:^{
//                                      
//                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                          
//                                          [[AppController sharedInstance] showWaitingView];
//                                          [[AppController sharedInstance] processFetchAllImageWithDelegate:self];
//                                      });
//                                      
//                                  }noBlock:nil];
//        
//    }];
}


@end