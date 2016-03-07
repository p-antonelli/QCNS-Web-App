//
//  NXAlertViewHandler.h
//  NXFramework
//
//  Created by Paul Antonelli on 23/05/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

@import UIKit;

@class NXAlertViewHandler;


@protocol NXAlertViewHandlerDelegate <NSObject>

// Called when a handler has been called and his job is done
- (void)handlerDidFinish:(NXAlertViewHandler *)handler;

@end



@interface NXAlertViewHandler : NSObject <UIAlertViewDelegate>

// Blocks
@property (nonatomic, strong) void(^yesBlock)(void);
@property (nonatomic, strong) void(^noBlock)(void);

// Delegate
@property (nonatomic, assign) id<NXAlertViewHandlerDelegate> delegate;

@end
