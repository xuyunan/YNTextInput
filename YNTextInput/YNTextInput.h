//
//  YNTextInput.h
//  YNTextInput
//
//  Created by Tommy on 14/9/22.
//  Copyright (c) 2014年 xu_yunan@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define PROPERTY_NAME @"maxCount"

#define DECLARE_PROPERTY(className) \
@interface className (Limit) @end

DECLARE_PROPERTY(UITextField)
DECLARE_PROPERTY(UITextView)

@interface YNTextInput : NSObject

@property(nonatomic, assign) BOOL enableMax;

+ (YNTextInput *)sharedInstance;

@end
