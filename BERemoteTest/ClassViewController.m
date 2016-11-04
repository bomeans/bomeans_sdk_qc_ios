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
    NSMutableArray* _classTitleArray;
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
    
    NSMutableArray *remoteArray = [[NSMutableArray alloc] init];
    [remoteArray addObject:@"BIRTVPicker"];
    [remoteArray addObject:@"BIRRemote"];

    NSMutableArray *otherArray = [[NSMutableArray alloc] init];
    [otherArray addObject:@"BIRVoiceSearchResultItem"];
    
    NSMutableArray *personalArray = [[NSMutableArray alloc] init];
    [personalArray addObject:@"TestAC"];
    
    NSMutableArray *constArray = [[NSMutableArray alloc] init];
    [constArray addObject:@"BomeansIRKit"];
    [constArray addObject:@"BIRIRBlaster"];
    [constArray addObject:@"BomeansConst"];
    [constArray addObject:@"BomeansDelegate"];
    [constArray addObject:@"BIRRemoteUID"];
    [constArray addObject:@"BIRIpAndMac"];
    [constArray addObject:@"BIRGUIFeature"];
    [constArray addObject:@"BIRKeyOption"];


    _classArray = [[NSMutableArray alloc] initWithObjects:listArray, remoteArray, otherArray, personalArray, constArray, nil];
    _classTitleArray = [NSMutableArray arrayWithObjects:@"清單類", @"創建遙控器", @"其他", @"自建功能測試", @"常數類", nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_classArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_classArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //製作可重複利用的表格欄位Cell
    static NSString *cellIdentifier = @"classCell";
    static NSString *cellIdentifierForConst = @"classCellConst";
    
    UITableViewCell *cell;
    if (indexPath.section == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForConst];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    if (!cell) {
        if (indexPath.section == 4) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierForConst];
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
    
    NSString* className = [[_classArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@", indexPath.row+1,className];
    cell.detailTextLabel.text = @"";
    
    return cell;
}

//設定分類開頭標題
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_classTitleArray objectAtIndex:section];
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
    //UIStoryboard *storybord = self.storyboard;
    NSString* viewName = @"ListViewController";
    
    if (indexPath.section == 0) {
        ListViewController *view = [[ListViewController alloc] initWithNibName:viewName bundle:nil];
        view.className = [[_classArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        view.typeID = _currentType;
        view.brandID = _currentBrand;
        view.modelID = _currentmodel;
         
        [self.navigationController pushViewController:view animated:YES];
        view.sendBack = ^(NSString *selectdId,NSString *selectdName){
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
        ListViewController *view = [[ListViewController alloc] initWithNibName:viewName bundle:nil];
        view.className = [[_classArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:view animated:YES];
    }else if (indexPath.section == 3){
        switch (indexPath.row) {
            case 0:
            {
                //ListViewController *View = [storybord instantiateViewControllerWithIdentifier:@"listView"];
                ListViewController *view = [[ListViewController alloc] initWithNibName:viewName bundle:nil];
                view.typeID = @"2";
                view.className = [[_classArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:view animated:YES];
            }
                break;
            default:
                break;
        }
    }

}


@end
