//
//  ChildViewController.m
//  QCNS-Web-App
//
//  Created by Paul Antonelli on 31/05/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "ChildViewController.h"
#import "SlideNavigationController.h"
#import "AppController.h"
#import "NXURLParser.h"

#import "NSString+DecodeURL.h"
#import "UIImage+Color.h"


@interface ChildViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, readwrite) BOOL hasPushedChildVC;


@end

@implementation ChildViewController

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
    
    self.webView.delegate = self;
    if (!self.hasPushedChildVC)
    {
        [self startLoadingWebview];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.hasPushedChildVC = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    DDLogError(@"######## PRESENTED MODALLY : %d", self.isPresentedModally);
    //    self.view.backgroundColor = RANDOM_COLOR;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (self.isPresentedModally)
    {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonPressed:)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
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
    
    [[AppController sharedInstance] showWaitingView];
    
    ChildViewController *childVC = [[ChildViewController alloc] initWithNibName:nil bundle:nil];
    
    childVC.urlToLoad = [NSURL URLWithString:url];
    childVC.title = [title copy];
    
    [childVC.view setNeedsDisplay];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
        UINavigationController *navController = self.navigationController;
        [navController setNavigationBarHidden:NO animated:NO];
        _hasPushedChildVC = YES;
        if (modal)
        {
            childVC.isPresentedModally = YES;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:childVC];
            
            //now present this navigation controller modally
            [self presentViewController:navigationController animated:YES completion:nil];
        }
        else
        {
            [navController pushViewController:childVC animated:YES];
        }
    });
}

- (void)backButtonPressed:(id)sender
{
    DDLogDebug(@"");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DDLogWarn(@"###### SHOULD LOAD REQUEST WITH URL : %@ %ld", [request.URL absoluteString], (long)navigationType);
    NSString *reqURLString = [[request.URL absoluteString] copy];
    
    if ([reqURLString rangeOfString:@"push="].location != NSNotFound)
    {
        NXURLParser *parser = [[NXURLParser alloc] initWithURLString:reqURLString];
        NSString *pushValue = [parser valueForVariable:@"push"];
        NSString *titleValue = [[parser valueForVariable:@"view_title"] stringByDecodingURLFormat];
        
//        NSLog(@"####### PUSH VALUE : |%@|", pushValue);
//        NSLog(@"####### title VALUE : |%@|", titleValue);
        
        if (!pushValue ||
            [pushValue length] == 0)
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
        
        if ([reqURLString rangeOfString:@"?&#"].location)
        {
            reqURLString = [reqURLString stringByReplacingOccurrencesOfString:@"?&#" withString:@"#"];
        }
                
        // push children
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
