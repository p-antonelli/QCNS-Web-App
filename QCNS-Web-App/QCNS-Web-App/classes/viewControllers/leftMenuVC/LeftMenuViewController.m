//
//  LeftMenuViewController.m
//  Feezly
//
//  Created by Paul Antonelli on 25/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SlideNavigationController.h"

#import "AppModel.h"
#import "AppController.h"
#import "RequestController.h"

#import "MenuCell.h"


#import "NSString+CapFirstLetter.h"
#import "NSDate+NbYears.h"


#import "UIImageView+WebCache.h"


#import "UIImageView+ImageTintColor.h"
#import "UILabel+AwesomeFont.h"
#import "UILabel+Insets.h"


#define kDefaultTextColor       [UIColor lightGrayColor]
#define kEnabledTextColor       FEEZLY_BLUE_COLOR

@interface LeftMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@property (nonatomic, readwrite) NSArray *tableArray;

@end

@implementation LeftMenuViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if ([NXDevice has3dot5InchScreen])
    {
    }
    else if ([NXDevice has4InchScreen])
    {
    }

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

#pragma mark - Private

- (void)buildUIElements
{
    _tableArray = [[AppModel sharedInstance] menuItems];
    
    self.view.backgroundColor = COSTA_BLUE_COLOR;
    self.tableView.backgroundColor = COSTA_BLUE_COLOR;
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"Header"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuCell class]) bundle:MAIN_BUNDLE] forCellReuseIdentifier:NSStringFromClass([MenuCell class])];
    
}

- (void)disableButtons
{
    self.tableView.allowsSelection = NO;
}

- (void)enableButtons
{
    self.tableView.allowsSelection = YES;
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


- (void)pushChatVCWithCandidateID:(NSString *)candidateID
{
    DDLogDebug(@"");
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
    }];
    
    [[AppController sharedInstance] hideWaitingViewWithCompletion:^{
        
//            ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:nil bundle:nil];
//            UIViewController *visibleVC = [[SlideNavigationController sharedInstance] visibleViewController];
//            [visibleVC.navigationController pushViewController:chatVC animated:YES];
        
    }];
}

- (void)pushFeezVCWithCandidateID:(NSString *)candidateID
{
    DDLogDebug(@"");
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
    }];
    
    [[AppController sharedInstance] hideWaitingViewWithCompletion:^{
        
//            FeezViewController *feezVC = [[FeezViewController alloc] initWithNibName:nil bundle:nil];
//            UIViewController *visibleVC = [[SlideNavigationController sharedInstance] visibleViewController];
//            feezVC.candidate = [candi copy];
//            [visibleVC presentViewController:feezVC animated:YES completion:^{
//                
//            }];

    }];
}


#pragma mark  - SlideNavigationController Notifications

- (void)slideMenuWillOpen:(NSNotification *)notification
{
    DDLogDebug(@"");
    Menu menu = (Menu)[[notification object] integerValue];
    if (menu == MenuLeft)
    {
//        dispatch_async(dispatch_get_main_queue(), ^{            
//        });
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



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = NSStringFromClass([MenuCell class]);
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    MenuItem *item = self.tableArray[indexPath.row];
    
    [cell setItem:item value:indexPath delegate:self];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem  *item = self.tableArray[indexPath.row];
    return [MenuCell cellHeightWithItem:item value:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogInfo(@"");
    MenuItem *item = [self.tableArray objectAtIndex:indexPath.row];
}


@end
