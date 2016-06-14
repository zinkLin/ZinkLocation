//
//  YFZCLocation.m
//  ICBCI
//
//  Created by kfzx-linz on 16/2/24.
//  Copyright © 2016年 ICBC. All rights reserved.
//

#import "ZinkLocation.h"
#import <MapKit/MapKit.h>
#import "ZinkAlertActionSheet.h"

@interface ZinkLocation()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;

@property (copy, nonatomic) void(^coordinateBlock)(double latitude, double longitude, NSError *error);
@end

@implementation ZinkLocation

#pragma mark public
/**
 *  获取之前定位的经纬度
 */
+ (double)zinkLatitude {
    return [ZinkLocation shareInstance].latitude;
}
+ (double)zinkLongitude {
    return [ZinkLocation shareInstance].longitude;
}

/**
 *  获取最新的经纬度
 */
+ (void)zinkGetCurrentCoordinate:(void(^)(double latitude, double longitude, NSError *error))coordinateBlock {
    ZinkLocation *location = [ZinkLocation shareInstance];
    location.coordinateBlock = coordinateBlock;
    [location update];
}

/**
 *  根据经纬度获取地理位置信息
 */
+ (void)zinkReverseGeocodeByLatitude:(double)latitude
                           longitude:(double)longitude
                             success:(void(^)(CLPlacemark *placeMark))successBlock
                                fail:(void(^)(NSError *error))failBlock {
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [[ZinkLocation shareInstance].geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error||placemarks.count==0) {
            if (failBlock) {
                failBlock(error);
            }
        } else {
            CLPlacemark *firstPlacemark=[placemarks firstObject];
            if (successBlock) {
                successBlock(firstPlacemark);
            }
        }
    }];
}

/**
 *  根据地址获取经纬度
 */
+ (void)zinkGeocodeByAddress:(NSString *)address
                     success:(void(^)(double latitude, double longitude))successBlock
                        fail:(void(^)(NSError *error))failBlock {
    [[ZinkLocation shareInstance].geocoder geocodeAddressString:address
                                              completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                                                  if (error||placemarks.count==0) {
                                                      if (failBlock) {
                                                          failBlock(error);
                                                      }
                                                  } else {
                                                      CLPlacemark *firstPlacemark=[placemarks firstObject];
                                                      if (successBlock) {
                                                          successBlock(firstPlacemark.location.coordinate.latitude,
                                                                       firstPlacemark.location.coordinate.longitude);
                                                      }
                                                  }
                                              }];
}


#pragma mark private
+ (ZinkLocation *)shareInstance {
    static dispatch_once_t predicate;
    static ZinkLocation *location;
    
    dispatch_once(&predicate, ^{
        location = [ZinkLocation new];
        location.geocoder = [[CLGeocoder alloc] init];
    });
    
    return location;
}

- (void)update {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    // 设置定位精度，十米，百米，最好
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    locationManager.delegate = self;

    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    // 开始时时定位
    [locationManager startUpdatingLocation];
    self.locationManager = locationManager;
}

/**
 *  定位失败时，请求打开定位权限
 */
- (void)requestForAuthority {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    __weak typeof(self) weakSelf = self;
    [ZinkAlertActionSheet zinkAlertWithTitle:@"定位失败"
                                     message:@"是否前往系统设置开启定位权限"
                                cancelButton:@"取消"
                                otherButtons:@[@"确定"]
                                    callBack:^(NSInteger index) {
                                        if (index == 0) {
                                            if (self.coordinateBlock) {
                                                weakSelf.coordinateBlock(0,0,error);
                                                weakSelf.coordinateBlock = nil;
                                            }
                                        } else {
                                            [weakSelf requestForAuthority];
                                        }
                                    }];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = locations[0];
    [manager stopUpdatingLocation];
    if (self.coordinateBlock) {
        self.latitude = newLocation.coordinate.latitude;
        self.longitude = newLocation.coordinate.longitude;
        self.coordinateBlock(newLocation.coordinate.latitude, newLocation.coordinate.longitude, nil);
        self.coordinateBlock = nil;
    }
}

@end
