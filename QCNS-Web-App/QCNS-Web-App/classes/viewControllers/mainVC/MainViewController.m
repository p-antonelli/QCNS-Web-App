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

#import "NXURLParser.h"
#import "NSString+DecodeURL.h"

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
    
    self.webView.delegate = self;
    [self startLoadingWebview];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    DDLogDebug(@"webview : %@", self.webView);
    DDLogDebug(@"url : %@", self.urlToLoad);
    
    
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
    self.webView.delegate = self;
    [self startLoadingWebview];
}

#pragma mark - Private

- (void)buildUIElements
{
    DDLogDebug(@"");
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
    DDLogWarn(@"start loading : %@", self.urlToLoad);
    DDLogWarn(@"webView delegate : %@", self.webView.delegate);
    if (_urlToLoad)
    {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_urlToLoad
                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                timeoutInterval:kRequestTimeoutDuration];
        [_webView loadRequest:request];
    }
}


- (void)openInternalURL:(NSString *)url title:(NSString *)title modal:(BOOL)modal
{
    DDLogWarn(@"URL : %@", url);
    
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    
    mainVC.urlToLoad = [NSURL URLWithString:url];
    mainVC.title = [title copy];
    [mainVC.view setNeedsDisplay];
    [self.navigationController pushViewController:mainVC animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
        UINavigationController *navController = self.navigationController;
        if (modal)
        {
            [navController presentViewController:mainVC animated:YES completion:nil];
        }
        else
        {
            [navController pushViewController:mainVC animated:YES];
        }
    });
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
    
    NSString *reqURLString = [[request.URL absoluteString] copy];
//    if ([reqURLString rangeOfString:@"push="].location != NSNotFound || ((1 == 1 && ![reqURLString isEqualToString:@"http://app.croisierenet.com/"]) && ![reqURLString hasPrefix:@"http://app.croisierenet.com/liste-produits/1/d-4/croisieres-201606/port_0/comp_/a-prix-0-max/duree-0-max/liste.html"]))
//    {
    if ([reqURLString rangeOfString:@"push="].location != NSNotFound)
    {

        NSString *url =  @"http://app.croisierenet.com/liste-produits/1/d-4/croisieres-201606/port_0/comp_0/a-prix-0-max/duree-0-max/liste.html?push=fille&view_title=%22Votre%20selection%20croisi%C3%A8res%20m%C3%A9dieterran%C3%A9e%22";
        
        
        NXURLParser *parser = [[NXURLParser alloc] initWithURLString:url];
        NSString *pushValue = [parser valueForVariable:@"push"];
        NSString *titleValue = [[parser valueForVariable:@"view_title"] stringByDecodingURLFormat];
        
        NSLog(@"####### PUSH VALUE : |%@|", pushValue);
        NSLog(@"####### title VALUE : |%@|", titleValue);
        
        if (!pushValue ||
            [pushValue length] == 0)
//            ![pushValue isEqualToString:@"fille"] ||
//            ![pushValue isEqualToString:@"modal"])
        {
            return YES;
        }
    
        BOOL modal = NO;
        if ([pushValue isEqualToString:@"fille"])
        {
            reqURLString = [reqURLString stringByReplacingOccurrencesOfString:@"push=fille" withString:@""];
            reqURLString = [reqURLString stringByReplacingOccurrencesOfString:@"push=fille&" withString:@""];
            
        }
        else if ([pushValue isEqualToString:@"modal"])
        {
            modal = YES;
            reqURLString = [reqURLString stringByReplacingOccurrencesOfString:@"push=modal" withString:@""];
            reqURLString = [reqURLString stringByReplacingOccurrencesOfString:@"push=modal&" withString:@""];
        }
        else
        {
            return YES;
        }

        reqURLString = [reqURLString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"view_title=%@",[parser valueForVariable:@"view_title"]] withString:@""];
        reqURLString = [reqURLString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"view_title=%@&",[parser valueForVariable:@"view_title"]] withString:@""];

        NSLog(@"###### PUSH CHILD");
        NSLog(@"##### URL STR NEW : |%@| vs |%@|", reqURLString, [request.URL absoluteString]);

        dispatch_after_delay_on_main_queue(0.1, ^{
            [self openInternalURL:reqURLString title:titleValue modal:modal];
        });
        
        return NO;
    }
    
    
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DDLogWarn(@"###### DID START LOADING URL : %@", [self.webView.request.URL absoluteString]);
//    [[AppController sharedInstance] hideWaitingView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DDLogWarn(@"###### DID FINISH LOADING URL : %@", [self.webView.request.URL absoluteString]);
    [[AppController sharedInstance] hideWaitingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    DDLogError(@"###### DID FAIL LOADING URL : %@ | error : %@", [self.webView.request.URL absoluteString], error);
    [[AppController sharedInstance] hideWaitingView];
}



@end
