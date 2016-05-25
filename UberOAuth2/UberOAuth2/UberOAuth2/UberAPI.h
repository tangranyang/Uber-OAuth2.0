//
//  UberAPI.h
//  UberOAuth2
//
//  Created by  汤冉阳 on 16/5/20.
//  Copyright © 2016年 汤冉阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define ServerId @""
#define ClientId @""
#define ClientSecret @""
#define RedirectUrl @"https://www.baidu.com"
#define  BaseURLs  @"https://api.uber.com.cn"
#define kUberAccess_token [NSString stringWithFormat:@"%@",@"Uber_access_token"]



typedef void (^ RequestResult)(id jsonDict, NSURLResponse *response, NSError *error);
typedef void (^CompletionHandler) (NSArray *resultsArray, NSURLResponse *response, NSError *error);

@interface UberAPI : NSObject

/**
 *  获取用户的授权AccessToken信息
 *
 *  @param code          授权code
 *  @param requestResult 返回AccessToken字符串对应的操作
 */
+ (void)requestAccessTokenWithAuthorationCode:(NSString *)code result:(RequestResult)requestResult;

/**
 *  获取用户的基本信息
 *  @param requestResult 返回profile模型对应的操作
 */
+ (void)requestUserProfileWithResult:(RequestResult)requestResult;
/**
 *  获取用户订车的历史记录
 *
 *  @param completion 返回历史记录模型数组（UberActivity）对应的操作
 */
+ (void) getUserActivityWithCompletionHandler:(CompletionHandler)completion;

/**
 *  获取用户周边的车辆信息
 *
 *  @param location   用户的位置
 *  @param completion 返回产品模型数组（UberProduct）对应的操作
 */
+ (void) getProductsForLocation:(CLLocation *)location withCompletionHandler:(CompletionHandler)completion;

/**
 *  返回价格预算信息
 *
 *  @param startLocation 起始位置
 *  @param endLocation   结束位置
 *  @param completion    周边所有车辆的预算信息数组（UberPrice）对应的操作
 */
+ (void) getPriceForTripWithStartLocation:(CLLocation *)startLocation endLocation:(CLLocation *)endLocation withCompletionHandler:(CompletionHandler)completion;

/**
 *  周边车辆到达当前位置预计用时信息
 *
 *  @param location   当前位置
 *  @param completion 车辆用时信息数组操作（UberTime）
 */
+ (void) getTimeForProductArrivalWithLocation:(CLLocation *)location withCompletionHandler:(CompletionHandler)completion;


/**
 *  发送用户优惠券编码，使用优惠券  地址 PATCH /v1/me
 *
 *  @param code 优惠券code
 */
+ (void) sendUserPromotionToApply:(NSString *)code Result:(RequestResult)requestResult;



@end
