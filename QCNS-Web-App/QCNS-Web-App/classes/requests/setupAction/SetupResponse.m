//
//  SetupResponse.m
//  Feezly
//
//  Created by Paul Antonelli on 21/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "SetupResponse.h"

@interface SetupResponse ()

//@property (nonatomic, readwrite) NSDictionary *jsonDict;
//@property (nonatomic, readwrite) BOOL askRating;
//@property (nonatomic, readwrite) BOOL askPush;

@property (nonatomic, readwrite) NSString *baseURL;
@property (nonatomic, readwrite) NSString *backgroundImageURL;
@property (nonatomic, readwrite) BOOL shouldCallDirectly;

@property (nonatomic, readwrite) NSString *phoningTitle;
@property (nonatomic, readwrite) NSString *phoningNumber;
@property (nonatomic, readwrite) NSString *phoningHours;

@property (nonatomic, readwrite) NSArray<MenuSection *> *menuSections;

@end

@implementation SetupResponse

- (instancetype)initWithDict:(NSDictionary *)dict error:(NSError *)error
{
    self = [super initWithDict:dict error:error];
    if (self)
    {
        NSString *strTMP = [dict objectForKey:@"base_url"];
        NilCheck(strTMP);
        _baseURL = [strTMP copy];
        
        strTMP = [dict objectForKey:@"background_img_url"];
        NilCheck(strTMP);
        _backgroundImageURL = [strTMP copy];
        
        NSNumber *numTMP = [dict objectForKey:@"appel_direct"];
        NilCheck(numTMP);
        _shouldCallDirectly = [numTMP boolValue];

        strTMP = [dict objectForKey:@"titre_tel"];
        NilCheck(strTMP);
        _phoningTitle = [strTMP copy];

        strTMP = [dict objectForKey:@"numero_tel"];
        NilCheck(strTMP);
        _phoningNumber = [strTMP copy];
        
        strTMP = [dict objectForKey:@"horaire_tel"];
        NilCheck(strTMP);
        _phoningHours = [strTMP copy];

        
        NSDictionary *menuDict = [dict objectForKey:@"menu"];
        NilCheck(menuDict);
        if (menuDict)
        {
            NSMutableArray *mutArr = [NSMutableArray new];
            MenuSection *section = nil;
            for (NSDictionary *dictTMP in menuDict)
            {
                section = [[MenuSection alloc] initWithDict:dictTMP];
                [mutArr addObject:section];
            }
            _menuSections = [NSArray arrayWithArray:mutArr];
        }
    }
    
    return self;
}

@end
