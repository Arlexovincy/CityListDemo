//
//  HandleCityData.m
//  GaoDeMap
//
//  Created by cty on 14-2-20.
//  Copyright (c) 2014年 cty. All rights reserved.
//

#import "HandleCityData.h"
#import "City.h"
#import "JSONKit.h"
#import "ArcBulidingConfig.h"
//按字母排序方法
NSInteger nickNameSort(id user1, id user2, void *context)
{
    City *u1,*u2;
    //类型转换
    u1 = (City*)user1;
    u2 = (City*)user2;
    return  [u1.letter localizedCompare:u2.letter];
}

@implementation HandleCityData

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
        storeCities = [[NSMutableArray alloc] init];
        _sectionHeadsKeys = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)dealloc
{
    SAFE_ARC_RELEASE(storeCities);
    SAFE_ARC_RELEASE(_sectionHeadsKeys);
    SAFE_ARC_SUPER_DEALLOC();
}

-(NSArray *)cityDataDidHandled
{
    [storeCities removeAllObjects];
    
    //读取本地文件
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"BaiduMap_cityCenter" ofType:@"txt"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *textFile  = [NSString stringWithContentsOfFile:filePath encoding:enc error:nil];
    //将读取的文件转化为字典
    NSDictionary * result = [textFile objectFromJSONString];
    
    NSArray * keys = [result allKeys];
    //按key取出字典的数据
    for (NSString * key in keys) {
        NSArray * firstArr = [result objectForKey:key];
        //各省份的字典封装
        if ([key isEqualToString:@"provinces"]) {
            for (NSDictionary * city in firstArr) {
                NSArray * cities = [city objectForKey:@"cities"];
                for (NSDictionary * cityDetail in cities) {
                    City * newCity = [[City alloc] init];
                    NSString * degree = [cityDetail objectForKey:@"g"];
                    NSArray * degereArr = [degree componentsSeparatedByString:@","];
                    newCity.longtitde = [[degereArr objectAtIndex:0] doubleValue];
                    newCity.latitude = [[degereArr objectAtIndex:1] doubleValue];
                    newCity.cityNAme = [cityDetail objectForKey:@"n"];
                    //汉字转拼音，比较排序时候用
                    NSMutableString *ms = [[NSMutableString alloc] initWithString:newCity.cityNAme];
                    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                    }
                    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                        newCity.letter = ms;
                    }
                    //都放在存储数组里
                    [storeCities addObject:newCity];
                    
                    SAFE_ARC_RELEASE(ms);
                    SAFE_ARC_RELEASE(newCity);
                }
                
            }
        }else{
                for (NSDictionary * cityDetail in firstArr) {
                    City * newCity = [[City alloc] init];
                    NSString * degree = [cityDetail objectForKey:@"g"];
                    NSArray * degereArr = [degree componentsSeparatedByString:@","];
                    newCity.longtitde = [[degereArr objectAtIndex:0] doubleValue];
                    newCity.latitude = [[degereArr objectAtIndex:1] doubleValue];
                    newCity.cityNAme = [cityDetail objectForKey:@"n"];
                    NSMutableString *ms = [[NSMutableString alloc] initWithString:newCity.cityNAme];
                    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                    }
                    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                        newCity.letter = ms;
                    }
                    [storeCities addObject:newCity];
                    
                    SAFE_ARC_RELEASE(ms);
                    SAFE_ARC_RELEASE(newCity);
                }
            }
    }
//    //排序后的数组初始化
//    NSArray * newArr = [[NSArray alloc] init];
    //排序
    NSArray *newArr = [storeCities sortedArrayUsingFunction:nickNameSort context:NULL];
    //分组数组初始化
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    //开头字母初始化
    [_sectionHeadsKeys removeAllObjects];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    for(int index = 0; index < [newArr count]; index++)
    {
        City *chineseStr = (City *)[newArr objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.letter];
        //取首字母
        NSString *sr= [strchar substringToIndex:1];
        //bNSLog(@"%@",sr);        //sr containing here the first character of each string
        //检查数组内是否有该首字母，没有就创建
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            //不存在就添加进去
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        //有就把数据添加进去
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[newArr objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                
                if (TempArrForGrouping) {
                    
                    SAFE_ARC_RELEASE(TempArrForGrouping);
                }
                
                checkValueAtIndex = YES;
            }
        }
    }
    NSArray * array = [NSArray arrayWithObjects:_sectionHeadsKeys,arrayForArrays,storeCities, nil];
    return array;
}
@end
