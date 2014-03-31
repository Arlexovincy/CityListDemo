//
//  CityListView.h
//  CityListDemo
//
//  Created by Foocaa on 14-3-25.
//  Copyright (c) 2014年 Foocaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLocation.h"
#import "MJRefreshHeaderView.h"

@protocol CityListViewDelegate <NSObject>

@optional
/**
 *  选择城市
 *
 *  @param cityString 选择的城市
 */
- (void)selectedCity:(NSString*)cityString;

@end

@interface CityListView : UIView<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UISearchBar *m_searchBar;
    
    UITableView *m_cityTableView;
    MJRefreshHeaderView *m_header;
    
    NSMutableArray *m_lettersArray;
    NSMutableArray *m_fixArray;
    NSMutableArray *m_tempArray;
    NSMutableArray *m_chineseCitiesArray;
    
    NSString *m_curPlaceString;
    
    JLocation *m_location;
    
    int m_curRow;
    int m_curSection;
    
    BOOL isSearch;
}

@property(nonatomic,assign) id<CityListViewDelegate>delegate;

@end
