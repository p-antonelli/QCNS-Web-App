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

- (instancetype)initWithTitle:(NSString *)title contentDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
//        DDLogError(@"dict : %@", dict);
        
        _title = [title copy];
        
        NSMutableArray<MenuItem *> *mutArr = [NSMutableArray new];
        MenuItem *menuItem = nil;
        NSArray *sortedKeys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        for (id key in sortedKeys)
        {
            menuItem = [[MenuItem alloc] initWithDict:[dict objectForKey:key]];
            [mutArr addObject:menuItem];
        }
        
        _items = [NSArray arrayWithArray:mutArr];
        
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    MenuSection *section = [[MenuSection allocWithZone:zone] init];
    section->_title = [self.title copyWithZone:zone];
    
    section->_items = [self.items copyWithZone:zone];
    
    return section;
}

#pragma mark - Private

- (NSDictionary *)dictionaryRepresentation
{
    NSDictionary *dict = @{@"title" : _title ?: @"",
                           @"items" : _items};
    return dict;
}

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@" %@", [self dictionaryRepresentation]];
}


@end
