//
//  CityListView.m
//  CityListDemo
//
//  Created by Foocaa on 14-3-25.
//  Copyright (c) 2014年 Foocaa. All rights reserved.
//

#import "ArcBulidingConfig.h"
#import "CityListView.h"
#import "City.h"
#import "HandleCityData.h"

@interface CityListView (PirvateMethod)

/**
 *  初始化数据
 */
- (void)initilaztion;

/**
 *  把获取的数据制作成city对象
 */
- (void)makeCityObjData;

/**
 *  更新当前城市
 */
- (void)updateCurCity;

@end

@implementation CityListView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initilaztion];
    }
    return self;
}

-(void)dealloc
{
    SAFE_ARC_RELEASE(m_lettersArray);
    SAFE_ARC_RELEASE(m_fixArray);
    SAFE_ARC_RELEASE(m_tempArray);
    SAFE_ARC_RELEASE(m_chineseCitiesArray);
    SAFE_ARC_RELEASE(m_searchBar);
    SAFE_ARC_RELEASE(m_location);
    SAFE_ARC_RELEASE(m_cityTableView);
    SAFE_ARC_SUPER_DEALLOC();
}

#pragma mark- 把获取的数据制作成city对象
- (void)makeCityObjData
{
    HandleCityData *handle = [[HandleCityData alloc] init];
    NSArray *cityInfoArray = [handle cityDataDidHandled];
    [m_lettersArray addObjectsFromArray:[cityInfoArray objectAtIndex:0]]; //存放所有section字母
    [m_fixArray addObjectsFromArray:[cityInfoArray objectAtIndex:1]];     //存放所有城市信息数组嵌入数组和字母匹配
    [m_chineseCitiesArray addObjectsFromArray:[cityInfoArray objectAtIndex:2]];
}

#pragma mark- 初始化数据
- (void)initilaztion
{
    m_lettersArray = [[NSMutableArray alloc] init];
    m_fixArray = [[NSMutableArray alloc] init];
    m_tempArray = [[NSMutableArray alloc] init];
    m_chineseCitiesArray = [[NSMutableArray alloc] init];
    
    m_curPlaceString = @"正在定位中...";
    
    m_location = [[JLocation alloc] init];
    
    //获得数据
    [self makeCityObjData];
    
    [m_lettersArray insertObject:@"当前定位" atIndex:0];

    
    m_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    m_searchBar.delegate = self;
    m_searchBar.showsCancelButton = YES;
    m_searchBar.placeholder = @"名称";
    [self addSubview:m_searchBar];
    
    m_cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 40) style:UITableViewStylePlain];
    m_cityTableView.delegate = self;
    m_cityTableView.dataSource = self;
    [self addSubview:m_cityTableView];
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = m_cityTableView;
    m_header = header;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        [self updateCurCity];
    };
    
    [self updateCurCity];
}

#pragma mark- 更新当前城市
- (void)updateCurCity
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    
        [m_location startLocationSuccessed:^(NSString *cityString){
            
            m_curPlaceString = cityString;
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
            
                [m_header endRefreshing];
                [m_cityTableView reloadData];
            });
            
        } failed:^(NSError *error){
        
            
        }];
        
    });
}

#pragma mark- TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearch) {
        
        return  m_tempArray.count;
        
    }else{
        
        if (section == 0) {
            
            return 1;
            
        }else{
            
            NSArray * letterArray = [m_fixArray objectAtIndex:section - 1];//对应字母所含城市数组
            return letterArray.count;
            
        }
        
        
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    if (isSearch) {
        
        return 1;
        
    }else{
    
        return m_lettersArray.count;  //多了一个当前定位
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = SAFE_ARC_AUTORELEASE([[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]);
    }
    
    
    City * city;
    if (isSearch) {
        city = [m_tempArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityNAme;
    }else{
        
        if (indexPath.section == 0) {
            
            cell.textLabel.text = m_curPlaceString;
            
        }else{
            
            NSArray * letterArray = [m_fixArray objectAtIndex:indexPath.section - 1];//对应字母所含城市数组
            city = [letterArray objectAtIndex:indexPath.row];
            cell.textLabel.text = city.cityNAme;
        }
       
        
    }
    
    if (indexPath.section == m_curSection && indexPath.row == m_curRow){
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //clear previous
    NSIndexPath *prevIndexPath = [NSIndexPath indexPathForRow:m_curRow inSection:m_curSection];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:prevIndexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    m_curSection = (int)indexPath.section;
    m_curRow = (int)indexPath.row;
    
    //add new check mark
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
   
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (isSearch) {
        
        return nil;
        
    }else{
    
        return [m_lettersArray objectAtIndex:section];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    return m_lettersArray;
}


#pragma mark- UISearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [m_tempArray removeAllObjects];
    if (searchText.length == 0) {
        isSearch = NO;
    }else{
        isSearch = YES;
        for (City * city in m_chineseCitiesArray) {
            NSRange chinese = [city.cityNAme rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  letters = [city.letter rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (chinese.location != NSNotFound) {
                [m_tempArray addObject:city];
            }else if (letters.location != NSNotFound){
                [m_tempArray addObject:city];
            }
        }
    }
    [m_cityTableView reloadData];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
