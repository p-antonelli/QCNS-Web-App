//
//  AppModel.m
//  Feezly
//
//  Created by Paul Antonelli on 10/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "AppModel.h"
#import "NSDictionary+JSONFile.h"
#import "AppController.h"
#import "NSString+FontAwesome.h"


static NSString * const kDefaultLanguage    = @"fr";
static NSString * const kDefaultLocale      = @"fr_FR";

#define kMaxNotifications   30


@interface AppModel ()

@property (nonatomic, readwrite) NSString *locale;
@property (nonatomic, readwrite) NSString *language;

@property (nonatomic, readwrite) NSString *baseURL;
@property (nonatomic, readwrite) NSString *backgroundImageURL;
@property (nonatomic, readwrite) BOOL shouldCallDirectly;

@property (nonatomic, readwrite) NSString *phoningTitle;
@property (nonatomic, readwrite) NSString *phoningNumber;
@property (nonatomic, readwrite) NSString *phoningHours;

@property (nonatomic, readwrite) NSArray<MenuSection *> *menuSections;

@property (nonatomic, readwrite) NSArray<NSString *> *imageURLs;

@end

@implementation AppModel

#pragma mark - Public

+ (instancetype)sharedInstance
{
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initInternal];
    });
}



- (void)updateWithSetupAction:(SetupAction *)action
{
    DDLogInfo(@"setup response : %@", action.response);
    
    _baseURL = [action.response.baseURL copy];
    _backgroundImageURL = [action.response.backgroundImageURL copy];
    _shouldCallDirectly = action.response.shouldCallDirectly;
    
    _phoningTitle = [action.response.phoningTitle copy];
    _phoningNumber = [action.response.phoningNumber copy];
    _phoningHours = [action.response.phoningHours copy];
    
    _menuSections = [action.response.menuSections copy];
    
    NSMutableSet *mutSet = [NSMutableSet new];
    
    if ([_backgroundImageURL length] > 0)
    {
        [mutSet addObject:[_baseURL stringByAppendingString:_backgroundImageURL]];
    }
    
    DDLogError(@"back img url : %@", [_baseURL stringByAppendingString:_backgroundImageURL]);
    DDLogError(@"back img url : %@ | %@", _baseURL, _backgroundImageURL);
    DDLogError(@"");
    
    for (MenuSection *section in _menuSections)
    {
        for (MenuItem *item in section.items)
        {
            if ([item.imageURL length] > 0)
            {
                [mutSet addObject:[_baseURL stringByAppendingString:item.imageURL]];
            }
        }
    }
    
    _imageURLs = [NSArray arrayWithArray:[mutSet allObjects]];
    DDLogWarn(@"image urls : %@", _imageURLs);
}




#pragma mark - Private

- (instancetype)initInternal
{
    self = [super init];
    if (self)
    {
        _locale = kDefaultLocale;
        _language = kDefaultLanguage;
        
        [self setupCurrentBrand];
        
//        [self setupMenuItems];
        
        [self loadLocalFile];

    }
    return self;
}

- (void)setupCurrentBrand
{
    _currentBrand = QCNSBrandTypeCosta;
}

//- (void)setupMenuItems
//{
//    MenuItem *home = [[MenuItem alloc] initWithTitle:@"Accueil" imageName:@"menu-home"];
//    home.pictoText = [NSString stringForFontAwesomeIcon:FAHome];
//    MenuItem *promo = [[MenuItem alloc] initWithTitle:@"Promotions" imageName:@"menu-promo"];
//    promo.pictoText = [NSString stringForFontAwesomeIcon:FAGift];
//    MenuItem *dest = [[MenuItem alloc] initWithTitle:@"Destinations" imageName:@"menu-destinations"];
//    dest.pictoText = [NSString stringForFontAwesomeIcon:FAMapMarker];
//    MenuItem *harbor = [[MenuItem alloc] initWithTitle:@"Ports de départ" imageName:@"menu-harbors"];
//    harbor.pictoText = [NSString stringForFontAwesomeIcon:FAAnchor];
//    MenuItem *ships = [[MenuItem alloc] initWithTitle:@"Navires" imageName:@"menu-ships"];
//    ships.pictoText = [NSString stringForFontAwesomeIcon:FALifeBouy];
//    
//    _menuItems = @[home, promo, dest, harbor, ships];
//}


#pragma mark - Locale

- (void)loadLocalFile
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfJSONFile:@"fr_FR.json"];
    DDLogInfo(@"Locale : %@ %@", self.locale, dict);
    [[NXLocalizer sharedInstance] loadLocalizationData:dict forLocale:self.locale];
}

@end
