//
//  YNTextInput.m
//  YNTextInput
//
//  Created by Tommy on 14/9/22.
//  Copyright (c) 2014年 xu_yunan@163.com. All rights reserved.
//

#import "YNTextInput.h"

#define RUNTIME_ADD_PROPERTY(propertyName)  \
- (id)valueForUndefinedKey:(NSString *)key \
{  \
    if ([key isEqualToString:propertyName]) {  \
        return objc_getAssociatedObject(self, key.UTF8String);  \
    }  \
    return nil;  \
}\
- (void)setValue:(id)value forUndefinedKey:(NSString *)key  \
{  \
    if ([key isEqualToString:propertyName]) {  \
        objc_setAssociatedObject(self, key.UTF8String, value, OBJC_ASSOCIATION_RETAIN);  \
    }  \
}

#define IMPLEMENT_PROPERTY(className)  \
@implementation className (Limit) RUNTIME_ADD_PROPERTY(PROPERTY_NAME) @end

IMPLEMENT_PROPERTY(UITextField)
IMPLEMENT_PROPERTY(UITextView)

@implementation YNTextInput

+ (void)load {
    [super load];
    [YNTextInput sharedInstance];
}

+ (YNTextInput *)sharedInstance
{
    static YNTextInput *sharedInstace;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstace = [[YNTextInput alloc] init];
        sharedInstace.enableMax = YES;
    });
    return sharedInstace;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldViewDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewDidChange:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object: nil];
    }
    return self;
}


- (void)textFieldViewDidChange:(NSNotification*)notification
{
    UITextField *textField = (UITextField *)notification.object;
    NSNumber *number = [textField valueForKey:PROPERTY_NAME];
    
    if (!self.enableMax || !number) return;
    
    NSInteger count = [number intValue];
    
    NSString *toBeString = textField.text;
    
    // 键盘输入模式
    NSString *lang = nil;
#ifdef __IPHONE_7_0
        lang = [[textField textInputMode] primaryLanguage];
#else
        lang = [[UITextInputMode currentInputMode] primaryLanguage];
#endif

    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        // UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!selectedRange) {
            
            int length = [YNTextInput calculateTextNumber:toBeString];
            
            if (length > count) {
                textField.text = [toBeString substringToIndex:[YNTextInput calculateSubstringIndex:toBeString
                                                                                             count:count]];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else {
        int length = [YNTextInput calculateTextNumber:toBeString];
        if (length > count) {
            textField.text = [toBeString substringToIndex:[YNTextInput calculateSubstringIndex:toBeString
                                                                                         count:count]];
        }
    }
}


- (void)textViewDidChange:(NSNotification *)notification
{
    UITextView *textView = (UITextView *)notification.object;
    NSNumber *number = [textView valueForKey:PROPERTY_NAME];
    
    if (!self.enableMax || !number) return;
    
    NSInteger count = [number intValue];
    
    NSString *toBeString = textView.text;
    
    // 键盘输入模式
    NSString *lang = nil;
#ifdef __IPHONE_7_0
    lang = [[textView textInputMode] primaryLanguage];
#else
    lang = [[UITextInputMode currentInputMode] primaryLanguage];
#endif
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            int length = [YNTextInput calculateTextNumber:toBeString];
            
            if (length > count) {
                textView.text = [toBeString substringToIndex:[YNTextInput calculateSubstringIndex:toBeString
                                                                                              count:count]];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else {
        int length = [YNTextInput calculateTextNumber:toBeString];
        if (length > count) {
            textView.text = [toBeString substringToIndex:[YNTextInput calculateSubstringIndex:toBeString
                                                                                          count:count]];
        }
    }
}

// 计算有多少字符，汉字算两个字符
+ (int)calculateTextNumber:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++) {
        
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            number += 2;
        } else {
            number += 1;
        }
    }
    return ceil(number);
}

+ (int)calculateSubstringIndex:(NSString *)text count:(NSUInteger)count
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++) {
        
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            number += 2;
        } else {
            number += 1;
        }
        if (number > count) {
            return index;
        }
    }
    return 0;
}

@end
