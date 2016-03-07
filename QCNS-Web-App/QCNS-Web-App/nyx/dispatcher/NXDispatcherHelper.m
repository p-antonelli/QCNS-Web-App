//
//  NXDispatcherHelper.m
//  Feezly
//
//  Created by Paul Antonelli on 27/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NXDispatcherHelper.h"

/**
 * Source:
 * http://stackoverflow.com/questions/4139219/how-do-you-trigger-a-block-after-a-delay-like-performselectorwithobjectafter
 */
void dispatch_after_delay(float delayInSeconds, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, queue, block);
}

void dispatch_after_delay_on_main_queue(float delayInSeconds, dispatch_block_t block)
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_after_delay(delayInSeconds, queue, block);
}

void dispatch_async_on_high_priority_queue(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block);
}

void dispatch_async_on_background_queue(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

void dispatch_async_on_main_queue(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}
