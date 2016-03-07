//
//  SlideNavigationController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//
// https://github.com/aryaxt/iOS-Slide-Menu
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "SlideNavigationController.h"
#import "SlideNavigationContorllerAnimator.h"

typedef enum {
	PopTypeAll,
	PopTypeRoot
} PopType;

@interface SlideNavigationController() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint draggingPoint;
@property (nonatomic, assign) Menu lastRevealedMenu;
@property (nonatomic, assign) BOOL menuNeedsLayout;

@property (nonatomic, readwrite) NSArray<UIButton *> *leftItemButtons;
@property (nonatomic, readwrite) NSArray<UIButton *> *rightItemButtons;

@end

@implementation SlideNavigationController

NSString * const SlideNavigationControllerWillOpen = @"SlideNavigationControllerWillOpen";
NSString * const SlideNavigationControllerDidOpen = @"SlideNavigationControllerDidOpen";
NSString * const SlideNavigationControllerDidClose = @"SlideNavigationControllerDidClose";
NSString  *const SlideNavigationControllerDidReveal = @"SlideNavigationControllerDidReveal";

#define MENU_SLIDE_ANIMATION_DURATION .3
#define MENU_SLIDE_ANIMATION_OPTION UIViewAnimationOptionCurveEaseOut
#define MENU_QUICK_SLIDE_ANIMATION_DURATION .18
#define MENU_IMAGE @"menu-button"
#define MENU_SHADOW_RADIUS 10
#define MENU_SHADOW_OPACITY 1
#define MENU_DEFAULT_SLIDE_OFFSET 60
#define MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION 1200
#define STATUS_BAR_HEIGHT 20
#define NOTIFICATION_USER_INFO_MENU_LEFT @"left"
#define NOTIFICATION_USER_INFO_MENU_RIGHT @"right"
#define NOTIFICATION_USER_INFO_MENU @"menu"

static SlideNavigationController *singletonInstance;

#pragma mark - Initialization -

+ (SlideNavigationController *)sharedInstance
{
	if (!singletonInstance)
		NSLog(@"SlideNavigationController has not been initialized. Either place one in your storyboard or initialize one in code");
	
	return singletonInstance;
}

- (id)init
{
	if (self = [super init])
	{
		[self setup];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		[self setup];
	}
	
	return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
	if (self = [super initWithRootViewController:rootViewController])
	{
		[self setup];
	}
	
	return self;
}

- (id)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
	if (self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass])
	{
		[self setup];
	}
	
	return self;
}

- (void)setup
{
	if (singletonInstance)
		NSLog(@"Singleton instance already exists. You can only instantiate one instance of SlideNavigationController. This could cause major issues");
	
	singletonInstance = self;
	
	self.menuRevealAnimationDuration = MENU_SLIDE_ANIMATION_DURATION;
	self.menuRevealAnimationOption = MENU_SLIDE_ANIMATION_OPTION;
	self.landscapeSlideOffset = MENU_DEFAULT_SLIDE_OFFSET;
	self.portraitSlideOffset = MENU_DEFAULT_SLIDE_OFFSET;
	self.panGestureSideOffset = 0;
	self.avoidSwitchingToSameClassViewController = YES;
	self.enableShadow = YES;
	self.enableSwipeGesture = YES;
	self.delegate = self;
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	// Update shadow size of enabled
	if (self.enableShadow)
		self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    
    // When menu open we disable user interaction
    // When rotates we want to make sure that userInteraction is enabled again
    [self enableTapGestureToCloseMenu:NO];
    
    if (self.menuNeedsLayout)
    {
        [self updateMenuFrameAndTransformAccordingToOrientation];
        
        // Handle different horizontal/vertical slideOffset during rotation
        // On iOS below 8 we just close the menu, iOS8 handles rotation better so we support keepiong the menu open
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && [self isMenuOpen])
        {
            Menu menu = (self.horizontalLocation > 0) ? MenuLeft : MenuRight;
            [self openMenu:menu withDuration:0 andCompletion:nil];
        }
        
        self.menuNeedsLayout = NO;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    self.menuNeedsLayout = YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    self.menuNeedsLayout = YES;
}

#pragma mark - Public Methods -

- (void)bounceMenu:(Menu)menu withCompletion:(void (^)())completion
{
    [self postNotificationWithName:SlideNavigationControllerWillOpen forMenu:menu];
	[self prepareMenuForReveal:menu];
	NSInteger movementDirection = (menu == MenuLeft) ? 1 : -1;
	
	[UIView animateWithDuration:.16 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[self moveHorizontallyToLocation:30*movementDirection];
	} completion:^(BOOL finished){
		[UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			[self moveHorizontallyToLocation:0];
		} completion:^(BOOL finished){
			[UIView animateWithDuration:.12 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
				[self moveHorizontallyToLocation:16*movementDirection];
			} completion:^(BOOL finished){
				[UIView animateWithDuration:.08 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
					[self moveHorizontallyToLocation:0];
				} completion:^(BOOL finished){
					[UIView animateWithDuration:.08 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
						[self moveHorizontallyToLocation:6*movementDirection];
					} completion:^(BOOL finished){
						[UIView animateWithDuration:.06 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
							[self moveHorizontallyToLocation:0];
						} completion:^(BOOL finished){
							if (completion)
								completion();
						}];
					}];
				}];
			}];
		}];
	}];
}

- (void)switchToViewController:(UIViewController *)viewController
		 withSlideOutAnimation:(BOOL)slideOutAnimation
					   popType:(PopType)poptype
				 andCompletion:(void (^)())completion
{
	if (self.avoidSwitchingToSameClassViewController && [self.topViewController isKindOfClass:viewController.class])
	{
		[self closeMenuWithCompletion:completion];
		return;
	}
	
	void (^switchAndCallCompletion)(BOOL) = ^(BOOL closeMenuBeforeCallingCompletion) {
		if (poptype == PopTypeAll) {
			[self setViewControllers:@[viewController]];
		}
		else {
			[super popToRootViewControllerAnimated:NO];
			[super pushViewController:viewController animated:NO];
		}
		
		if (closeMenuBeforeCallingCompletion)
		{
			[self closeMenuWithCompletion:^{
				if (completion)
					completion();
			}];
		}
		else
		{
			if (completion)
				completion();
		}
	};
	
	if ([self isMenuOpen])
	{
		if (slideOutAnimation)
		{
			[UIView animateWithDuration:(slideOutAnimation) ? self.menuRevealAnimationDuration : 0
								  delay:0
								options:self.menuRevealAnimationOption
							 animations:^{
								 CGFloat width = self.horizontalSize;
								 CGFloat moveLocation = (self.horizontalLocation> 0) ? width : -1*width;
								 [self moveHorizontallyToLocation:moveLocation];
							 } completion:^(BOOL finished) {
								 switchAndCallCompletion(YES);
							 }];
		}
		else
		{
			switchAndCallCompletion(YES);
		}
	}
	else
	{
		switchAndCallCompletion(NO);
	}
}

- (void)switchToViewController:(UIViewController *)viewController withCompletion:(void (^)())completion
{
	[self switchToViewController:viewController withSlideOutAnimation:YES popType:PopTypeRoot andCompletion:completion];
}

- (void)popToRootAndSwitchToViewController:(UIViewController *)viewController
				  withSlideOutAnimation:(BOOL)slideOutAnimation
						  andCompletion:(void (^)())completion
{
	[self switchToViewController:viewController withSlideOutAnimation:slideOutAnimation popType:PopTypeRoot andCompletion:completion];
}

- (void)popToRootAndSwitchToViewController:(UIViewController *)viewController
						 withCompletion:(void (^)())completion
{
	[self switchToViewController:viewController withSlideOutAnimation:YES popType:PopTypeRoot andCompletion:completion];
}

- (void)popAllAndSwitchToViewController:(UIViewController *)viewController
		 withSlideOutAnimation:(BOOL)slideOutAnimation
				 andCompletion:(void (^)())completion
{
	[self switchToViewController:viewController withSlideOutAnimation:slideOutAnimation popType:PopTypeAll andCompletion:completion];
}

- (void)popAllAndSwitchToViewController:(UIViewController *)viewController
						 withCompletion:(void (^)())completion
{
	[self switchToViewController:viewController withSlideOutAnimation:YES popType:PopTypeAll andCompletion:completion];
}

- (void)closeMenuWithCompletion:(void (^)())completion
{
	[self closeMenuWithDuration:self.menuRevealAnimationDuration andCompletion:completion];
}

- (void)openMenu:(Menu)menu withCompletion:(void (^)())completion
{
	[self openMenu:menu withDuration:self.menuRevealAnimationDuration andCompletion:completion];
}

- (void)toggleLeftMenu
{
	[self toggleMenu:MenuLeft withCompletion:nil];
}

- (void)toggleRightMenu
{
	[self toggleMenu:MenuRight withCompletion:nil];
}

- (BOOL)isMenuOpen
{
	return (self.horizontalLocation == 0) ? NO : YES;
}

- (void)setEnableShadow:(BOOL)enable
{
	_enableShadow = enable;
	
	if (enable)
	{
		self.view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
		self.view.layer.shadowRadius = MENU_SHADOW_RADIUS;
		self.view.layer.shadowOpacity = MENU_SHADOW_OPACITY;
		self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
		self.view.layer.shouldRasterize = YES;
		self.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
	}
	else
	{
		self.view.layer.shadowOpacity = 0;
		self.view.layer.shadowRadius = 0;
	}
}

#pragma mark - Override Methods -

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
	if ([self isMenuOpen])
	{
		[self closeMenuWithCompletion:^{
			[super popToRootViewControllerAnimated:animated];
		}];
	}
	else
	{
		return [super popToRootViewControllerAnimated:animated];
	}
	
	return nil;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ([self isMenuOpen])
	{
		[self closeMenuWithCompletion:^{
			[super pushViewController:viewController animated:animated];
		}];
	}
	else
	{
		[super pushViewController:viewController animated:animated];
	}
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ([self isMenuOpen])
	{
		[self closeMenuWithCompletion:^{
			[super popToViewController:viewController animated:animated];
		}];
	}
	else
	{
		return [super popToViewController:viewController animated:animated];
	}
	
	return nil;
}

#pragma mark - Private Methods -

- (void)updateMenuFrameAndTransformAccordingToOrientation
{
	// Animate rotatation when menu is open and device rotates
	CGAffineTransform transform = self.view.transform;
	self.leftMenu.view.transform = transform;
	self.rightMenu.view.transform = transform;
	
	self.leftMenu.view.frame = [self initialRectForMenu];
	self.rightMenu.view.frame = [self initialRectForMenu];
}

- (void)enableTapGestureToCloseMenu:(BOOL)enable
{
	if (enable)
	{
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
			self.interactivePopGestureRecognizer.enabled = NO;
		
		self.topViewController.view.userInteractionEnabled = NO;
		[self.view addGestureRecognizer:self.tapRecognizer];
	}
	else
	{
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
			self.interactivePopGestureRecognizer.enabled = YES;
		
		self.topViewController.view.userInteractionEnabled = YES;
		[self.view removeGestureRecognizer:self.tapRecognizer];
	}
}

- (void)toggleMenu:(Menu)menu withCompletion:(void (^)())completion
{
	if ([self isMenuOpen])
		[self closeMenuWithCompletion:completion];
	else
		[self openMenu:menu withCompletion:completion];
}

- (UIBarButtonItem *)barButtonItemForMenu:(Menu)menu
{
	SEL selector = (menu == MenuLeft) ? @selector(leftMenuSelected:) : @selector(righttMenuSelected:);
	UIBarButtonItem *customButton = (menu == MenuLeft) ? self.leftBarButtonItem : self.rightBarButtonItem;
	
	if (customButton)
	{
        // BI
//		customButton.action = selector;
//		customButton.target = self;
		return customButton;
	}
	else
	{
        
        // Bibi modified
		UIImage *image = [[UIImage imageNamed:MENU_IMAGE] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:selector];
        item.tintColor = [UIColor whiteColor];
        return item;
        
        // original
//        UIImage *image = [UIImage imageNamed:MENU_IMAGE];
//        return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:selector];

	}
}

- (BOOL)shouldDisplayMenu:(Menu)menu forViewController:(UIViewController *)vc
{
	if (menu == MenuRight)
	{
		if ([vc respondsToSelector:@selector(slideNavigationControllerShouldDisplayRightMenu)] &&
			[(UIViewController<SlideNavigationControllerDelegate> *)vc slideNavigationControllerShouldDisplayRightMenu])
		{
			return YES;
		}
	}
	if (menu == MenuLeft)
	{
		if ([vc respondsToSelector:@selector(slideNavigationControllerShouldDisplayLeftMenu)] &&
			[(UIViewController<SlideNavigationControllerDelegate> *)vc slideNavigationControllerShouldDisplayLeftMenu])
		{
			return YES;
		}
	}
	
	return NO;
}

- (void)openMenu:(Menu)menu withDuration:(float)duration andCompletion:(void (^)())completion
{
	[self enableTapGestureToCloseMenu:YES];
    
    [self postNotificationWithName:SlideNavigationControllerWillOpen forMenu:menu];
	[self prepareMenuForReveal:menu];
	
	[UIView animateWithDuration:duration
						  delay:0
						options:self.menuRevealAnimationOption
					 animations:^{
						 CGRect rect = self.view.frame;
						 CGFloat width = self.horizontalSize;
						 rect.origin.x = (menu == MenuLeft) ? (width - self.slideOffset) : ((width - self.slideOffset )* -1);
						 [self moveHorizontallyToLocation:rect.origin.x];
					 }
					 completion:^(BOOL finished) {
						 if (completion)
							 completion();
                         
                         [self postNotificationWithName:SlideNavigationControllerDidOpen forMenu:menu];
					 }];
}

- (void)closeMenuWithDuration:(float)duration andCompletion:(void (^)())completion
{
	[self enableTapGestureToCloseMenu:NO];
    
     Menu menu = (self.horizontalLocation > 0) ? MenuLeft : MenuRight;
	
	[UIView animateWithDuration:duration
						  delay:0
						options:self.menuRevealAnimationOption
					 animations:^{
						 CGRect rect = self.view.frame;
						 rect.origin.x = 0;
						 [self moveHorizontallyToLocation:rect.origin.x];
					 }
					 completion:^(BOOL finished) {
						 if (completion)
							 completion();
                         
                         [self postNotificationWithName:SlideNavigationControllerDidClose forMenu:menu];
					 }];
}

- (void)moveHorizontallyToLocation:(CGFloat)location
{
	CGRect rect = self.view.frame;
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	Menu menu = (self.horizontalLocation >= 0 && location >= 0) ? MenuLeft : MenuRight;
    
    if ((location > 0 && self.horizontalLocation <= 0) || (location < 0 && self.horizontalLocation >= 0)) {
        [self postNotificationWithName:SlideNavigationControllerDidReveal forMenu:(location > 0) ? MenuLeft : MenuRight];
    }
	
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        rect.origin.x = location;
        rect.origin.y = 0;
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            rect.origin.x = 0;
            rect.origin.y = (orientation == UIInterfaceOrientationLandscapeRight) ? location : location*-1;
        }
        else
        {
            rect.origin.x = (orientation == UIInterfaceOrientationPortrait) ? location : location*-1;
            rect.origin.y = 0;
        }
    }
	
	self.view.frame = rect;
	[self updateMenuAnimation:menu];
}

- (void)updateMenuAnimation:(Menu)menu
{
	CGFloat progress = (menu == MenuLeft)
		? (self.horizontalLocation / (self.horizontalSize - self.slideOffset))
		: (self.horizontalLocation / ((self.horizontalSize - self.slideOffset) * -1));
	
	[self.menuRevealAnimator animateMenu:menu withProgress:progress];
}

- (CGRect)initialRectForMenu
{
	CGRect rect = self.view.frame;
	rect.origin.x = 0;
	rect.origin.y = 0;
	
	if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        return rect;
    }
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	
	if (UIInterfaceOrientationIsLandscape(orientation))
	{
        // For some reasons in landscape below the status bar is considered y=0, but in portrait it's considered y=20
        rect.origin.x = (orientation == UIInterfaceOrientationLandscapeRight) ? 0 : STATUS_BAR_HEIGHT;
        rect.size.width = self.view.frame.size.width-STATUS_BAR_HEIGHT;
	}
	else
	{
        // For some reasons in landscape below the status bar is considered y=0, but in portrait it's considered y=20
        rect.origin.y = (orientation == UIInterfaceOrientationPortrait) ? STATUS_BAR_HEIGHT : 0;
        rect.size.height = self.view.frame.size.height-STATUS_BAR_HEIGHT;
	}
	
	return rect;
}

- (void)prepareMenuForReveal:(Menu)menu
{
//    [self postNotificationWithName:SlideNavigationControllerWillOpen forMenu:menu];    
    
	// Only prepare menu if it has changed (ex: from MenuLeft to MenuRight or vice versa)
    if (self.lastRevealedMenu && menu == self.lastRevealedMenu)
        return;
    
    UIViewController *menuViewController = (menu == MenuLeft) ? self.leftMenu : self.rightMenu;
	UIViewController *removingMenuViewController = (menu == MenuLeft) ? self.rightMenu : self.leftMenu;

    self.lastRevealedMenu = menu;
	
	[removingMenuViewController.view removeFromSuperview];
	[self.view.window insertSubview:menuViewController.view atIndex:0];

	[self updateMenuFrameAndTransformAccordingToOrientation];
	
	[self.menuRevealAnimator prepareMenuForAnimation:menu];
    

}

- (CGFloat)horizontalLocation
{
	CGRect rect = self.view.frame;
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        return rect.origin.x;
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return (orientation == UIInterfaceOrientationLandscapeRight)
            ? rect.origin.y
            : rect.origin.y*-1;
        }
        else
        {
            return (orientation == UIInterfaceOrientationPortrait)
            ? rect.origin.x
            : rect.origin.x*-1;
        }
    }
}

- (CGFloat)horizontalSize
{
	CGRect rect = self.view.frame;
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        return rect.size.width;
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return rect.size.height;
        }
        else
        {
            return rect.size.width;
        }
    }
}

- (void)postNotificationWithName:(NSString *)name forMenu:(Menu)menu
{
    NSString *menuString = (menu == MenuLeft) ? NOTIFICATION_USER_INFO_MENU_LEFT : NOTIFICATION_USER_INFO_MENU_RIGHT;
    NSDictionary *userInfo = @{ NOTIFICATION_USER_INFO_MENU : menuString };
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:@(menu) userInfo:userInfo];
}

//#pragma mark - UIGestureRecognizerDelegate Methods -
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

#pragma mark - UINavigationControllerDelegate Methods -

- (void)navigationController:(UINavigationController *)navigationController
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated
{
	if ([self shouldDisplayMenu:MenuLeft forViewController:viewController])
		viewController.navigationItem.leftBarButtonItem = [self barButtonItemForMenu:MenuLeft];
	
	if ([self shouldDisplayMenu:MenuRight forViewController:viewController])
		viewController.navigationItem.rightBarButtonItem = [self barButtonItemForMenu:MenuRight];
    
    if ([_slideDelegate respondsToSelector:@selector(slideNavigationController:willShowViewController:animated:)])
    {
        [_slideDelegate slideNavigationController:self willShowViewController:viewController animated:animated];
    }
}

- (CGFloat)slideOffset
{
	return (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
		? self.landscapeSlideOffset
		: self.portraitSlideOffset;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([_slideDelegate respondsToSelector:@selector(slideNavigationController:didShowViewController:animated:)])
    {
        [_slideDelegate slideNavigationController:self didShowViewController:viewController animated:animated];
    }
}

#pragma mark - IBActions -

- (void)leftMenuSelected:(id)sender
{
	if ([self isMenuOpen])
		[self closeMenuWithCompletion:nil];
	else
		[self openMenu:MenuLeft withCompletion:nil];
}

- (void)righttMenuSelected:(id)sender
{
	if ([self isMenuOpen])
		[self closeMenuWithCompletion:nil];
	else
		[self openMenu:MenuRight withCompletion:nil];
}

#pragma mark - Gesture Recognizing -

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
	[self closeMenuWithCompletion:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	if (self.panGestureSideOffset == 0)
		return YES;
	
	CGPoint pointInView = [touch locationInView:self.view];
	CGFloat horizontalSize = [self horizontalSize];
	
	return (pointInView.x <= self.panGestureSideOffset || pointInView.x >= horizontalSize - self.panGestureSideOffset)
		? YES
		: NO;
}

- (void)panDetected:(UIPanGestureRecognizer *)aPanRecognizer
{
	CGPoint translation = [aPanRecognizer translationInView:aPanRecognizer.view];
    CGPoint velocity = [aPanRecognizer velocityInView:aPanRecognizer.view];
	NSInteger movement = translation.x - self.draggingPoint.x;
	
    Menu currentMenu;
    
    if (self.horizontalLocation > 0)
        currentMenu = MenuLeft;
    else if (self.horizontalLocation < 0)
        currentMenu = MenuRight;
    else
        currentMenu = (translation.x > 0) ? MenuLeft : MenuRight;
    
    if (![self shouldDisplayMenu:currentMenu forViewController:self.topViewController])
        return;

    [self postNotificationWithName:SlideNavigationControllerWillOpen forMenu:currentMenu];
    [self prepareMenuForReveal:currentMenu];
    
    if (aPanRecognizer.state == UIGestureRecognizerStateBegan)
	{
		self.draggingPoint = translation;
    }
	else if (aPanRecognizer.state == UIGestureRecognizerStateChanged)
	{
		static CGFloat lastHorizontalLocation = 0;
		CGFloat newHorizontalLocation = [self horizontalLocation];
		lastHorizontalLocation = newHorizontalLocation;
		newHorizontalLocation += movement;
		
		if (newHorizontalLocation >= self.minXForDragging && newHorizontalLocation <= self.maxXForDragging)
			[self moveHorizontallyToLocation:newHorizontalLocation];
		
		self.draggingPoint = translation;
	}
	else if (aPanRecognizer.state == UIGestureRecognizerStateEnded)
	{
        NSInteger currentX = [self horizontalLocation];
		NSInteger currentXOffset = (currentX > 0) ? currentX : currentX * -1;
		NSInteger positiveVelocity = (velocity.x > 0) ? velocity.x : velocity.x * -1;
		
		// If the speed is high enough follow direction
		if (positiveVelocity >= MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION)
		{
			Menu menu = (velocity.x > 0) ? MenuLeft : MenuRight;
			
			// Moving Right
			if (velocity.x > 0)
			{
				if (currentX > 0)
				{
					if ([self shouldDisplayMenu:menu forViewController:self.visibleViewController])
						[self openMenu:(velocity.x > 0) ? MenuLeft : MenuRight withDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
				}
				else
				{
					[self closeMenuWithDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
				}
			}
			// Moving Left
			else
			{
				if (currentX > 0)
				{
					[self closeMenuWithDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
				}
				else
				{
					if ([self shouldDisplayMenu:menu forViewController:self.visibleViewController])
						[self openMenu:(velocity.x > 0) ? MenuLeft : MenuRight withDuration:MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
				}
			}
		}
		else
		{
			if (currentXOffset < (self.horizontalSize - self.slideOffset)/2)
				[self closeMenuWithCompletion:nil];
			else
				[self openMenu:(currentX > 0) ? MenuLeft : MenuRight withCompletion:nil];
		}
    }
}

- (NSInteger)minXForDragging
{
	if ([self shouldDisplayMenu:MenuRight forViewController:self.topViewController])
	{
		return (self.horizontalSize - self.slideOffset)  * -1;
	}
	
	return 0;
}

- (NSInteger)maxXForDragging
{
	if ([self shouldDisplayMenu:MenuLeft forViewController:self.topViewController])
	{
		return self.horizontalSize - self.slideOffset;
	}
	
	return 0;
}

#pragma mark - Setter & Getter -

- (UITapGestureRecognizer *)tapRecognizer
{
	if (!_tapRecognizer)
	{
		_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
	}
	
	return _tapRecognizer;
}

- (UIPanGestureRecognizer *)panRecognizer
{
	if (!_panRecognizer)
	{
		_panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
		_panRecognizer.delegate = self;
	}
	
	return _panRecognizer;
}

- (void)setEnableSwipeGesture:(BOOL)markEnableSwipeGesture
{
	_enableSwipeGesture = markEnableSwipeGesture;
	
	if (_enableSwipeGesture)
	{
		[self.view addGestureRecognizer:self.panRecognizer];
	}
	else
	{
		[self.view removeGestureRecognizer:self.panRecognizer];
	}
}

- (void)setMenuRevealAnimator:(id<SlideNavigationContorllerAnimator>)menuRevealAnimator
{
	[self.menuRevealAnimator clear];
	
	_menuRevealAnimator = menuRevealAnimator;
}

- (void)setLeftMenu:(UIViewController *)leftMenu
{
    [_leftMenu.view removeFromSuperview];
    
    _leftMenu = leftMenu;
}

- (void)setRightMenu:(UIViewController *)rightMenu
{
    [_rightMenu.view removeFromSuperview];
    
    _rightMenu = rightMenu;
}

// Bibi added
- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    _leftBarButtonItem = leftBarButtonItem;
    if (!_leftBarButtonItem)
    {
        // reset to default if nil        
        _leftBarButtonItem = [self barButtonItemForMenu:MenuLeft];
    }
    self.visibleViewController.navigationItem.leftBarButtonItem = _leftBarButtonItem;
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    _rightBarButtonItem = rightBarButtonItem;
    if (!_rightBarButtonItem)
    {
        // reset to default if nil
        _rightBarButtonItem = [self barButtonItemForMenu:MenuRight];
    }
    self.visibleViewController.navigationItem.rightBarButtonItem = _rightBarButtonItem;
}

#define kButtonW    30

- (void)setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems addDefaultItem:(BOOL)addDefautItem
{
    NSInteger count = [leftBarButtonItems count];
    
    CGRect rect = CGRectMake(0, 0, (count + ((addDefautItem) ? 1 : 0)) * kButtonW, 40);
    UIView *buttonsView = [[UIView alloc] initWithFrame:rect];
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
    UIButton *button = nil;
    NSInteger index = 0;
    for (UIBarButtonItem *item in leftBarButtonItems)
    {
        button = [self buttonFromBarButtonItem:item];
        rect = button.frame;
        rect.origin.x = index * rect.size.width;
        button.frame = rect;
        [buttonsView addSubview:button];
        [mutArr addObject:button];
        index++;
    }
    
    if (addDefautItem)
    {
        button = [self buttonFromBarButtonItem:[self defaultMenuItemForMenu:MenuLeft]];
        rect = button.frame;
        rect.origin.x = index * rect.size.width;
        button.frame = rect;
        [buttonsView addSubview:button];
        [mutArr insertObject:button atIndex:0];
    }
    
    _leftItemButtons = [NSArray arrayWithArray:mutArr];
    
    _leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonsView];
    self.visibleViewController.navigationItem.leftBarButtonItem = _leftBarButtonItem;
}

- (void)setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems addDefaultItem:(BOOL)addDefautItem;
{
    NSInteger count = [rightBarButtonItems count];
    
    CGRect rect = CGRectMake(0, 0, (count + ((addDefautItem) ? 1 : 0)) * kButtonW, 40);
    UIView *buttonsView = [[UIView alloc] initWithFrame:rect];
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
    UIButton *button = nil;
    NSInteger index = 0;
    for (UIBarButtonItem *item in rightBarButtonItems)
    {
        button = [self buttonFromBarButtonItem:item];
        rect = button.frame;
        rect.origin.x = index * rect.size.width;
        button.frame = rect;
        [buttonsView addSubview:button];
        [mutArr addObject:button];
        index++;
    }
    
    if (addDefautItem)
    {
        button = [self buttonFromBarButtonItem:[self defaultMenuItemForMenu:MenuRight]];
        rect = button.frame;
        rect.origin.x = index * rect.size.width;
        button.frame = rect;
        [buttonsView addSubview:button];
        [mutArr addObject:button];
    }
    
    _rightItemButtons = [NSArray arrayWithArray:mutArr];
    
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonsView];
    self.visibleViewController.navigationItem.rightBarButtonItem = _rightBarButtonItem;
}

- (UIButton *)buttonFromBarButtonItem:(UIBarButtonItem *)item
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kButtonW, 40);

    if (item.image)
    {
        [button setImage:item.image forState:UIControlStateNormal];
        button.tintColor = [UIColor whiteColor];
    }
    
    else if ([item.title length] > 0)
    {
        [button setTitle:item.title forState:UIControlStateNormal];
        button.tintColor = [[UIBarButtonItem appearance] tintColor];
    }
    
    else if (item.customView)
    {
        if ([item.customView isKindOfClass:[UIButton class]])
        {
            button = item.customView;
        }
        else if ([item.customView isKindOfClass:[UILabel class]])
        {
            UILabel *label = item.customView;
            button.titleLabel.font = label.font;
            button.titleLabel.textColor = label.textColor;
            [button setTitle:label.text forState:UIControlStateNormal];
        }
    }
    
    if (item.target && item.action)
    {
        [button addTarget:item.target action:item.action forControlEvents:UIControlEventTouchUpInside];
    }

    return button;
}

- (UIBarButtonItem *)defaultMenuItemForMenu:(Menu)menu
{
    SEL selector = (menu == MenuLeft) ? @selector(leftMenuSelected:) : @selector(righttMenuSelected:);
    UIImage *image = [[UIImage imageNamed:MENU_IMAGE] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:selector];
    item.tintColor = [UIColor whiteColor];
    return item;
}


- (BOOL)isLeftMenuOpen
{
    return (self.horizontalLocation > 0);
}

- (BOOL)isRightMenuOpen
{
    return (self.horizontalLocation < 0);
}


@end
