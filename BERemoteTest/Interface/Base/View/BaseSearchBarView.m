//
//  BaseSearchBarView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/4/14.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "BaseSearchBarView.h"
#import "BIRTypeItem.h"
#import "BIRBrandItem.h"
#import "BIRModelItem.h"
#import "BIRKeyName.h"

@interface BaseSearchBarView() <UISearchResultsUpdating, UISearchBarDelegate>

@end

@implementation BaseSearchBarView

-(void) configureSearchController {
    // Initialize and perform a minimum configuration to the search controller.
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchBar.placeholder = @"Search here...";
    _searchController.searchBar.delegate = self;
    [_searchController.searchBar sizeToFit];
    //self.definesPresentationContext = YES;
    
    self.myTableView.tableHeaderView = _searchController.searchBar;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    _shouldShowSearchResults = true;
    [self.myTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _shouldShowSearchResults = false;
    [self.myTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (!_shouldShowSearchResults) {
        _shouldShowSearchResults = true;
        [self.myTableView reloadData];
    }
    //[_searchController.searchBar resignFirstResponder];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString* searchString = searchController.searchBar.text;
    if (searchString == nil) {
        return;
    }
    if ([[self.cellArray objectAtIndex:0] count] == 0) {
        return;
    }
    
    // Filter the data array and get only those countries that match the search text.
    //NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchString];
    NSPredicate* predicate;
    id filterObject = [[self.cellArray objectAtIndex:0] objectAtIndex:0];
    if ([[filterObject class] isSubclassOfClass:[BIRModelItem class]]) {
        predicate = [NSPredicate predicateWithFormat:@"self.model contains[c] %@",searchString];
    }else if ([[filterObject class] isSubclassOfClass:[BIRTypeItem class]] ||
              [[filterObject class] isSubclassOfClass:[BIRBrandItem class]]||
              [[filterObject class] isSubclassOfClass:[BIRKeyName class]]) {
        predicate = [NSPredicate predicateWithFormat:@"self.name contains[c] %@",searchString];
    }else {
        predicate = [NSPredicate predicateWithFormat:@"self contains[c] %@",searchString];
    }
    
    self.filteredArray = [[self.cellArray objectAtIndex:0] filteredArrayUsingPredicate:predicate];
    
    // Reload the tableview.
    [self.myTableView reloadData];
}

@end
