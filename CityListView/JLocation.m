//
//  JLocation.m
//  CityListDemo
//
//  Created by Foocaa on 14-3-25.
//  Copyright (c) 2014年 Foocaa. All rights reserved.
//

#import "JLocation.h"
#import "ArcBulidingConfig.h"

@interface JLocation (PrivateMethod)

/**
 *  初始化数据
 */
- (void)initilaztion;

@end

@implementation JLocation

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
        [self initilaztion];
        
    }
    return self;
}

- (void)dealloc
{
    SAFE_ARC_RELEASE(m_locationManager);
    SAFE_ARC_SUPER_DEALLOC();
}

#pragma mark- 初始化数据
- (void)initilaztion
{
    m_locationManager = [[CLLocationManager alloc] init];
    m_locationManager.delegate = self;
    m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    m_locationManager.distanceFilter = 10.0f;
}

#pragma mark- 开启定位
- (void)startLocationSuccessed:(SuccessedBlock)successedBlock failed:(FailedBlock)failedBlock
{
    m_successedBlock = successedBlock;
    m_failedBlock = failedBlock;
    [m_locationManager startUpdatingLocation];
}

#pragma mark- 停止定位
- (void)stopLocation
{
    [m_locationManager stopUpdatingLocation];
}

#pragma mark- CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self stopLocation];
    
    CLLocation *newLocation = [locations lastObject];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error){
        
        if (error == nil) {
            
            NSDictionary *cityDictionary = [[placemarks lastObject] addressDictionary];
            
            m_successedBlock([cityDictionary objectForKey:@"City"]);
            
        }else{
        
            NSLog(@"%@",error.description);
            m_failedBlock(error);
        }
        
       
        
    }];
    
    SAFE_ARC_RELEASE(geoCoder);
}
@end
