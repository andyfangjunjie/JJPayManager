//
//  ViewController.m
//  JJPayManagerDemo
//
//  Created by 房俊杰 on 2017/8/24.
//  Copyright © 2017年 房俊杰. All rights reserved.
//

#import "ViewController.h"

#import "JJPayManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

/**
 微信支付
 */
- (IBAction)wechatPayButtonClick {
    
    [[JJPayManager sharedManager] wechatPayWithAppKey:@""
                                            partnerID:@""
                                             prepayID:@""
                                             nonceStr:@""
                                            timeStamp:0
                                                 sign:@""
                                              success:^(PayResp *resp) {
        
    } failure:^(PayResp *resp) {
        
    }];
    
}

/**
 支付宝支付
 */
- (IBAction)alipayButtonClick {
    
    [[JJPayManager sharedManager] alipayOrder:@"" success:^(NSDictionary *resultStatus) {
        
    } failure:^(NSDictionary *resultStatus) {
        
    }];
}

@end


























