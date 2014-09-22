//
//  ViewController.m
//  YNTextInput
//
//  Created by Tommy on 14/9/22.
//  Copyright (c) 2014年 xu_yunan@163.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_textField setValue:@6 forKey:@"maxCount"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
