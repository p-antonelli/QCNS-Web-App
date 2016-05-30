//
//  NXURLParser.h
//  QCNS-Web-App
//
//  Created by Paul Antonelli on 30/05/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXURLParser : NSObject

@property (nonatomic, readonly) NSArray *variables;

- (instancetype)initWithURLString:(NSString *)url;
- (NSString *)valueForVariable:(NSString *)varName;

@end
