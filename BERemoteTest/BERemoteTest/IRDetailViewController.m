//
//  IRDetailViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/9/10.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "IRDetailViewController.h"

@interface IRDetailViewController (){
    NSMutableArray* _contentArray;
}
@end

@implementation IRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    NSArray* irSetArray = [[NSArray alloc] initWithObjects:@"忘記此轉發器", nil];
    NSArray* irDetailArray = [[NSArray alloc] initWithObjects:[self.wifiIrDict objectForKey:@"name"], [self.wifiIrDict objectForKey:@"ip"], [self.wifiIrDict objectForKey:@"mac"], [self.wifiIrDict objectForKey:@"coreid"], nil];
    
    _contentArray = [[NSMutableArray alloc] initWithObjects:irSetArray, irDetailArray, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell.textLabel.textColor = [UIColor blueColor];
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/


@end
