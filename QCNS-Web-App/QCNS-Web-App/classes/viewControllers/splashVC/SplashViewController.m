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


@interface SplashViewController ()

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
//    [[RequestController sharedInstance] processSetupAction];
    dispatch_after_delay_on_main_queue(3.0f, ^{
        
        [self pushHomeVC];
    });
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
//    self.view.backgroundColor = RANDOM_COLOR;
}

- (void)pushHomeVC
{
    DDLogInfo(@"");
//    MeetingsViewController *mainVC = [[MeetingsViewController alloc] initWithNibName:nil bundle:nil];
    [[AppController sharedInstance] hideWaitingView];
    
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        
        if ([[self.navigationController.viewControllers firstObject] isKindOfClass:[SplashViewController class]]) {
            
            NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
            [mutArr addObjectsFromArray:self.navigationController.viewControllers];
            [mutArr removeObjectAtIndex:0];
            [self.navigationController setViewControllers:mutArr];

        }


        dispatch_after_delay_on_main_queue(1.0, ^{
            [[AppController sharedInstance] hideSplashImage];
        });

    }];
//    [self.navigationController setViewControllers:@[mainVC] animated:YES];
    [[self navigationController] pushViewController:mainVC animated:YES];
    [CATransaction commit];
}

#pragma mark - Request Notification

- (void)setupActionDidSucceed:(NSNotification *)notification
{
    DDLogDebug(@"notif : %@", notification);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self pushHomeVC];
    });
}
- (void)setupActionDidFail:(NSNotification *)notification
{
    DDLogError(@"notif : %@", notification);
    
    SetupAction *action = [notification object];
    [NXAlertViewFactory alertWithTitle:NX_LOCALIZED_STRING(@"common.error") message:action.response.reqError.message
                            yesCaption:NX_LOCALIZED_STRING(@"common.retry") noCaption:nil yesBlock:^{
                                
                                [[RequestController sharedInstance] processSetupAction];
                                
                            }noBlock:nil];
    
}

@end