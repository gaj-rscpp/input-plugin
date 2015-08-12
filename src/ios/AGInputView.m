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

- (instancetype)initWithElementName:(NSString *)name
{
    self = [super init];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
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

-(void)setupDefaults{
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
}

-(void)createConstraints{
    if(self.noButtonsConstraints){
        return;
    }
    
    NSDictionary* viewsDictionary = NSDictionaryOfVariableBindings(inputField, leftButton, rightButton);
    NSDictionary *metrics = @{};
    
    self.noButtonsConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[inputField]-8-|"
                                                                        options:NSLayoutFormatAlignAllBottom metrics:metrics views:viewsDictionary];
    
    self.bothButtonsConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[leftButton]-8-[inputField]-8-[rightButton]-8-|"
                                                                        options:NSLayoutFormatAlignAllBottom metrics:metrics views:viewsDictionary];
                                                                        
    self.leftConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[leftButton]-8-[inputField]-8-|"
                                                                   options:NSLayoutFormatAlignAllBottom metrics:metrics views:viewsDictionary];
    
    self.rightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[inputField]-8-[rightButton]-8-|"
                                                                   options:NSLayoutFormatAlignAllBottom metrics:metrics views:viewsDictionary];
    
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
