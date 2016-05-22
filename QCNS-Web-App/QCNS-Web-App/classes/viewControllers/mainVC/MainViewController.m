//
//  MainViewController.m
//  QCNS-Web-App
//
//  Created by Paul Antonelli on 07/03/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "MainViewController.h"

#import "AppModel.h"
#import "AppController.h"
#import "SlideNavigationController.h"

#import "QCNavigationBar.h"

@interface MainViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MainViewController

#pragma mark - UIViewController LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildUIElements];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addMenuNotificationObervers];
    [self.navigationController setNavigationBarHidden:NO animated:YES];    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeMenuNotificationObervers];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    DDLogWarn(@"");
    [self removeMenuNotificationObervers];
}

#pragma mark - Public

- (void)setUrlToLoad:(NSURL *)urlToLoad
{
    _urlToLoad = [urlToLoad copy];
    
    [self startLoadingWebview];
}

#pragma mark - Private

- (void)buildUIElements
{
    //    self.view.backgroundColor = RANDOM_COLOR;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    QCNavigationBar *navBar = (QCNavigationBar *)self.navigationController.navigationBar;
    [[SlideNavigationController sharedInstance] setLeftBarButtonItem:navBar.menuItem];
    [[SlideNavigationController sharedInstance] setRightBarButtonItem:navBar.callItem];
    
//    self.webView.alpha = 0.3;
}

- (void)addMenuNotificationObervers
{
    DDLogDebug(@"");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideMenuWillOpen:) name:SlideNavigationControllerWillOpen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideMenuDidOpen:) name:SlideNavigationControllerDidOpen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideMenuDidClose:) name:SlideNavigationControllerDidClose object:nil];
}

- (void)removeMenuNotificationObervers
{
    DDLogDebug(@"");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SlideNavigationControllerWillOpen object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SlideNavigationControllerDidOpen object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SlideNavigationControllerDidClose object:nil];
}

- (void)startLoadingWebview
{
    if (_urlToLoad)
    {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_urlToLoad
                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                timeoutInterval:kRequestTimeoutDuration];
        [_webView loadRequest:request];
    }
}

#pragma mark - SlideNavigationControllerDelegate

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)slideNavigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self)
    {
    }
}

#pragma mark  - SlideNavigationController Notifications

- (void)slideMenuWillOpen:(NSNotification *)notification
{
    DDLogDebug(@"");
    
    Menu menu = (Menu)[[notification object] integerValue];
    if (menu == MenuLeft)
    {
    }
}
- (void)slideMenuDidOpen:(NSNotification *)notification
{
    DDLogDebug(@"");

    Menu menu = (Menu)[[notification object] integerValue];
    if (menu == MenuLeft)
    {
    }
}
- (void)slideMenuDidClose:(NSNotification *)notification
{
    DDLogDebug(@"");
    
    Menu menu = (Menu)[[notification object] integerValue];
    if (menu == MenuLeft)
    {
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DDLogWarn(@"###### SHOULD LOAD REQUEST WITH URL : %@ %ld", [request.URL absoluteString], (long)navigationType);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DDLogWarn(@"###### DID START LOADING URL : %@", [self.webView.request.URL absoluteString]);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DDLogWarn(@"###### DID FINISH LOADING URL : %@", [self.webView.request.URL absoluteString]);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    DDLogError(@"###### DID FAIL LOADING URL : %@ | error : %@", [self.webView.request.URL absoluteString], error);
}



@end
