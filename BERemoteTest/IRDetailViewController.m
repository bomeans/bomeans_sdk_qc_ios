//
//  IRDetailViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/9/10.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "IRDetailViewController.h"
#import "DataProvider.h"

@interface IRDetailViewController (){
    NSMutableArray* _contentArray;
    DataProvider* _dataProvider;
}
@end

@implementation IRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataProvider = [DataProvider initDataProvider];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    NSArray* irSetArray;
    if (self.segmentedIndex == 0) {
        irSetArray = [[NSArray alloc] init];
    }
    else {
        irSetArray = [[NSArray alloc] initWithObjects:@"忘記此轉發器", nil];
    }
    
    NSArray* irDetailArray = [[NSArray alloc] initWithObjects:[self.wifiIrDict objectForKey:@"name"], [self.wifiIrDict objectForKey:@"ip"], [self.wifiIrDict objectForKey:@"mac"], [self.wifiIrDict objectForKey:@"coreid"], nil];
    
    _contentArray = [[NSMutableArray alloc] initWithObjects:irSetArray, irDetailArray, nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _contentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_contentArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"忘記此轉發器";
        cell.detailTextLabel.text = @"";
        cell.textLabel.textColor = self.view.tintColor;//[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1];
    }else{
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Name";
                break;
            case 1:
                cell.textLabel.text = @"IP";
                break;
            case 2:
                cell.textLabel.text = @"MAC";
                break;
            case 3:
                cell.textLabel.text = @"CoreID";
                break;
            default:
                break;
        }
        cell.detailTextLabel.text = [[_contentArray objectAtIndex:1] objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSMutableArray* deviceArray = [[NSMutableArray alloc] initWithArray:[_dataProvider.defaultValue objectForKey:@"deviceArray"]];
        NSString* coreID = [self.wifiIrDict objectForKey:@"coreid"];
        
        for (NSDictionary* dict in deviceArray.copy) {
            NSString* cellName = [dict objectForKey:@"coreid"];
            if ([coreID isEqualToString:cellName]) {
                [deviceArray removeObject:dict];
            }
        }
        
        [_dataProvider.defaultValue setObject:deviceArray forKey:@"deviceArray"];
        [_dataProvider.defaultValue synchronize];
        [self.navigationController popViewControllerAnimated:YES];
        self.sendBack();
    }
    
}



@end
