//
//  NXAlertViewFactory.m
//  NXFramework
//
//  Created by Paul Antonelli on 23/05/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

#import "NXAlertViewFactory.h"
#import "NXAlertViewHandler.h"



@interface NXAlertViewFactory () <NXAlertViewHandlerDelegate>

// Handlers
@property (nonatomic, strong) NSMutableArray *handlers;

@end



@implementation NXAlertViewFactory

#pragma mark - Shared instance
+ (instancetype)sharedInstance
{
    static NXAlertViewFactory *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NXAlertViewFactory alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Constructor
- (id)init
{
    if (self = [super init])
    {
        // Initialize properties
        self.handlers = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Handler management
- (void)holdHandler:(NXAlertViewHandler *)handler
{
    // Add handler to held handlers
    [_handlers addObject:handler];
}

- (void)releaseHandler:(NXAlertViewHandler *)handler
{
    // Remove handler from held handlers
    [_handlers removeObject:handler];
}

#pragma mark - NXAlertViewHandlerDelegate methods
- (void)handlerDidFinish:(NXAlertViewHandler *)handler
{
    // Release handler
    [self releaseHandler:handler];
}

#pragma mark - Alert management
+ (UIAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
{    
    return [NXAlertViewFactory alertWithTitle:title
                                    message:message
                                 yesCaption:nil
                                  noCaption:@"Ok"
                                   yesBlock:nil
                                    noBlock:nil];
}

+ (UIAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
                     yesCaption:(NSString *)yesCaption
                      noCaption:(NSString *)noCaption
                       yesBlock:(void (^)(void))yesBlock
                        noBlock:(void (^)(void))noBlock
{
    // Prepare handler
    NXAlertViewHandler *handler = [[NXAlertViewHandler alloc] init];
    handler.yesBlock = yesBlock;
    handler.noBlock = noBlock;

    return [NXAlertViewFactory alertWithHandler:handler
                                           title:title
                                         message:message
                                      yesCaption:yesCaption
                                       noCaption:noCaption];
}

+ (UIAlertView *)alertWithHandler:(NXAlertViewHandler *)handler
                        title:(NSString *)title
                        message:(NSString *)message
                     yesCaption:(NSString *)yesCaption
                      noCaption:(NSString *)noCaption
{

    // Prepare handler if necessary
    if (handler.yesBlock || handler.noBlock)
    {
        // Get factory
        NXAlertViewFactory *factory = [NXAlertViewFactory sharedInstance];

        // Configure handler
        handler.delegate = factory;

        // Hold handler
        [factory holdHandler:handler];
    }
    else
    {
        handler = nil;
    }

    // Alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:handler
                                          cancelButtonTitle:noCaption
                                          otherButtonTitles:yesCaption, nil];
    [alert show];

    return alert;
}


@end
