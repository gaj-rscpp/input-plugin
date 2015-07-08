//
//  AGInputView.h
//  AppGyver
//
//  Created by Rafael Almeida on 6/07/15.
//  Copyright (c) 2015 AppGyver Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AGInputViewDelegate
- (void)buttonTapped:(UIButton *)button;
@end

@interface AGInputView : UIView
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic, weak) NSObject<AGInputViewDelegate>* delegate;

- (IBAction)buttonTapped:(UIButton *)button;

-(void)hideButtons;
-(void)showButtons;
-(void)showLeftButton;
-(void)showRightButton;

@end
