//
//  RemoteViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/9/6.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "RemoteViewController.h"
#import "DataProvider.h"
#import "RemoteViewCell.h"

@interface RemoteViewController (){
    DataProvider* _dataProvider;
    id<BIRRemote> _remoter;
    NSMutableArray* _keyArray;
}
@end

@implementation RemoteViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _keyArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataProvider = [DataProvider defaultDataProvider];
    _remoter = [_dataProvider createRemoterWithType:self.typeID withBrand:self.brandID andModel:self.modelID];
    //_remoter = [_dataProvider createRemoterWithType:@"1" withBrand:@"12" andModel:@"PANASONIC_N2QAYB_000846"];
    _keyArray = [NSMutableArray arrayWithArray:[_remoter getAllKeys]];
    
    self.navigationItem.title = self.brandName;
    UIBarButtonItem *naviLeftButton = [[UIBarButtonItem alloc] initWithTitle:@"＜Back" style:UIBarButtonItemStylePlain target:self action:@selector(popToRootViewController:)];
    self.navigationItem.leftBarButtonItem = naviLeftButton;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)popToRootViewController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _keyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"remoteCell";
    RemoteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:@"RemoteViewCell" owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    
    [cell defaultCell:[_keyArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RemoteViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* irkey = cell.textLabel.text;
    //NSLog(@"transmitIR : %@",irkey);
    [_remoter transmitIR:irkey withOption:nil];
}

@end
