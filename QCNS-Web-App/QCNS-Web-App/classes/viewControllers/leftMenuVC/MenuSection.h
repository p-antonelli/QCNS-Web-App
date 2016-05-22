//
//  MenuSection.h
//  QCNS-Web-App
//
//  Created by Paul Antonelli on 21/05/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuItem.h"

@interface MenuSection : NSObject <NSCopying>

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSArray<MenuItem *> *items;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
