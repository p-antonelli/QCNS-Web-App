//
//  MenuItem.m
//  QCNS-Web-App
//
//  Created by Paul Antonelli on 07/03/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "MenuItem.h"

@interface MenuItem ()

@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *contentURL;
@property (nonatomic, readwrite) NSString *imageURL;
@property (nonatomic, readwrite) NSString *backgroundColor;

@end

@implementation MenuItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        NSString *strTMP = [dict objectForKey:@"titre"];
        NilCheck(strTMP);
        _title = [strTMP copy];
        
        strTMP = [dict objectForKey:@"lien"];
        NilCheck(strTMP);
        _contentURL = [strTMP copy];
        
        strTMP = [dict objectForKey:@"picto_url"];
        NilCheck(strTMP);
        _imageURL = [strTMP copy];
        
        strTMP = [dict objectForKey:@"couleur"];
        NilCheck(strTMP);
        _backgroundColor = [strTMP copy];
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    MenuItem *item = [[self class] allocWithZone:zone];
    
    item->_title = [self.title copyWithZone:zone];
    item->_contentURL = [self.contentURL copyWithZone:zone];
    item->_imageURL = [self.imageURL copyWithZone:zone];
    item->_backgroundColor = [self.backgroundColor copyWithZone:zone];
    
    return item;
}

#pragma mark - Private

- (NSDictionary *)dictionaryRepresentation
{
    NSDictionary *dict = @{@"title" : _title ?: @"",
                           @"contentURL" : _contentURL ?: @"",
                           @"imageURL" : _imageURL ?: @"",
                           @"backgroundColor" : _backgroundColor ?: @""
                           };
    return dict;
}

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@" %@", [self dictionaryRepresentation]];
}


@end
