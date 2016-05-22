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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTrailingConstraint;

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
    DDLogDebug(@"bottom constraint : %@", self.tableViewBottomConstraint);
    DDLogDebug(@"bottom constraint const : %f", MAIN_SCREEN_HEIGHT - ([_tableArray count] * [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]));
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
    
    self.tableView.backgroundColor = COSTA_BLUE_COLOR;
    self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(5, 20, 0, 20);
    self.tableViewTrailingConstraint.constant = [[SlideNavigationController sharedInstance] portraitSlideOffset];
    
    self.tableViewBottomConstraint.constant = MAIN_SCREEN_HEIGHT - ([_tableArray count] * [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] + self.tableView.contentInset.top + 5);
    
    DDLogDebug(@"bottom constraint : %@", self.tableViewBottomConstraint);
    DDLogDebug(@"bottom constraint const : %f", MAIN_SCREEN_HEIGHT - ([_tableArray count] * [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]));
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"Header"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuCell class]) bundle:MAIN_BUNDLE] forCellReuseIdentifier:NSStringFromClass([MenuCell class])];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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
    MenuItem *item = [self.tableArray objectAtIndex:indexPath.row];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
}


@end
