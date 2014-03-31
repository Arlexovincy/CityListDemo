//
//  JLocation.h
//  CityListDemo
//
//  Created by Foocaa on 14-3-25.
//  Copyright (c) 2014年 Foocaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^SuccessedBlock)(NSString *cityString);
typedef void (^FailedBlock)(NSError *error);

@interface JLocation : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *m_locationManager;
    
    SuccessedBlock m_successedBlock;
    FailedBlock m_failedBlock;
}

/**
 *  开启定位
 */
- (void)startLocationSuccessed:(SuccessedBlock)successedBlock failed:(FailedBlock)failedBlock;

/**
 *  停止定位
 */
- (void)stopLocation;

@end
