//
//  ClassViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/8/25.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "ClassViewController.h"
#import "ListViewController.h"

@interface ClassViewController ()
{
    NSMutableArray* _classArray;
    NSString* _currentType;
    NSString* _currentBrand;
    NSString* _currentmodel;
}
@end

@implementation ClassViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSMutableArray *listArray = [[NSMutableArray alloc] init];
    [listArray addObject:@"BIRTypeItem"];
    [listArray addObject:@"BIRBrandItem"];
    [listArray addObject:@"BIRModelItem"];
    [listArray addObject:@"BIRKeyItem"];
    [listArray addObject:@"BIRKeyName"];
    [listArray addObject:@"BomeansWifiToIRDiscovery"];
    
    NSMutableArray *tvArray = [[NSMutableArray alloc] init];
    [tvArray addObject:@"BIRTVPicker"];

    NSMutableArray *otherArray = [[NSMutableArray alloc] init];
    [otherArray addObject:@"BIRGUAFeature"];
    [otherArray addObject:@"BIRKeyOption"];
    [otherArray addObject:@"BIRVoiceSearchResultItem"];
    
    NSMutableArray *noNeedArray = [[NSMutableArray alloc] init];
    [noNeedArray addObject:@"BomeansIRKit"];
    [noNeedArray addObject:@"BIRIRBlaster"];
    [noNeedArray addObject:@"BIRRemote"];
    [noNeedArray addObject:@"BomeansConst"];
    [noNeedArray addObject:@"BomeansDelegate"];
    [noNeedArray addObject:@"BIRIpAndMac"];
    [noNeedArray addObject:@"BIRRemoteUID"];

    _classArray = [[NSMutableArray alloc] initWithObjects:listArray, tvArray, otherArray, noNeedArray, nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_classArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return classList.count;
    return [[_classArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //製作可重複利用的表格欄位Cell
    static NSString *CellIdentifier = @"classCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString* className = [[_classArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@", indexPath.row+1,className];
    cell.detailTextLabel.text = @"";
    
    return cell;
}

//設定分類開頭標題
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"清單類";
            break;
            
        case 1:
            return @"TV";
            break;
            
        case 2:
            return @"其他";
            break;
            
        case 3:
            return @"待測試";
            break;
            
        default:
            return @"";
            break;
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    //header.textLabel.text = Loc(header.textLabel.text);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storybord = self.storyboard;
    
    if (indexPath.section == 0) {
        ListViewController *listView = [storybord instantiateViewControllerWithIdentifier:@"listView"];
        listView.className = [[_classArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        listView.typeID = _currentType;
        listView.brandID = _currentBrand;
        listView.modelID = _currentmodel;

        [self.navigationController pushViewController:listView animated:YES];
        listView.sendBack = ^(NSString *selectdId,NSString *selectdName){
            if (indexPath.row == 0) {
                _currentType = selectdId;
            }else if (indexPath.row == 1){
                _currentBrand = selectdId;
            }else if (indexPath.row == 2){
                _currentmodel = selectdId;
            }
            
            UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = selectdName;
        };
    }else if (indexPath.section == 1){
        ListViewController *listView = [storybord instantiateViewControllerWithIdentifier:@"listView"];
        listView.className = [[_classArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:listView animated:YES];
        
    }

}


@end
