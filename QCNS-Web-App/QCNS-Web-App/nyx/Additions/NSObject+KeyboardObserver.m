//
//  NSObject+KeyboardObserver.m
//  Feezly
//
//  Created by Paul Antonelli on 23/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NSObject+KeyboardObserver.h"
#import <objc/runtime.h>


@interface NSObject ()

@property (nonatomic, readwrite, setter = setObservingKeyboardEvents:) BOOL isObservingKeyboardEvents;

@end

@implementation NSObject (KeyboardObserver)

static const char* bbViewControllerIsObservingKeyboard = "BBViewControllerIsObservingKeyboard";
static const char* bbViewControllerKeyboardDelegate = "BBViewControllerKeyboardDelegate";

@dynamic isObservingKeyboardEvents;
@dynamic keyboardDelegate;

- (BOOL)isObservingKeyboardEvents {    return [objc_getAssociatedObject(self, &bbViewControllerIsObservingKeyboard) boolValue]; }
- (void)setObservingKeyboardEvents:(BOOL)isObserving {  objc_setAssociatedObject(self, &bbViewControllerIsObservingKeyboard, @(isObserving), OBJC_ASSOCIATION_RETAIN_NONATOMIC);}

- (id<NXKeyboardDelegate>)keyboardDelegate {    return objc_getAssociatedObject(self, &bbViewControllerKeyboardDelegate); }
- (void)setKeyboardDelegate:(id<NXKeyboardDelegate>)keyboardDelegate {  objc_setAssociatedObject(self, &bbViewControllerKeyboardDelegate, keyboardDelegate, OBJC_ASSOCIATION_ASSIGN);}


- (void)startObservingKeyboardEvents:(id<NXKeyboardDelegate>)delegate
{
    self.keyboardDelegate = delegate;
    self.isObservingKeyboardEvents = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideNotification:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)stopObservingKeyboardEvents
{
    self.keyboardDelegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    self.isObservingKeyboardEvents = NO;
}

#pragma mark - Private Methods

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    //    DDLogDebug(@"");
    if ([self.keyboardDelegate respondsToSelector:@selector(pa_keyboardWillShow:)]) {
        [self.keyboardDelegate pa_keyboardWillShow:[notification userInfo]];
    }
}

- (void)keyboardDidShowNotification:(NSNotification *)notification
{
    //    DDLogDebug(@"");
    if ([self.keyboardDelegate respondsToSelector:@selector(pa_keyboardDidShow:)]) {
        [self.keyboardDelegate pa_keyboardDidShow:[notification userInfo]];
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    //    DDLogDebug(@"");
    if ([self.keyboardDelegate respondsToSelector:@selector(pa_keyboardWillHide:)]) {
        [self.keyboardDelegate pa_keyboardWillHide:[notification userInfo]];
    }
}

- (void)keyboardDidHideNotification:(NSNotification *)notification
{
    //    DDLogDebug(@"");
    if ([self.keyboardDelegate respondsToSelector:@selector(pa_keyboardDidHide:)]) {
        [self.keyboardDelegate pa_keyboardDidHide:[notification userInfo]];
    }
}


@end
