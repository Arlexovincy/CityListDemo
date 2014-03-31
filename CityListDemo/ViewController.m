//
//  ViewController.m
//  CityListDemo
//
//  Created by Foocaa on 14-3-25.
//  Copyright (c) 2014年 Foocaa. All rights reserved.
//

#import "ViewController.h"
#import "CityListView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CityListView *cityListView = [[CityListView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
    [self.view addSubview:cityListView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
