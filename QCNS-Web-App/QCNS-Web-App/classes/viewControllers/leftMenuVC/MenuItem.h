//
//  MenuItem.h
//  QCNS-Web-App
//
//  Created by Paul Antonelli on 07/03/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject <NSCopying>

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *contentURL;
@property (nonatomic, readonly) NSString *imageURL;
@property (nonatomic, readonly) NSString *backgroundColor;
@property (nonatomic, readonly) NSString *price;


- (instancetype)initWithDict:(NSDictionary *)dict;

@end
