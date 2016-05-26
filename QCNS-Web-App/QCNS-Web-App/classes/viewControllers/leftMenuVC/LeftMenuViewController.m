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

#import "MenuSection.h"
#import "MenuItem.h"

#import "MainViewController.h"

#import "HeaderView.h"


#define kDefaultTextColor       [UIColor lightGrayColor]
#define kEnabledTextColor       FEEZLY_BLUE_COLOR

@interface LeftMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerHourLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTrailingConstraint;

@property (nonatomic, readwrite) NSArray *menuSections;

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
//    DDLogDebug(@"bottom constraint : %@", self.tableViewBottomConstraint);
//    DDLogDebug(@"bottom constraint const : %f", MAIN_SCREEN_HEIGHT - ([_menuSections count] * [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]));
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

#pragma mark - Public

- (void)selectFirstMenuRow
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)updateTexts
{
    _menuSections = [[AppModel sharedInstance] menuSections];
    
    self.headerTitleLabel.text = [[AppModel sharedInstance] phoningTitle];
    self.headerPhoneLabel.text = [[AppModel sharedInstance] phoningNumber];
    self.headerHourLabel.text = [[AppModel sharedInstance] phoningHours];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.tableView reloadData];
    });
}

- (void)disableButtons
{
    self.tableView.allowsSelection = NO;
}

- (void)enableButtons
{
    self.tableView.allowsSelection = YES;
}


#pragma mark - Private

- (void)buildUIElements
{
    
    self.view.backgroundColor = [UIColor clearColor];
    
//    self.tableView.backgroundColor = COSTA_BLUE_COLOR;
    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor whiteColor];
//    self.tableView.separatorInset = UIEdgeInsetsMake(5, 20, 0, 20);
    self.tableViewTrailingConstraint.constant = [[SlideNavigationController sharedInstance] portraitSlideOffset];
    
//    self.tableViewBottomConstraint.constant = MAIN_SCREEN_HEIGHT - ([_menuSections count] * [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] + self.tableView.contentInset.top + 5);
//    
//    DDLogDebug(@"bottom constraint : %@", self.tableViewBottomConstraint);
//    DDLogDebug(@"bottom constraint const : %f", MAIN_SCREEN_HEIGHT - ([_menuSections count] * [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]));
    
    [self.tableView registerClass:[HeaderView class] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"FooterView"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuCell class]) bundle:MAIN_BUNDLE] forCellReuseIdentifier:NSStringFromClass([MenuCell class])];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    DDLogDebug(@"nb section : %ld", (long)[self.menuSections count]);
    return [self.menuSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MenuSection *menuSection = [self.menuSections objectAtIndex:section];
    return [menuSection.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = NSStringFromClass([MenuCell class]);
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    MenuSection *menuSection = [self.menuSections objectAtIndex:indexPath.section];
    MenuItem *item = [menuSection.items objectAtIndex:indexPath.row];
    
    [cell setItem:item value:indexPath delegate:self];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuSection *menuSection = [self.menuSections objectAtIndex:indexPath.section];
    MenuItem *item = [menuSection.items objectAtIndex:indexPath.row];

    return [MenuCell cellHeightWithItem:item value:nil];
}



#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([HeaderView class])];
    if (!view)
    {
        view = [[HeaderView alloc] initWithReuseIdentifier:NSStringFromClass([HeaderView class])];
    }
    
    view.contentView.backgroundColor = [UIColor blackColor];
    view.titleLabel.textColor = [UIColor whiteColor];
    view.titleLabel.font = [UIFont boldSystemFontOfSize:12];

    
    MenuSection *menuSection = [_menuSections objectAtIndex:section];
    view.titleLabel.text = menuSection.title;
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *index = [tableView indexPathForSelectedRow];
    if (index)
    {
        [tableView deselectRowAtIndexPath:index animated:NO];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogInfo(@"");
    
    MenuSection *menuSection = [self.menuSections objectAtIndex:indexPath.section];
    MenuItem *item = [menuSection.items objectAtIndex:indexPath.row];
    
    MainViewController *vc = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    vc.urlToLoad = [NSURL URLWithString:[[[AppModel sharedInstance] baseURL] stringByAppendingString:item.contentURL]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[SlideNavigationController sharedInstance] setViewControllers:@[vc]];
        [[AppController sharedInstance] showWaitingView];
        
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
            
        }];
    });
    
//    [[SlideNavigationController sharedInstance] setViewControllers:@[vc] animated:YES];

    
    
    
    
    
}


@end
