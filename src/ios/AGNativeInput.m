

#import "AGNativeInput.h"

//
//  AGInputView.m
//  AppGyver
//
//  Copyright (c) 2015 AppGyver Inc. All rights reserved.
//

@interface AGNativeInput ()

@property (nonatomic) UIEdgeInsets webViewOriginalBaseScrollInsets;

@property (nonatomic, strong) NSDate* lastOnChange;

@property (nonatomic, strong) NSString* lastTextSentOnChange;

@property (nonatomic, strong) NSString* onChangeCallbackId;

@property (nonatomic, strong) NSString* onFocusCallbackId;

@property (nonatomic, strong) NSString* onBlurCallbackId;

@property (nonatomic, strong) NSString* onShowCallbackId;

@property (nonatomic, strong) NSString* onHideCallbackId;

@property (nonatomic, strong) NSString* onKeyboardActionCallbackId;

@property (nonatomic, strong) NSString* onButtonActionCallbackId;

@property (nonatomic) CGFloat originalLeftXPosition;

@property (nonatomic) BOOL autoCloseKeyboard;

@end

@implementation AGNativeInput

NSTimeInterval ON_CHANGE_LIMIT = 0.5;

//argument positions
int PANEL_ARG = 0;
int INPUT_ARG = 1;
int LEFT_BUTTON_ARG = 2;
int RIGHT_BUTTON_ARG = 3;

@synthesize inputView, webViewOriginalBaseScrollInsets, originalLeftXPosition, lastOnChange, lastTextSentOnChange, onChangeCallbackId, onFocusCallbackId, onBlurCallbackId, onShowCallbackId, onHideCallbackId, onKeyboardActionCallbackId, onButtonActionCallbackId, autoCloseKeyboard;

- (AGNativeInput*)initWithWebView:(UIWebView*)theWebView {
    self = (AGNativeInput*)[super initWithWebView:(UIWebView*)theWebView];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    
    self.inputView = [self loadAGInputView];
    
    //move to setup pixate
    self.inputView.styleClass = @"nativeInput-panel";
    self.inputView.inputField.styleClass = @"nativeInput";
    self.inputView.leftButton.styleClass = @"nativeInput-leftButton";
    self.inputView.rightButton.styleClass = @"nativeInput-rightButton";
    [self.inputView updateStyles];
    
    self.inputView.inputField.delegate = self;
    self.inputView.delegate = self;
    
    self.webViewOriginalBaseScrollInsets = self.webViewController.baseScrollInsets;
    
    self.lastOnChange = [NSDate date];
    
    self.originalLeftXPosition = self.inputView.leftButton.frame.origin.x;
    
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
    // register for keyboard notifications                                           
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                            selector:@selector(keyboardFrameWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification 
                                                object:nil];
}

-(int)inputViewHeight{
    return 46;
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

-(void)removeInputViewFromSuperView{
    [self.inputView removeFromSuperview];
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

-(void)setInpuFieldOptions:(NSDictionary*)inputOptions {
    inputView.inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputView.inputField.enablesReturnKeyAutomatically = TRUE;
    
    NSString* placeHolder = (NSString*)[inputOptions valueForKey:@"placeHolder"];
    inputView.inputField.placeholder = placeHolder;
    
    NSString* type = (NSString*)[inputOptions valueForKey:@"type"];
    if([@"uri" isEqualToString:type]){
        inputView.inputField.keyboardType = UIKeyboardTypeURL;
    }
    else if([@"number" isEqualToString:type]){
        inputView.inputField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if([@"email" isEqualToString:type]){
        inputView.inputField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else{
        inputView.inputField.keyboardType = UIKeyboardTypeDefault;
    }
    
    NSString* styleClass = @"nativeInput";
    if([self isNotNull:[inputOptions valueForKey:@"styleClass"]]){
        styleClass = (NSString*)[inputOptions valueForKey:@"styleClass"];
    }
    
    NSString* styleId = (NSString *) [inputOptions valueForKey:@"styleId"];
    NSString* styleCss = (NSString *) [inputOptions valueForKey:@"styleCSS"];
    
    inputView.inputField.styleClass = styleClass;
    if(styleId){
        inputView.inputField.styleId = styleId;
    }
    if(styleCss){
        inputView.inputField.styleCSS = styleCss;
    }
    [inputView.inputField updateStyles];
}

-(void)setPanelOptions:(NSDictionary*)options{
    
    NSString* styleClass = @"nativeInput-panel";
    
    if([self isNotNull:[options valueForKey:@"styleClass"]]){
        styleClass = (NSString*)[options valueForKey:@"styleClass"];
    }
    NSString* styleId = (NSString *) [options valueForKey:@"styleId"];
    NSString* styleCss = (NSString *) [options valueForKey:@"styleCSS"];
    
    inputView.styleClass = styleClass;
    if(styleId){
        inputView.styleId = styleId;
    }
    if(styleCss){
        inputView.styleCSS = styleCss;
    }
    [inputView updateStyles];
}

-(void)setButton:(UIButton*)button withOptions:(NSDictionary*)options{

    NSString* styleClass = (NSString *) [options valueForKey:@"styleClass"];
    NSString* styleId = (NSString *) [options valueForKey:@"styleId"];
    NSString* styleCss = (NSString *) [options valueForKey:@"styleCSS"];
    BOOL cssSet = NO;
    
    if(styleClass){
        button.styleClass = styleClass;
        cssSet = YES;
    }
    if(styleId){
        button.styleId = styleId;
        cssSet = YES;
    }
    if(styleCss){
        button.styleCSS = styleCss;
        cssSet = YES;
    }
    
    if(cssSet){
        [button updateStyles];
    }
}

-(BOOL)isNotNull:(id)obj{
    return obj != nil &&
            ! [[NSNull null] isEqual:obj];
}


-(BOOL)isValidDictionaryWithValues:(id)options{
    return ([self isNotNull:options] &&
            [options isKindOfClass:[NSDictionary class]] &&
            [(NSDictionary*)options count] > 0);
    
}

-(void)addInputViewToSuperView{
    
    if([self.webView.superview.subviews containsObject:self.inputView]){
        return;
    }
    
    [self.webView.superview addSubview:self.inputView];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(inputView);
    NSDictionary *metrics = @{
                              @"inputViewHeight":[NSNumber numberWithInt:self.inputViewHeight],
                              @"bottomGap":[NSNumber numberWithInt:self.bottomGap]
                              };
    
    [self.webView.superview.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[inputView]|"
                                                                                             options:0 metrics:metrics views:viewsDictionary]];
    
    [self.webView.superview.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[inputView(inputViewHeight)]-bottomGap-|"
                                                                                             options:0 metrics:metrics views:viewsDictionary]];
}

- (void)setup:(CDVInvokedUrlCommand*)command{
    
    [self increateWebViewBaseScrollInsets];
    [self addInputViewToSuperView];
    
    self.inputView.hidden = NO;
    
    if([self isValidDictionaryWithValues:[command.arguments objectAtIndex:PANEL_ARG]]){
        NSDictionary* inputOptions = (NSDictionary*)[command.arguments objectAtIndex:INPUT_ARG];
        [self setInpuFieldOptions:inputOptions];
    }
    
    if([self isValidDictionaryWithValues:[command.arguments objectAtIndex:PANEL_ARG]]){
        NSDictionary* panelOptions = (NSDictionary*)[command.arguments objectAtIndex:PANEL_ARG];
        [self setPanelOptions:panelOptions];
    }
    
    BOOL showLeftButton = [self isValidDictionaryWithValues:[command.arguments objectAtIndex:LEFT_BUTTON_ARG]];
    BOOL showRightButton = [self isValidDictionaryWithValues:[command.arguments objectAtIndex:RIGHT_BUTTON_ARG]];
    
    if(showLeftButton && showRightButton){
        [self setButton:self.inputView.leftButton withOptions:(NSDictionary*)[command.arguments objectAtIndex:LEFT_BUTTON_ARG]];
        [self setButton:self.inputView.rightButton withOptions:(NSDictionary*)[command.arguments objectAtIndex:RIGHT_BUTTON_ARG]];
        
        [self.inputView showButtons];
    }
    else if(showLeftButton){
        [self setButton:self.inputView.leftButton withOptions:(NSDictionary*)[command.arguments objectAtIndex:LEFT_BUTTON_ARG]];
        
        [self.inputView showLeftButton];
    }
    else if(showRightButton){
        [self setButton:self.inputView.rightButton withOptions:(NSDictionary*)[command.arguments objectAtIndex:RIGHT_BUTTON_ARG]];
        
        [self.inputView showRightButton];
    }
    else{
        [self.inputView hideButtons];
    }
    
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)show:(CDVInvokedUrlCommand*)command{
    if(command.arguments.count > 0 && [self isNotNull:[command.arguments objectAtIndex:0]]){
        NSString* value = [command.arguments objectAtIndex:0];
        self.inputView.inputField.text = value;
    }
    
    [self addInputViewToSuperView];
    
    self.inputView.hidden = NO;
    
    [inputView.inputField becomeFirstResponder];
    
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)hide:(CDVInvokedUrlCommand*)command{
    [self resetWebViewBaseScrollInsets];
    self.inputView.hidden = YES;
}

- (void)closeKeyboard:(CDVInvokedUrlCommand*)command{
    [self.inputView.inputField resignFirstResponder];
}

- (void)onButtonAction:(CDVInvokedUrlCommand*)command{
    self.onButtonActionCallbackId = command.callbackId;
}

- (void)onKeyboardAction:(CDVInvokedUrlCommand*)command{
    
    if(command.arguments.count > 0 && [self isNotNull:[command.arguments objectAtIndex:0]]){
        self.autoCloseKeyboard = [[command.arguments objectAtIndex:0] boolValue];
    }
    
    self.onKeyboardActionCallbackId = command.callbackId;
}

- (void)onChange:(CDVInvokedUrlCommand*)command{
    self.onChangeCallbackId = command.callbackId;
}

- (void)onFocus:(CDVInvokedUrlCommand*)command{
    self.onFocusCallbackId = command.callbackId;
}

- (void)onBlur:(CDVInvokedUrlCommand*)command{
    self.onBlurCallbackId = command.callbackId;
}

- (void)onShow:(CDVInvokedUrlCommand*)command{
    self.onShowCallbackId = command.callbackId;
}

- (void)onHide:(CDVInvokedUrlCommand*)command{
    self.onHideCallbackId = command.callbackId;
}

- (void)getValue:(CDVInvokedUrlCommand*)command{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:self.inputView.inputField.text];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setValue:(CDVInvokedUrlCommand*)command{
    if(command.arguments.count > 0 && [self isNotNull:[command.arguments objectAtIndex:0]]){
        NSString* value = [command.arguments objectAtIndex:0];
        self.inputView.inputField.text = value;
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
    }
    else{
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Parameter required!"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

-(void)sendOnChangeEvent{
    NSString* text = self.inputView.inputField.text;
    if([text isEqualToString:self.lastTextSentOnChange]){
        return;
    }
    self.lastTextSentOnChange = text;
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:text];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.onChangeCallbackId];
}

-(void)sendOnFocusEvent{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.onFocusCallbackId];
}

-(void)sendOnBlurEvent{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.onBlurCallbackId];
}

-(void)sendOnShowEvent{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.onShowCallbackId];
}

-(void)sendOnHideEvent{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.onHideCallbackId];
}

//Method use to avoid sending too much events down the pipe for every key stroke
//if a key stroke has
-(void)scheduleOnChangeDelivery{
    __weak typeof (self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        __strong typeof (self) strongSelf = weakSelf;
        
        NSTimeInterval interval = [[NSDate new] timeIntervalSinceDate:self.lastOnChange];
        if(interval > ON_CHANGE_LIMIT){
            strongSelf.lastOnChange = [NSDate new];
            [strongSelf sendOnChangeEvent];
        }
        else{
            [strongSelf scheduleOnChangeDelivery];
        }
        
    });
}

-(void)sendKeyboardAction{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"newline"];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.onKeyboardActionCallbackId];
}

#pragma AGInputViewDelegate
- (void)buttonTapped:(UIButton *)button{
    NSString* side;
    
    if(button == self.inputView.leftButton){
        side = @"left";
    }
    if(button == self.inputView.rightButton){
        side = @"right";
    }
    
    if(self.onButtonActionCallbackId){
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:side];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.onButtonActionCallbackId];
    }
}

#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(self.onChangeCallbackId != nil){
        [self scheduleOnChangeDelivery];
    }
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    if(self.onBlurCallbackId != nil){
        [self sendOnBlurEvent];
    }
    return YES;
}

- (BOOL) textFieldShouldStartEditing:(UITextField *)textField {
    if(self.onFocusCallbackId != nil){
        [self sendOnFocusEvent];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(self.onKeyboardActionCallbackId != nil){
        [self sendKeyboardAction];
        if(self.autoCloseKeyboard){
            [self closeKeyboard:nil];
        }
    }
    return NO;
}

#pragma Keyboard Events
-(CGFloat)tabBarHeight{
    return self.webViewController.tabBarHeight;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if(self.onHideCallbackId != nil){
        [self sendOnHideEvent];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];

    CGRect newFrame = self.webView.frame;
    newFrame.origin.y = 0;
    self.webView.frame = newFrame;
    
    CGRect newInputFrame = inputView.frame;
    newFrame.origin.y = self.superViewFrame.size.height - inputView.frame.size.height;
    inputView.frame = newInputFrame;

    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if(self.onShowCallbackId != nil){
        [self sendOnShowEvent];
    }
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];

    CGRect newFrame = self.webView.frame;
    CGRect keyboardFrameEnd = [self.webView convertRect:keyboardEndFrame toView:nil];
    CGRect keyboardFrameBegin = [self.webView convertRect:keyboardBeginFrame toView:nil];

    newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y);
    self.webView.frame = newFrame;
    
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    
    CGRect newInputFrame = inputView.frame;
    newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y);
    inputView.frame = newInputFrame;

    [UIView commitAnimations];
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

@end
