//
//  AGInputView.m
//  AppGyver
//
//  Created by Rafael Almeida on 6/07/15.
//  Copyright (c) 2015 AppGyver Inc. All rights reserved.
//

#import "AGInputView.h"

@interface AGInputView()

@property (nonatomic, strong) NSArray* leftConstraints;

@property (nonatomic, strong) NSArray* rightConstraints;

@property (nonatomic, strong) NSArray* noButtonsConstraints;

@property (nonatomic, strong) NSArray* bothButtonsConstraints;

@property (nonatomic, strong) NSArray* currentConstraints;

@end

@implementation AGInputView

@synthesize leftButton, rightButton, inputField, leftConstraints, rightConstraints, noButtonsConstraints, bothButtonsConstraints, currentConstraints = _currentConstraints, delegate;

-(AGInputView*)init{
    self = [super init];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (AGInputView*)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (AGInputView*)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (IBAction)buttonTapped:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(buttonTapped:)]) {
        [self.delegate buttonTapped:button];
    }
}

-(NSNumber*)buttonGap{
    return [NSNumber numberWithInt:52];
}

-(void)setupDefaults{
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)createConstraints{
    if(self.noButtonsConstraints){
        return;
    }
    
    NSDictionary* viewsDictionary = NSDictionaryOfVariableBindings(inputField);
    NSDictionary *metrics = @{@"buttonGap":self.buttonGap};
    
    self.noButtonsConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[inputField]-8-|"
                                                                        options:0 metrics:metrics views:viewsDictionary];
    
    self.bothButtonsConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-buttonGap-[inputField]-buttonGap-|"
                                                                        options:0 metrics:metrics views:viewsDictionary];
    
    self.leftConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-buttonGap-[inputField]-8-|"
                                                                   options:0 metrics:metrics views:viewsDictionary];
    
    self.rightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[inputField]-buttonGap-|"
                                                                   options:0 metrics:metrics views:viewsDictionary];
    
}

-(UIView*)constraintsView{
    return self.superview.superview;
}

-(void)removeCurrentConstraints{
    if(self.currentConstraints){
        [self.constraintsView removeConstraints:self.currentConstraints];
    }
}

-(void)setCurrentConstraints:(NSArray*)constraints{
    if(constraints == _currentConstraints){
        return;
    }
    [self removeCurrentConstraints];
    _currentConstraints = constraints;
    [self.constraintsView addConstraints:constraints];
    [self needsUpdateConstraints];
}

-(void)hideButtons{
    [self createConstraints];
    [self setCurrentConstraints:self.noButtonsConstraints];
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
}

-(void)showButtons{
    [self createConstraints];
    [self setCurrentConstraints:self.bothButtonsConstraints];
    self.leftButton.hidden = NO;
    self.rightButton.hidden = NO;
}

-(void)showLeftButton{
    [self createConstraints];
    [self setCurrentConstraints:self.leftConstraints];
    self.leftButton.hidden = NO;
    self.rightButton.hidden = YES;
}

-(void)showRightButton{
    [self createConstraints];
    [self setCurrentConstraints:self.rightConstraints];
    self.leftButton.hidden = YES;
    self.rightButton.hidden = NO;
}

@end
