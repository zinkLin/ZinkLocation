//
//  YFZCLocation.h
//  ICBCI
//
//  Created by kfzx-linz on 16/2/24.
//  Copyright © 2016年 ICBC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 *  定位
 *  iOS8以后 需要在plist中添加以下字段用于获取定位权限：
 *  NSLocationWhenInUseUsageDescription（使用时）
 *  NSLocationAlwaysUsageDescription（一直）
 */
@interface ZinkLocation : NSObject

/**
 *  获取之前定位的经纬度
 */
+ (double)zinkLatitude;
+ (double)zinkLongitude;

/**
 *  获取最新的经纬度
 */
+ (void)zinkGetCurrentCoordinate:(void(^)(double latitude, double longitude, NSError *error))completeBlock;

/**
 *  根据经纬度获取地理位置信息
 */
+ (void)zinkReverseGeocodeByLatitude:(double)latitude
                           longitude:(double)longitude
                             success:(void(^)(CLPlacemark *placeMark))successBlock
                                fail:(void(^)(NSError *error))failBlock;

/**
 *  根据地址获取经纬度
 */
+ (void)zinkGeocodeByAddress:(NSString *)address
                     success:(void(^)(double latitude, double longitude))successBlock
                        fail:(void(^)(NSError *error))failBlock;
@end

