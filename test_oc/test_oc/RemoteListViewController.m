//
//  RemoteListViewController.m
//  test_oc
//
//  Created by mingo on 2016/5/25.
//  Copyright © 2016年 bomeans. All rights reserved.
//

#import "RemoteListViewController.h"
#import "RemoteListViewCell.h"
#import "MainController.h"
#import "RemoteModelViewController.h"

#import "IR/BomeansIRKit.h"
#import "IR/BIRModelItem.h"

@interface RemoteListViewController (){
    
    MainController *mainC;
    
}

@end

@implementation RemoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainC = [MainController new];
    
    //取類型資料清單
    self.remoteList = self.getMainCRemoteList;
}



//取某類型&廠牌下的遙控器清單
-(NSArray*)getMainCRemoteList
{
 
    //NSArray *remoteList = [mainC getRemoteList:@"1" andBrand:@"13" getNew:false];
    
    return  [mainC getRemoteList:self.typeID andBrand:self.brandID getNew:false];
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
    return (unsigned long)[self.remoteList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemoteListCell" forIndexPath:indexPath];
    
    RemoteListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemoteListCell"];

    BIRModelItem *remoteData = self.remoteList[indexPath.row];
    
    cell.remoteTitleLabel.text = remoteData.model;
    
    
    
    // Configure the cell...
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"remoteDataSegue"]){
        
        RemoteModelViewController *controller = (RemoteModelViewController *)segue.destinationViewController;
        
        //取出點了第幾個cell
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        
        
        BIRModelItem *remoteData = self.remoteList[selectedIndex];
        
        controller.typeID = self.typeID;
        controller.brandID = self.brandID;
        controller.remoteID = remoteData.model;
        
        //controller.typeRow = selectedIndex;
        
    }
    
}

@end
