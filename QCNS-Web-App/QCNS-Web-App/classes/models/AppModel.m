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
#import "NXDevice.h"

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

static NSDictionary *splashImageDict;
static NSDictionary *navBarImageDict;

+ (void)initialize
{
    if (self == [AppModel class])
    {
        splashImageDict = @{
                            @(QCNSBrandTypeCosta) :         @"splash_costa",
                            @(QCNSBrandTypeMSC) :           @"splash_msc",
                            @(QCNSBrandTypeNCL) :           @"splash_ncl",
                            @(QCNSBrandTypeRCCL) :          @"splash_rccl",
                            @(QCNSBrandTypeCDF) :           @"splash_cdf",
                            @(QCNSBrandTypeCroisiEurope) :  @"splash_croisieurope",
                            };
        
        navBarImageDict = @{
                            @(QCNSBrandTypeCosta) :         @"navBar_costa",
                            @(QCNSBrandTypeMSC) :           @"navBar_msc",
                            @(QCNSBrandTypeNCL) :           @"navBar_ncl",
                            @(QCNSBrandTypeRCCL) :          @"navBar_rccl",
                            @(QCNSBrandTypeCDF) :           @"navBar_cdf",
                            @(QCNSBrandTypeCroisiEurope) :  @"navBar_croisieurope",
                            };
    }
}

#pragma mark - Public

+ (instancetype)sharedInstance
{
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initInternal];
    });
}



- (void)updateWithSetupAction:(SetupAction *)action
{
//    DDLogInfo(@"setup response : %@", action.response);
    
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
//        [mutSet addObject:[_baseURL stringByAppendingString:_backgroundImageURL]];
        [mutSet addObject:_backgroundImageURL];
    }
    
    DDLogError(@"back img url : %@", _backgroundImageURL);
    DDLogError(@"");
    
    for (MenuSection *section in _menuSections)
    {
        for (MenuItem *item in section.items)
        {
            if ([item.imageURL length] > 0)
            {
//                [mutSet addObject:[_baseURL stringByAppendingString:item.imageURL]];
                [mutSet addObject:item.imageURL];
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
        _locale = [NXDevice currentLocaleISO];
        _language = kDefaultLanguage;

        [self setupCurrentBrand];
        [self setupSplashImage];

        
        [self loadLocalFile];

    }
    return self;
}

- (void)setupSplashImage
{
    if ([NXDevice has3dot5InchScreen])
    {
        _splashImageName = [[splashImageDict objectForKey:@(_currentBrand)] stringByAppendingString:@"-700@2x.png"];
    }
    else if ([NXDevice has4InchScreen])
    {
        _splashImageName = [[splashImageDict objectForKey:@(_currentBrand)] stringByAppendingString:@"-700-568h@2x.png"];
    }
    else if ([NXDevice has4dot7InchScreen])
    {
        _splashImageName = [[splashImageDict objectForKey:@(_currentBrand)] stringByAppendingString:@"-800-667h@2x.png"];
    }
    else if ([NXDevice has5dot5InchScreen])
    {
        _splashImageName = [[splashImageDict objectForKey:@(_currentBrand)] stringByAppendingString:@"-800-Portrait-736h@3x.png"];
    }
    
    NSLog(@"### SPLASH IMAGE NAME : %@", _splashImageName);
    NSLog(@"### SPLASH IMAGE : %@", [UIImage imageNamed:_splashImageName]);
}

- (void)setupCurrentBrand
{
    
#ifdef COSTA
    _currentBrand = QCNSBrandTypeCosta;
#endif
    
#ifdef MSC
    _currentBrand = QCNSBrandTypeMSC;
#endif

#ifdef NCL
    _currentBrand = QCNSBrandTypeNCL;
#endif

#ifdef RCCL
    _currentBrand = QCNSBrandTypeRCCL;
#endif

#ifdef CDF
    _currentBrand = QCNSBrandTypeCDF;
#endif
    
#ifdef CROISIEUROPE
    _currentBrand = QCNSBrandTypeCroisiEurope;
#endif

    _navBarImageName = [navBarImageDict objectForKey:@(_currentBrand)];
    NSLog(@"### NAVBAR IMAGE NAME : %@", _navBarImageName);
}

#pragma mark - Locale

- (void)loadLocalFile
{
    NSString *jsonFileName = @"fr_FR.json";
    
    if (![self.locale hasPrefix:@"fr"])
    {
        jsonFileName = @"en_US.json";
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfJSONFile:jsonFileName];
    DDLogInfo(@"Locale : %@ %@", self.locale, dict);
    [[NXLocalizer sharedInstance] loadLocalizationData:dict forLocale:self.locale];
}

@end
