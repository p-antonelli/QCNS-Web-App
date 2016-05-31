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

//#import "QCNavigationBar.h"
#import "ChildViewController.h"

#import "NXURLParser.h"
#import "NSString+DecodeURL.h"
#import "UIImage+Color.h"

@interface MainViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *headerContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;


@property (weak, nonatomic) IBOutlet UIButton *leftMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *rightMenuButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuButtonWConstraint;

@property (nonatomic, readwrite) BOOL hasPushedChildVC;

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
    
    self.webView.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (!_hasPushedChildVC)
    {
        [self startLoadingWebview];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    _hasPushedChildVC = NO;
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
    //    self.view.backgroundColor = RANDOM_COLOR;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    // remove "Retour" in back button when pushed childVC
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:nil action:nil];
 
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.backgroundImageView setImage:[UIImage imageNamed:@"costa-navbar"]];
    
    self.rightMenuButton.titleLabel.font = AWESOME_FONT(30);
    self.rightMenuButton.titleLabel.textColor = [UIColor whiteColor];
    [self.rightMenuButton setTitle:[NSString stringForFontAwesomeIcon:FAPhone] forState:UIControlStateNormal];
    
    [self.rightMenuButton addTarget:[AppController sharedInstance]
                            action:@selector(callButtonPressed:)
                  forControlEvents:UIControlEventTouchUpInside];

    
    [self.rightMenuButton setBackgroundImage:[UIImage imageFromColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [self.rightMenuButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
    self.rightMenuButton.clipsToBounds = YES;
    self.rightMenuButton.tintColor = [UIColor whiteColor];
    self.rightMenuButton.layer.cornerRadius = CGRectGetWidth(self.rightMenuButton.frame) / 2.0;
    self.rightMenuButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.rightMenuButton.layer.borderWidth = 4;
    
    // 
    
    UIImage *image = [[UIImage imageNamed:@"menu-button"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.leftMenuButton setImage:image forState:UIControlStateNormal];
    [self.leftMenuButton setBackgroundImage:[UIImage imageFromColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [self.leftMenuButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 1, 0.5f)];
    self.leftMenuButton.clipsToBounds = YES;
    self.leftMenuButton.tintColor = [UIColor whiteColor];
    self.leftMenuButton.layer.cornerRadius = CGRectGetWidth(self.leftMenuButton.frame) / 2.0;
    self.leftMenuButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.leftMenuButton.layer.borderWidth = 4;
    
    [self.leftMenuButton addTarget:[SlideNavigationController sharedInstance]
                            action:@selector(toggleLeftMenu)
                  forControlEvents:UIControlEventTouchUpInside];
}

- (void)startLoadingWebview
{
    DDLogWarn(@"start loading : %@", self.urlToLoad);
    
    self.webView.delegate = self;    
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
    if (modal)
    {
        childVC.isPresentedModally = YES;
    }
    
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

#pragma mark - SlideNavigationControllerDelegate

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
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
