//
//  NXAlertViewHandler.m
//  NXFramework
//
//  Created by Paul Antonelli on 23/05/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

#import "NXAlertViewHandler.h"



@implementation NXAlertViewHandler

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Execute actions according to buttons
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        // Cancel or negative answer
        if (_noBlock)
        {
            _noBlock();
        }
    }
    else
    {
        // Positive answer
        if (_yesBlock)
        {
            _yesBlock();
        }
    }
    
    // Notify delegate that the job is done
    [_delegate handlerDidFinish:self];
}

@end
