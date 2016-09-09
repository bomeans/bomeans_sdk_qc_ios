//
//  ListViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/9/1.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "ListViewController.h"
#import "FGLanguageTool.h"
#import "DataProvider.h"
#import "IR/BIRTypeItem.h"
#import "IR/BIRBrandItem.h"
#import "IR/BIRModelItem.h"
#import "IR/BIRKeyItem.h"
#import "IR/BIRKeyName.h"
#import "IR/BomeansWifiToIRDiscovery.h"
#import "IR/BIRIpAndMac.h"
#import "TVMatchViewController.h"

@interface ListViewController () <BIRWifiToIRDiscoveryDelegate, UISearchResultsUpdating, UISearchBarDelegate>{
    DataProvider* _dataProvider;
    id<BIRRemote> _remoter;
    NSArray* _listArray;
    BomeansWifiToIRDiscovery* _discovery;
    
    NSArray* _filteredArray;
    BOOL _shouldShowSearchResults;
    UISearchController* _searchController;
}
@end

@implementation ListViewController

- (void)dealloc{
    [_discovery cancelNext];
}

- (void)viewDidLoad {
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.className;
    _shouldShowSearchResults = false;
    
    // 初始化model
    _dataProvider = [DataProvider defaultDataProvider];
    _discovery = [[BomeansWifiToIRDiscovery alloc] init];
    [self configureSearchController];
    
    if (self.typeID == nil) {
        self.typeID = @"1";
    }
    if (self.brandID == nil) {
        self.brandID = @"12";
    }
    if (self.modelID == nil) {
        self.modelID = @"LCD100";
    }
    
    if ([self.className isEqualToString:@"BIRTypeItem"]) {
        _listArray = [_dataProvider getTypeList];
    }else if ([self.className isEqualToString:@"BIRBrandItem"]){
        _listArray = [_dataProvider getBrandListWithType:self.typeID];
    }else if ([self.className isEqualToString:@"BIRModelItem"]) {
        _listArray = [_dataProvider getModelListWithType:self.typeID andBrand:self.brandID getNew:YES];
    }else if ([self.className isEqualToString:@"BIRKeyItem"]) {
        _remoter = [_dataProvider createRemoterWithType:self.typeID withBrand:self.brandID andModel:self.modelID];
        _listArray = [_remoter getAllKeys];
    }else if ([self.className isEqualToString:@"BIRKeyName"]){
        _listArray = [_dataProvider getKeyName:self.typeID];
    }else if ([self.className isEqualToString:@"BomeansWifiToIRDiscovery"]){
        [_discovery discoryTryTime:3 andDelegate:self];
        _listArray = _discovery.allWifiToIr.allValues;
        self.tableView.tableHeaderView = nil;
    }
    
    if ([self.className isEqualToString:@"BIRTVPicker"]) {
        _listArray = [_dataProvider getBrandListWithType:@"1"];
    }
    
}

-(void) configureSearchController {
    // Initialize and perform a minimum configuration to the search controller.
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchBar.placeholder = @"Search here...";
    _searchController.searchBar.delegate = self;
    [_searchController.searchBar sizeToFit];
    self.definesPresentationContext = YES;
    
    self.tableView.tableHeaderView = _searchController.searchBar;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    _shouldShowSearchResults = true;
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _shouldShowSearchResults = false;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (!_shouldShowSearchResults) {
        _shouldShowSearchResults = true;
        [self.tableView reloadData];
    }
    //[_searchController.searchBar resignFirstResponder];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString* searchString = searchController.searchBar.text;
    if (searchString == nil) {
        return;
    }
    
    // Filter the data array and get only those countries that match the search text.
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchString];
    _filteredArray = [_listArray filteredArrayUsingPredicate:predicate];
    
    // Reload the tableview.
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_shouldShowSearchResults) {
        return _filteredArray.count;
    }else {
        return _listArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listcell"];
    NSString *cellText;
    
    NSArray* tempArray;
    if (_shouldShowSearchResults) {
        tempArray = [[NSArray alloc]initWithArray:_filteredArray];
    }else {
        tempArray = [[NSArray alloc]initWithArray:_listArray];
    }
    
    if ([self.className isEqualToString:@"BIRTypeItem"]) {
        BIRTypeItem *item = [tempArray objectAtIndex:indexPath.row];
        cellText = [NSString stringWithFormat:@"%@,%@",item.typeId,item.name];
    }else if (([self.className isEqualToString:@"BIRBrandItem"]) ||
              ([self.className isEqualToString:@"BIRTVPicker"])){
        BIRBrandItem *item = [tempArray objectAtIndex:indexPath.row];
        cellText = item.name;
    }else if ([self.className isEqualToString:@"BIRModelItem"]){
        BIRModelItem *item = [tempArray objectAtIndex:indexPath.row];
        cellText = item.model;
    }else if ([self.className isEqualToString:@"BIRKeyItem"]){
        BIRKeyItem *item = [tempArray objectAtIndex:indexPath.row];
        cellText = (NSString*)item;
    }else if ([self.className isEqualToString:@"BIRKeyName"]){
        BIRKeyName *item = [tempArray objectAtIndex:indexPath.row];
        cellText = [NSString stringWithFormat:@"%@, %@",item.keyId,item.name];
    }else if ([self.className isEqualToString:@"BomeansWifiToIRDiscovery"]){
        BIRIpAndMac *item = [tempArray objectAtIndex:indexPath.row];
        cellText = [NSString stringWithFormat:@"%@, %@",[item getIp], [item getMac]];
    }
    
    cell.textLabel.text = cellText;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSString *lableString = cell.textLabel.text;
    NSString *currentSelectID;
    
    NSArray* tempArray;
    if (_shouldShowSearchResults) {
        tempArray = [[NSArray alloc]initWithArray:_filteredArray];
    }else {
        tempArray = [[NSArray alloc]initWithArray:_listArray];
    }
    
    if ([self.className isEqualToString:@"BIRTVPicker"]) {
        TVMatchViewController *view = [[TVMatchViewController alloc] initWithNibName:@"TVMatchViewController" bundle:nil];
        view.brandName = lableString;
        
        BIRBrandItem *item = [tempArray objectAtIndex:indexPath.row];
        view.brandID = item.brandId;

        [self.navigationController pushViewController:view animated:YES];
        
    }else {
        if ([self.className isEqualToString:@"BIRTypeItem"]) {
            BIRTypeItem *item = [tempArray objectAtIndex:indexPath.row];
            currentSelectID = item.typeId;
        }else if ([self.className isEqualToString:@"BIRBrandItem"]){
            BIRBrandItem *item = [tempArray objectAtIndex:indexPath.row];
            currentSelectID = item.brandId;
        }else if ([self.className isEqualToString:@"BIRModelItem"]){
            BIRModelItem *item = [tempArray objectAtIndex:indexPath.row];
            currentSelectID = item.model;
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.sendBack(currentSelectID,lableString);
    }
    
}

#pragma mark - BIRWifiToIRDiscoveryDelegate

-(void)wifiToIR:(id)obj discoryWifiToIr:(BIRIpAndMac*)ipAndMac
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       _listArray = _discovery.allWifiToIr.allValues;
                       [self.tableView reloadData];
                   });
}

-(void)wifiToIR:(id)obj process:(int)step
{
    
}

-(void)wifiToIR:(id)obj endDiscory:(BOOL)result
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       _listArray = _discovery.allWifiToIr.allValues;
                       [self.tableView reloadData];
                   });
}


@end
