//
//  MenuSection.m
//  QCNS-Web-App
//
//  Created by Paul Antonelli on 21/05/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "MenuSection.h"

@interface MenuSection () 

@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSArray<MenuItem *> *items;

@end

@implementation MenuSection

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        NSString *strTMP = [[dict allKeys] firstObject];
        NilCheck(strTMP);
        _title = [strTMP copy];
        
        NSDictionary *itemsDict = [dict objectForKey:_title];
        NSMutableArray<MenuItem *> *mutArr = [NSMutableArray new];
        MenuItem *menuItem = nil;
        NSArray *sortedKeys = [[itemsDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        for (id key in sortedKeys)
        {
            menuItem = [[MenuItem alloc] initWithDict:[itemsDict objectForKey:key]];
            [mutArr addObject:menuItem];
        }
        
        _items = [NSArray arrayWithArray:mutArr];
        
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    MenuSection *section = [[MenuSection allocWithZone:zone] init];
    section->_title = [self.title copyWithZone:zone];
    
    section->_items = [self.items copyWithZone:zone];
    
    return section;
}

@end
