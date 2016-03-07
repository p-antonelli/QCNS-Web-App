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



static NSString * const kDefaultLanguage    = @"fr";
static NSString * const kDefaultLocale      = @"fr_FR";

#define kMaxNotifications   30


@interface AppModel ()

@property (nonatomic, readwrite) BOOL askPush;
@property (nonatomic, readwrite) BOOL askRating;


@property (nonatomic, readwrite) NSString *locale;
@property (nonatomic, readwrite) NSString *language;

@property (nonatomic, readwrite) NSArray<MenuItem *> *menuItems;

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
    DDLogInfo(@"");
    
    _askPush = action.response.askPush;
    _askRating = action.response.askRating;
    
    NSLog(@"json dict: %@", action.response.jsonDict);
    
//    [[NXLocalizer sharedInstance] loadLocalizationData:action.response.jsonDict forLocale:self.locale];
}




#pragma mark - Private

- (instancetype)initInternal
{
    self = [super init];
    if (self)
    {
        _locale = kDefaultLocale;
        _language = kDefaultLanguage;
        
        [self loadLocalFile];
        [self loadDataFromDisk];

    }
    return self;
}

- (BOOL)saveDataOnDisk
{
    DDLogInfo(@"");
    
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.user];
//    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"fz-user-data"];
//    [[NSUserDefaults standardUserDefaults] setBool:self.userIsLogged forKey:@"fz-user-login"];
//    BOOL res = [[NSUserDefaults standardUserDefaults] synchronize];
////    DDLogInfo(@"Saved user : %d %@", res, self.user);
//    
//    return res;
    return NO;
}
- (void)loadDataFromDisk
{
    DDLogInfo(@"");
//    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"fz-user-data"];
//    _user = data ? [NSKeyedUnarchiver unarchiveObjectWithData:data] : [[FZUser alloc] init];
//
//    DDLogInfo(@"Loaded user : %@", self.user);
}


#pragma mark - Locale (Fake - DEV ONLY)

- (void)loadLocalFile
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfJSONFile:@"fr_FR.json"];
//    DDLogInfo(@"Locale : %@ %@", self.locale, dict);
    [[NXLocalizer sharedInstance] loadLocalizationData:dict forLocale:self.locale];
}

@end
