//
//  AppDelegate.m
//  QCNS-Web-App
//
//  Created by Paul Antonelli on 07/03/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "AppDelegate.h"
#import "AppModel.h"
#import "AppController.h"
#import "SlideNavigationController.h"
#import "SlideNavigationContorllerAnimatorSlide.h"

#import "SplashViewController.h"
#import "LeftMenuViewController.h"
#import "QCNavigationBar.h"

@interface AppDelegate ()

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    // Setup Log
    [[AppController sharedInstance] setupLog];
    [AppModel sharedInstance];
    
    // Customize UI
    [application setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    LeftMenuViewController *leftMenuVC = [[LeftMenuViewController alloc] initWithNibName:nil bundle:nil];
    
    SplashViewController *splashVC = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
    SlideNavigationController *navVC = [[SlideNavigationController alloc] initWithNavigationBarClass:[QCNavigationBar class] toolbarClass:nil];
    navVC.enableSwipeGesture = NO;
    navVC.avoidSwitchingToSameClassViewController = NO;
    navVC.enableShadow = NO;
    
    navVC.viewControllers = @[splashVC];
    navVC.navigationBarHidden = YES;
    
    navVC.leftMenu = leftMenuVC;
    
    // nb px where pan gestion is active
//    navVC.panGestureSideOffset = 20;
    
    // nb px of view remaining on screen when menu is shown
    navVC.portraitSlideOffset = 80;
    if ([NXDevice has3dot5InchScreen] || [NXDevice has4InchScreen])
    {
        navVC.portraitSlideOffset = 80;
    }
    else if ([NXDevice has5dot5InchScreen])
    {
        navVC.portraitSlideOffset = 120;
    }
    
    
    SlideNavigationContorllerAnimatorSlide *alideAndFadeAnimator = [[SlideNavigationContorllerAnimatorSlide alloc] initWithSlideMovement:MAIN_SCREEN_WIDTH - navVC.portraitSlideOffset];
    [SlideNavigationController sharedInstance].menuRevealAnimator = alideAndFadeAnimator;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    self.window.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = navVC;
    
    
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor clearColor];
    
    
    [navVC prepareMenuForReveal:MenuLeft];
    
    
    UIImage *img = [UIImage imageNamed:@"main-bg"];
    _backgroundImageView = [[UIImageView alloc] initWithImage:img];
//    bg.alpha = 0.2;
    CGRect rect = _backgroundImageView.frame;
    rect.size.width = img.size.width;
    rect.size.height = MAIN_SCREEN_HEIGHT - kDefaultNavigationBarHeight + 5;
    rect.origin.y = MAIN_SCREEN_HEIGHT - rect.size.height;
    rect.origin.x = (MAIN_SCREEN_WIDTH - rect.size.width) / 2;
    _backgroundImageView.frame = CGRectIntegral(rect);
    _backgroundImageView.backgroundColor = [UIColor clearColor];
    [self.window insertSubview:_backgroundImageView atIndex:0];
    
    DDLogDebug(@"navVC : %@", navVC);
    DDLogDebug(@"navVC.vc : %@", navVC.viewControllers);
    DDLogDebug(@"navVC.leftMenu : %@", navVC.leftMenu);
    DDLogDebug(@"splashVC : %@", splashVC);
    DDLogDebug(@"leftMenuVC : %@", leftMenuVC);
    DDLogDebug(@"window : %@", self.window);
    DDLogDebug(@"window.root : %@", self.window.rootViewController);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
