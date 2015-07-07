

#import "AGNativeInput.h"

//
//  AGInputView.m
//  AppGyver
//
//  Created by Rafael Almeida on 6/07/15.
//  Copyright (c) 2015 AppGyver Inc. All rights reserved.
//

@interface AGNativeInput ()

@property (nonatomic) UIEdgeInsets webViewOriginalBaseScrollInsets;

@property (nonatomic) BOOL setupViewConstraints;

@end

@implementation AGNativeInput

@synthesize inputView, webViewOriginalBaseScrollInsets, setupViewConstraints;

- (AGNativeInput*)initWithWebView:(UIWebView*)theWebView {
    self = (AGNativeInput*)[super initWithWebView:(UIWebView*)theWebView];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    
    self.inputView = [self loadAGInputView];
    
    self.webViewOriginalBaseScrollInsets = self.webViewController.baseScrollInsets;
    
    [self setupNotifications];
}

-(void)setupNotifications{
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(int)inputViewHeight{
    return 48;
}

-(int)bottomGap{
    return self.webViewContentInsets.bottom - self.inputViewHeight;
}

-(AGInputView*)loadAGInputView{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"AGInputView" owner:self.webView.superview options:nil];
    for (id currentObject in nibViews) {
        if ([currentObject isKindOfClass:[AGInputView class]]) {
            return (AGInputView *) currentObject;
        }
    }
    return nil;
}

-(UIEdgeInsets)webViewContentInsets{
    return self.webView.scrollView.contentInset;
}

-(CGRect)superViewFrame{
    return self.webView.superview.frame;
}


-(CGFloat)tabBarHeight{
    return self.webViewController.tabBarHeight;
}

-(void)moveToAboveKeyboard:(NSDictionary*)userInfo{
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat newY = self.superViewFrame.size.height - keyboardSize.height - inputView.frame.size.height;
    
    [self moveToYPosition:newY animationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animationCurve:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
}

-(void)moveToBelowKeyboard:(NSDictionary*)userInfo{
    
    CGFloat newY = self.superViewFrame.size.height - self.tabBarHeight - inputView.frame.size.height;
    
    [self moveToYPosition:newY animationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animationCurve:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
}

-(void)moveToYPosition:(CGFloat)newY animationDuration:(NSTimeInterval)duration animationCurve:(NSTimeInterval)curve{
    CGRect newFrame = CGRectMake(inputView.frame.origin.x, newY, inputView.frame.size.width, inputView.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    inputView.frame = newFrame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self moveToBelowKeyboard:notification.userInfo];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self moveToAboveKeyboard:notification.userInfo];
}

-(void)removeInputViewFromSuperView{
    [self.inputView removeFromSuperview];
}

-(void)addInputViewTpSuperView{
    [self.webView.superview addSubview:self.inputView];
    
    //if(!self.setupViewConstraints){
        self.setupViewConstraints = YES;
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(inputView);
        NSDictionary *metrics = @{
                                  @"inputViewHeight":[NSNumber numberWithInt:self.inputViewHeight],
                                  @"bottomGap":[NSNumber numberWithInt:self.bottomGap]
                                  };
        
        [self.webView.superview.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[inputView]|"
                                                                                                 options:0 metrics:metrics views:viewsDictionary]];
        
        [self.webView.superview.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[inputView(inputViewHeight)]-bottomGap-|"
                                                                                                 options:0 metrics:metrics views:viewsDictionary]];
    //}
}

-(void)increateWebViewBaseScrollInsets{
    CGFloat newBottom = self.webViewOriginalBaseScrollInsets.bottom + self.inputViewHeight;
    
    self.webViewController.baseScrollInsets = UIEdgeInsetsMake(self.webViewController.baseScrollInsets.top, self.webViewController.baseScrollInsets.left, newBottom, self.webViewController.baseScrollInsets.right);
    
    [self.webViewController updateScrollInsets];
}

-(WebViewController*)webViewController{
    return (WebViewController*)self.viewController;
}

-(void)resetWebViewBaseScrollInsets{
    self.webViewController.baseScrollInsets = self.webViewOriginalBaseScrollInsets;
    [self.webViewController updateScrollInsets];
}


- (void)show:(CDVInvokedUrlCommand*)command{
    
    [self increateWebViewBaseScrollInsets];
    
    [self addInputViewTpSuperView];
}

- (void)hide:(CDVInvokedUrlCommand*)command{
    [self resetWebViewBaseScrollInsets];
    [self removeInputViewFromSuperView];
}

- (void)closeKeyboard:(CDVInvokedUrlCommand*)command{
    
}

- (void)onButtonAction:(CDVInvokedUrlCommand*)command{
    
}

- (void)onKeyboardAction:(CDVInvokedUrlCommand*)command{
    
}



- (void)onChange:(CDVInvokedUrlCommand*)command{
    
}

- (void)getValue:(CDVInvokedUrlCommand*)command{
    
}

- (void)setValue:(CDVInvokedUrlCommand*)command{
    
}

@end
