//
//  NXVideoView.h
//  Feezly
//
//  Created by Paul Antonelli on 27/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <UIKit/UIKit.h>

@import AVFoundation;

@interface NXVideoView : UIView

@property (nonatomic, strong) AVPlayer *player;

- (void)setVideoFillMode:(NSString *)fillMode;


@end
