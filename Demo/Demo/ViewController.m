//
//  ViewController.m
//  Demo
//
//  Created by kfzx-linz on 16/6/14.
//  Copyright © 2016年 ICBC. All rights reserved.
//

#import "ViewController.h"
#import "ZinkLocation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)actionLocation:(id)sender {
    [ZinkLocation zinkGetCurrentCoordinate:^(double latitude, double longitude, NSError *error) {
        NSLog(@"%f, %f", latitude, longitude);
    }];
}

- (IBAction)actionGetInfoByCoordinate:(id)sender {
    [ZinkLocation zinkReverseGeocodeByLatitude:30.290699
                                     longitude:120.110017
                                       success:^(CLPlacemark *placeMark) {
                                           NSLog(@"%@", placeMark.name);
                                       } fail:^(NSError *error) {
                                           
                                       }];
}

- (IBAction)actionGetCoordinateByInfo:(id)sender {
    [ZinkLocation zinkGeocodeByAddress:@"杭州市西湖区"
                               success:^(double latitude, double longitude) {
                                   NSLog(@"%f, %f", latitude, longitude);
                               } fail:^(NSError *error) {
                                   
                               }];
}

@end
