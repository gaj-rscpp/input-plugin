//
//  AGInputView.m
//  AppGyver
//
//  Created by Rafael Almeida on 6/07/15.
//  Copyright (c) 2015 AppGyver Inc. All rights reserved.
//

#import "AGInputView.h"

@interface AGInputView()


@end



@implementation AGInputView

@synthesize leftButton, rightButton, inputField;

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


-(void)setupDefaults{
    
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.




@end
