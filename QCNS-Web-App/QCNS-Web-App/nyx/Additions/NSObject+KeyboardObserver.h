//
//  NSObject+KeyboardObserver.h
//  Feezly
//
//  Created by Paul Antonelli on 23/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NXKeyboardDelegate;


@interface NSObject (KeyboardObserver)

@property (nonatomic, readonly) BOOL isObservingKeyboardEvents;

@property (weak, nonatomic, readwrite) id<NXKeyboardDelegate>keyboardDelegate;

- (void)startObservingKeyboardEvents:(id<NXKeyboardDelegate>)delegate;
- (void)stopObservingKeyboardEvents;

@end



@protocol NXKeyboardDelegate <NSObject>

@optional

- (void)pa_keyboardWillShow:(NSDictionary *)infoDict;
- (void)pa_keyboardDidShow:(NSDictionary *)infoDict;

- (void)pa_keyboardWillHide:(NSDictionary *)infoDict;
- (void)pa_keyboardDidHide:(NSDictionary *)infoDict;

@end
