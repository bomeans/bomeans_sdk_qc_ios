//
//  BrandListViewController.m
//  test_oc
//
//  Created by mingo on 2016/5/24.
//  Copyright © 2016年 bomeans. All rights reserved.
//

#import "BrandListViewController.h"
#import "BrandListViewCell.h"
#import "MainController.h"
#import "RemoteListViewController.h"

#import "IR/BomeansIRKit.h"
#import "IR/BIRBrandItem.h"

@interface BrandListViewController (){

    MainController *mainC;

}

@end

@implementation BrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Register use xib
    //[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BrandListViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BrandListViewCell class])];
    
    
    mainC = [MainController new];
    
    //取廠牌資料清單
    self.brandList = self.getMainCBrandList;
}


//取某類型下廠牌清單
-(NSArray*)getMainCBrandList
{
    //取出某類型下所有廠牌
    //NSArray *brandList = [mainC getBrandList:self.typeID];
    
    //取出某類型下十大廠牌
    NSArray *brandList = [mainC getTop10BrandList:self.typeID];
    
    return brandList;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (unsigned long)[self.brandList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BrandListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandListCell"];
    
    //使用 .xib 方式
    //BrandListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BrandListViewCell class]) forIndexPath:indexPath];
    
    BIRBrandItem *brandData = self.brandList[indexPath.row];
    
    cell.brandTitleLabel.text = brandData.name;
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"brandDataSegue"]){
        
        RemoteListViewController *controller = (RemoteListViewController *)segue.destinationViewController;
        
        //取出點了第幾個cell
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        
        
        BIRBrandItem *brandData = self.brandList[selectedIndex];
        
        controller.typeID = self.typeID;
        controller.brandID = brandData.brandId;
        
        //controller.typeRow = selectedIndex;
        
    }
    
}



@end
