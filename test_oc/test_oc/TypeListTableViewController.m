//
//  TypeListTableViewController.m
//  test_oc
//
//  Created by mingo on 2016/5/24.
//  Copyright © 2016年 bomeans. All rights reserved.
//

#import "TypeListTableViewController.h"
#import "TypeListTableViewCell.h"
#import "MainController.h"
#import "BrandListViewController.h"

#import "IR/BomeansIRKit.h"
#import "IR/BIRTypeItem.h"

@interface TypeListTableViewController ()
{
    
    MainController *mainC;
    
}

@end

@implementation TypeListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainC = [MainController new];
    
    //取類型資料清單
    self.typeList = self.getMainCTypeList;
    //NSLog(@"count = %lu", (unsigned long)[types count]);
    
}


-(NSArray*)getMainCTypeList
{
    NSArray *typeList = [mainC getTypeList];

    return typeList;
}


-(void)setMainCTypeList
{
    self.typeList = [mainC getTypeList];
}




#pragma mark - Table view data source

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return (unsigned long)[self.typeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TypeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeListCell"];
    
    BIRTypeItem *typeData = self.typeList[indexPath.row];
    
    cell.titleLabel.text = typeData.name;

    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"typeDataSegue"]){
        
        BrandListViewController *controller = (BrandListViewController *)segue.destinationViewController;
        
        //取出點了第幾個cell
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];

        
        BIRTypeItem *typeData = self.typeList[selectedIndex];
        //NSLog(@"%@",typeData.name);
        controller.typeID = typeData.typeId;
        
        //controller.typeRow = selectedIndex;
        
    }
    
}




@end
