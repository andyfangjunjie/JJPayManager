//
//  JJPayManager.h
//  JJPayManagerDemo
//
//  Created by 房俊杰 on 2017/8/24.
//  Copyright © 2017年 上海涵予信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import <UPPaySDK/UPPaymentControl.h>

/**
 环境

 - JJPayManagerModeDevelopment: 开发环境
 - JJPayManagerModeDistribution: 生产环境
 */
typedef NS_ENUM(NSInteger, JJPayManagerMode) {
    JJPayManagerModeDevelopment,
    JJPayManagerModeDistribution
};

/**
 支付宝回调
 
 @param resultStatus 回调字典
 */
typedef void(^JJPayManagerAlipayResult)(NSDictionary *resultStatus);
/**
 微信支付回调
 
 @param resp 回调对象
 */
typedef void(^JJPayManagerWechatPayResult)(PayResp *resp);
/**
 银联支付回调
 
 @param code 错误代码
 @param data 成功返回数据
 */
typedef void(^JJPayManagerUpPayResult)(NSString *code,NSDictionary *data);

@class JJPayManager;

@protocol JJPayManagerDelegate <NSObject>
/** 微信原生支付回调 */
- (void)onResp:(BaseResp *)resp;

@end

@interface JJPayManager : NSObject

+ (instancetype)sharedManager;
#pragma mark - 注册微信
/**
 注册微信
 
 @param appKey appKey
 @return 返回bool
 */
- (BOOL)registerApp:(NSString *)appKey;
#pragma mark - 处理AppDelegate中的回调
/**
 处理AppDelegate中的回调
 
 @param url url
 @param delegate 代理
 @return 是否
 */
- (BOOL)handleOpen:(NSURL *)url
          delegate:(id<JJPayManagerDelegate>)delegate;

#pragma mark - 支付宝支付
/**
 支付宝支付(配置scheme = 工程名+Alipay)
 
 @param payOrder 签名
 @param success 成功回调
 @param failure 失败回调
 */
- (void)alipayWithOrder:(NSString *)payOrder
                success:(JJPayManagerAlipayResult)success
                failure:(JJPayManagerAlipayResult)failure;

#pragma mark - 微信支付
/**
 微信支付（需要后台签名，前端不支持）
 
 @param appKey 用户微信号和AppID组成的唯一标识，用于校验微信用户
 @param partnerID 商户号
 @param prepayID 预支付订单ID
 @param nonceStr 参与签名的随机字符串
 @param timeStamp 参与签名的时间戳
 @param sign 签名字符串
 */
- (void)wechatPayWithAppKey:(NSString *)appKey
                  partnerID:(NSString *)partnerID
                   prepayID:(NSString *)prepayID
                   nonceStr:(NSString *)nonceStr
                  timeStamp:(UInt32)timeStamp
                       sign:(NSString *)sign
                    success:(JJPayManagerWechatPayResult)success
                    failure:(JJPayManagerWechatPayResult)failure;

#pragma mark - 银联支付
/**
 银联支付(配置scheme = 工程名+Uppay)

 @param payOrder 订单号
 @param mode 模式 默认开发环境
 @param viewController 调用的控制器
 @param success 成功回调
 @param failure 失败回调
 */
- (void)upPayWithOrder:(NSString *)payOrder
                  mode:(JJPayManagerMode)mode
        viewController:(UIViewController *)viewController
               success:(JJPayManagerUpPayResult)success
               failure:(JJPayManagerUpPayResult)failure;

@end



































