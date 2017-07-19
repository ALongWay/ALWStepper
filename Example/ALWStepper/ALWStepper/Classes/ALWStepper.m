//
//  ALWStepper.m
//  Pods
//
//  Created by lisong on 2017/7/19.
//
//

#import "ALWStepper.h"

static NSString *const kImageAddDisable = @"DYStepper.bundle/addDisable";
static NSString *const kImageAddNormal = @"DYStepper.bundle/addNormal";
static NSString *const kImageMinusDisable = @"DYStepper.bundle/minusDisable";
static NSString *const kImageMinusNormal = @"DYStepper.bundle/minusNormal";

static const CGFloat kImageWidth = 26;
static const CGFloat kTextFieldWidth = 38;

@interface ALWStepper ()<UITextFieldDelegate>

@property(nonatomic, strong) ALWStepperUpdateValueBlock updateValueBlock;

@property(nonatomic, strong) UIButton *leftBtn;
@property(nonatomic, strong) UIButton *rightBtn;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UIView *topLine;
@property(nonatomic, strong) UIView *bottomLine;

@end

@implementation ALWStepper

- (instancetype)initWithMinValue:(NSInteger)minValue maxValue:(NSInteger)maxValue stepValue:(NSInteger)stepValue updateValueBlock:(ALWStepperUpdateValueBlock)updateValueBlock
{
    return [self initWithFrame:CGRectMake(0, 0, kImageWidth * 2 + kTextFieldWidth, kImageWidth) minValue:minValue maxValue:maxValue stepValue:stepValue updateValueBlock:updateValueBlock];
}

- (instancetype)initWithFrame:(CGRect)frame minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue stepValue:(NSInteger)stepValue updateValueBlock:(ALWStepperUpdateValueBlock)updateValueBlock
{
    self = [self initWithFrame:frame];
    if (self) {
        _minValue = minValue;
        _maxValue = maxValue;
        _stepValue = stepValue;
        _currentValue = minValue;
        
        _textFont = [UIFont systemFontOfSize:16];
        _textColor = [self colorWithRGB:0x333333];
        _borderColor = [self colorWithRGB:0xcccccc];
        
        _updateValueBlock = updateValueBlock;
        
        _disableButton = NO;
        _canEdit = NO;
        
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, height, height)];
    [_leftBtn setImage:[self getImagePNGWithName:kImageMinusNormal] forState:UIControlStateNormal];
    [_leftBtn setImage:[self getImagePNGWithName:kImageMinusDisable] forState:UIControlStateDisabled];
    [_leftBtn addTarget:self action:@selector(clickedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftBtn];
    
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - height, 0, height, height)];
    [_rightBtn setImage:[self getImagePNGWithName:kImageAddNormal] forState:UIControlStateNormal];
    [_rightBtn setImage:[self getImagePNGWithName:kImageAddDisable] forState:UIControlStateDisabled];
    [_rightBtn addTarget:self action:@selector(clickedRightButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftBtn.frame), 0, width - _leftBtn.frame.size.width - _rightBtn.frame.size.width, height)];
    _textField.delegate = self;
    [_textField setTextAlignment:NSTextAlignmentCenter];
    [_textField setEnabled:_canEdit];
    [_textField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_textField setReturnKeyType:UIReturnKeyDone];
    [self addSubview:_textField];
    
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_textField.frame), 0, _textField.frame.size.width, 0.5)];
    [_topLine setBackgroundColor:_borderColor];
    [self addSubview:_topLine];
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_textField.frame), height - 0.5, _textField.frame.size.width, 0.5)];
    [_bottomLine setBackgroundColor:_borderColor];
    [self addSubview:_bottomLine];
    
    [self fixValueZone];
    
    [self setCurrentValue:_currentValue];
}

#pragma mark - Getter/Setter
- (void)setMinValue:(NSInteger)minValue
{
    _minValue = minValue;
    
    [self fixValueZone];
}

- (void)setMaxValue:(NSInteger)maxValue
{
    _maxValue = maxValue;
    
    [self fixValueZone];
}

- (void)setStepValue:(NSInteger)stepValue
{
    _stepValue = stepValue;
}

- (void)setCurrentValue:(NSInteger)currentValue
{
    //修正value
    if (currentValue < _minValue) {
        currentValue = _minValue;
    }
    
    if (currentValue > _maxValue) {
        currentValue = _maxValue;
    }
    
    _currentValue = currentValue;
    
    [_textField setText:[NSString stringWithFormat:@"%d", (int)_currentValue]];
    
    [self updateButtonStatus];
    
    if (_updateValueBlock) {
        _updateValueBlock(_currentValue);
    }
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    
    [_textField setFont:textFont];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    [_textField setTextColor:textColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [_topLine setBackgroundColor:borderColor];
    [_bottomLine setBackgroundColor:borderColor];
}

- (void)setDisableButton:(BOOL)disableButton
{
    _disableButton = disableButton;
    
    if (_disableButton) {
        [_leftBtn setEnabled:NO];
        [_rightBtn setEnabled:NO];
    }else{
        [self updateButtonStatus];
    }
}

- (void)setCanEdit:(BOOL)canEdit
{
    _canEdit = canEdit;
    
    [_textField setEnabled:_canEdit];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"/n"]) {
        [self resignAllFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger newValue = [textField.text integerValue];
    
    [self setCurrentValue:newValue];
}

#pragma mark - Pubulic Methods
- (void)setLeftButtonImage:(UIImage *)image forState:(UIControlState)state
{
    [_leftBtn setImage:image forState:state];
}

- (void)setRightButtonImage:(UIImage *)image forState:(UIControlState)state
{
    [_rightBtn setImage:image forState:state];
}

- (void)resignAllFirstResponder
{
    [_textField resignFirstResponder];
}

#pragma mark - Private Methods
- (UIImage *)getImagePNGWithName:(NSString *)name;
{
    NSString *fullName = name;
    NSInteger scale = [UIScreen mainScreen].scale;
    if (scale > 1) {
        fullName = [name stringByAppendingString:[NSString stringWithFormat:@"@%dx", (int)scale]];
    }
    
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:fullName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    return image;
}

- (UIColor *)colorWithRGB:(uint32_t)rgbValue {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}

- (void)fixValueZone
{
    //修正maxValue
    if (_maxValue < _minValue) {
        _maxValue = _minValue;
    }
}

- (void)updateButtonStatus
{
    if (_disableButton) {
        return;
    }
    
    [_leftBtn setEnabled:(_currentValue > _minValue)];
    [_rightBtn setEnabled:(_currentValue < _maxValue)];
}

- (void)clickedLeftButton
{
    NSInteger newValue = _currentValue - _stepValue;
    
    [self setCurrentValue:newValue];
}

- (void)clickedRightButton
{
    NSInteger newValue = _currentValue + _stepValue;
    
    [self setCurrentValue:newValue];
}

@end
