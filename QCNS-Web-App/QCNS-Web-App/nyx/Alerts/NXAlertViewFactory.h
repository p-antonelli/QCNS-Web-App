//
//  NXAlertViewFactory.h
//  NXFramework
//
//  Created by Paul Antonelli on 23/05/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

@import UIKit;

@class NXAlertViewHandler;

@interface NXAlertViewFactory : NSObject

// Creates and shows a simple alert with no actions and an OK button
+ (UIAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message;

// Creates and shows a complex alert with actions and custom button captions
+ (UIAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
                     yesCaption:(NSString *)yesCaption
                      noCaption:(NSString *)noCaption
                       yesBlock:(void (^)(void))yesBlock
                        noBlock:(void (^)(void))noBlock;

+ (UIAlertView *)alertWithHandler:(NXAlertViewHandler *)handler
                            title:(NSString *)title
                          message:(NSString *)message
                       yesCaption:(NSString *)yesCaption
                        noCaption:(NSString *)noCaption;


@end
