//
//  ALWStepper.h
//  Pods
//
//  Created by lisong on 2017/7/19.
//
//

#import <UIKit/UIKit.h>

typedef void(^ALWStepperUpdateValueBlock)(NSInteger currentValue);

@interface ALWStepper : UIView

@property(nonatomic, assign) NSInteger minValue;
@property(nonatomic, assign) NSInteger maxValue;
@property(nonatomic, assign) NSInteger stepValue;
@property(nonatomic, assign) NSInteger currentValue;//初始为minValue

@property(nonatomic, strong) UIFont *textFont;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic, strong) UIColor *borderColor;

/**
 默认不禁用加减按钮
 */
@property(nonatomic, assign) BOOL disableButton;

/**
 默认不能编辑输入框
 */
@property(nonatomic, assign) BOOL canEdit;

/**
 采用默认size初始化
 
 @param minValue minValue description
 @param maxValue maxValue description
 @param stepValue stepValue description
 @param updateValueBlock updateValueBlock description
 @return return value description
 */
- (instancetype)initWithMinValue:(NSInteger)minValue maxValue:(NSInteger)maxValue stepValue:(NSInteger)stepValue updateValueBlock:(ALWStepperUpdateValueBlock)updateValueBlock;

/**
 全部参数自己设定
 
 @param frame frame description
 @param minValue minValue description
 @param maxValue maxValue description
 @param stepValue stepValue description
 @param updateValueBlock 可以为nil
 @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue stepValue:(NSInteger)stepValue updateValueBlock:(ALWStepperUpdateValueBlock)updateValueBlock;

- (void)setLeftButtonImage:(UIImage *)image forState:(UIControlState)state;
- (void)setRightButtonImage:(UIImage *)image forState:(UIControlState)state;

- (void)resignAllFirstResponder;

@end
