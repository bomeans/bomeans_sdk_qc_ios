//
//  MyTabBarController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/13.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "MyTabBarController.h"
#import "MainViewController.h"
#import "LibObjectsViewController.h"
#import "DeviceViewController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    UINavigationController *navi1 = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    navi1.tabBarItem = mainViewController.tabBarItem;
    
    LibObjectsViewController *libObjectsViewController = [[LibObjectsViewController alloc] init];
    UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:libObjectsViewController];
    navi2.tabBarItem = libObjectsViewController.tabBarItem;
    
    DeviceViewController *deviceViewController = [[DeviceViewController alloc] init];
    UINavigationController *navi3 = [[UINavigationController alloc] initWithRootViewController:deviceViewController];
    navi3.tabBarItem = deviceViewController.tabBarItem;
    
    self.viewControllers = @[navi1, navi2, navi3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
