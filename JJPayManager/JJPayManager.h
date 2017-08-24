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

/**
 支付宝回调
 
 @param resultStatus 回调字典
 */
typedef void(^JJPayManagerAlipayResult)(NSDictionary *resultStatus);
/**
 微信支付回调
 
 @param resp 对调对象
 */
typedef void(^JJPayManagerWechatPayResult)(PayResp *resp);

@class JJPayManager;

@protocol JJPayManagerDelegate <NSObject>

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
- (void)alipayOrder:(NSString *)payOrder
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

@end
