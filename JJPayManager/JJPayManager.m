//
//  JJPayManager.m
//  JJPayManagerDemo
//
//  Created by 房俊杰 on 2017/8/24.
//  Copyright © 2017年 上海涵予信息科技有限公司. All rights reserved.
//

#import "JJPayManager.h"

@interface JJPayManager () <WXApiDelegate>
/** 代理 */
@property (nonatomic,weak) __weak id<JJPayManagerDelegate>delegate;
/** 支付宝成功回调 */
@property (nonatomic,strong) JJPayManagerAlipayResult alipaySuccessBlock;
/** 支付宝失败回调 */
@property (nonatomic,strong) JJPayManagerAlipayResult alipayFailureBlock;
/** 微信成功回调 */
@property (nonatomic,strong) JJPayManagerWechatPayResult wechatPaySuccessBlock;
/** 微信失败回调 */
@property (nonatomic,strong) JJPayManagerWechatPayResult wechatPayFailureBlock;
/** 银联成功回调 */
@property (nonatomic,strong) JJPayManagerUpPayResult upPaySuccessBlock;
/** 银联失败回调 */
@property (nonatomic,strong) JJPayManagerUpPayResult upPayFailureBlock;


@end

@implementation JJPayManager


+ (instancetype)sharedManager {
    static JJPayManager *_payManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _payManager = [[self alloc] init];
    });
    return _payManager;
}
#pragma mark - 注册微信
/**
 注册微信
 
 @param appKey appKey
 @return 返回bool
 */
- (BOOL)registerApp:(NSString *)appKey {
    return [WXApi registerApp:appKey];
}
#pragma mark - 支付宝支付
/**
 支付宝支付（网页回调）支付的时候用到
 
 @param payOrder 签名
 @param success 成功回调
 @param failure 失败回调
 */
- (void)alipayWithOrder:(NSString *)payOrder
                success:(JJPayManagerAlipayResult)success
                failure:(JJPayManagerAlipayResult)failure {
    
    self.alipaySuccessBlock = success;
    self.alipayFailureBlock = failure;
    
    NSString *scheme = [NSString stringWithFormat:@"%@Alipay",[[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"]];
    [[AlipaySDK defaultService] payOrder:payOrder fromScheme:scheme callback:^(NSDictionary *resultDic) {
        
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            !success ? : success(resultDic);
        } else {
            !failure ? : failure(resultDic);
        }
    }];
}
/**
 支付宝支付（APP回调）AppDelegate用到
 
 @param paymentResult 支付回调URL
 */
- (void)alipayProcessOrderWithPaymentResult:(NSURL *)paymentResult {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:paymentResult standbyCallback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            !self.alipaySuccessBlock ? : self.alipaySuccessBlock(resultDic);
        } else {
            !self.alipayFailureBlock ? : self.alipayFailureBlock(resultDic);
        }
    }];
}
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
                    failure:(JJPayManagerWechatPayResult)failure {
    self.wechatPaySuccessBlock = success;
    self.wechatPayFailureBlock = failure;
    
    PayReq *req = [[PayReq alloc] init];
    req.openID = appKey;
    req.partnerId = partnerID;
    req.prepayId = prepayID;
    req.nonceStr = nonceStr;
    req.timeStamp = timeStamp;
    req.package = @"Sign=WXPay";
    req.sign = sign;
    [WXApi sendReq:req];
}
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
               failure:(JJPayManagerUpPayResult)failure {
    self.upPaySuccessBlock = success;
    self.upPayFailureBlock = failure;
    
    NSString *scheme = [NSString stringWithFormat:@"%@UpPay",[[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"]];
    [[UPPaymentControl defaultControl] startPay:payOrder fromScheme:scheme mode:mode == JJPayManagerModeDistribution ? @"00" : @"01" viewController:viewController];
}
/**
 银联支付（APP回调）AppDelegate用到
 
 @param paymentResult 支付回调URL
 */
- (void)upPayProcessOrderWithPaymentResult:(NSURL *)paymentResult {
    [[UPPaymentControl defaultControl] handlePaymentResult:paymentResult completeBlock:^(NSString *code, NSDictionary *data) {
       
        if ([code isEqualToString:@"success"]) {
            !self.upPaySuccessBlock ? : self.upPaySuccessBlock(code,data);
        } else if ([code isEqualToString:@"cancel"]) {
            !self.upPayFailureBlock ? : self.upPayFailureBlock(code,data);
        } else if ([code isEqualToString:@"fail"]) {
            !self.upPayFailureBlock ? : self.upPayFailureBlock(code,data);
        } else {
            !self.upPayFailureBlock ? : self.upPayFailureBlock(code,data);
        }
    }];
}
#pragma mark - 处理AppDelegate中的回调
/**
 处理AppDelegate中的回调
 
 @param url url
 @param delegate 代理
 @return 是否
 */
- (BOOL)handleOpen:(NSURL *)url
          delegate:(id<JJPayManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    if ([url.host isEqualToString:@"safepay"]) {
        //支付宝处理
        [self alipayProcessOrderWithPaymentResult:url];
        return YES;
    } else if ([url.host isEqualToString:@"pay"]) {
        //微信处理
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([url.host isEqualToString:@"uppayresult"]) {
        //银联支付处理
        [self upPayProcessOrderWithPaymentResult:url];
        return YES;
    } else {
        //第三方跳转处理
        return YES;
    }
}
#pragma mark - 微信支付代理WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        if (response.errCode == 0) {
            !self.wechatPaySuccessBlock ? : self.wechatPaySuccessBlock(response);
        } else {
            !self.wechatPayFailureBlock ? : self.wechatPayFailureBlock(response);
        }
    } else {
        !self.wechatPayFailureBlock ? : self.wechatPayFailureBlock(nil);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onResp:)]) {
        [self.delegate onResp:resp];
    }
}

@end












































