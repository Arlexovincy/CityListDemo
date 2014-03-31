//
//  City.h
//  CityListDemo
//
//  Created by Foocaa on 14-3-25.
//  Copyright (c) 2014年 Foocaa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject
{
    
}

@property(nonatomic,copy) NSString * cityNAme;//城市名称
@property(nonatomic,copy) NSString * letter;//城市拼音
@property(nonatomic, assign) float latitude;//纬度
@property(nonatomic, assign) float longtitde;//经度


@end
