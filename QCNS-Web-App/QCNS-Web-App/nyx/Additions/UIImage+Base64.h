//
//  UIImage+Base64.h
//  Feezly
//
//  Created by Paul Antonelli on 17/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Base64)

- (NSString *)base64String;
+ (UIImage *)imageFromBase64String:(NSString *)string;


@end
