//
//  WifiIRSetViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/9/8.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//
#import "WifiIRSetViewController.h"
#import "WifiIRSetViewCell.h"
#import "DataProvider.h"
#import "IR/BomeansWifiToIRDiscovery.h"
#import "IR/BIRIpAndMac.h"
#import "WifiSetViewController.h"

@interface WifiIRSetViewController (){
    DataProvider* _dataProvider;
    NSMutableArray* _contentArray;
    NSInteger _currentSegmentedIndex;
    BOOL _irConnectFlag;
}
@end

@implementation WifiIRSetViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _contentArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataProvider = [DataProvider defaultDataProvider];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _currentSegmentedIndex = 0;
    
    NSMutableArray* irStateArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableArray* wifiIrArray = [[NSMutableArray alloc] initWithArray:[self discoveryWifiToIR]];
    
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"轉發器", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"轉發器狀態", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Wifi設定", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    
    _contentArray = [[NSMutableArray alloc] initWithObjects:irStateArray, wifiIrArray, nil];
    
    [self checkWifiIrConnect];
}

//轉發器連接狀態
-(void)checkWifiIrConnect{
    int irState = [_dataProvider getWifiIRState];
    _irConnectFlag = irState==BIROK?true:false;
    NSLog(@"wifi: %i",irState);
    
    NSString* state = irState==BIROK?@"已連線":@"連線失敗";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:[[_contentArray objectAtIndex:0] objectAtIndex:1]];
    [dict setValue:state forKey:@"ip"];
    
    [[_contentArray objectAtIndex:0] replaceObjectAtIndex:1 withObject:dict];
    [self.tableView reloadData];
}

-(NSArray*)discoveryWifiToIR{
    NSMutableArray* deviceArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    BomeansWifiToIRDiscovery *wifiIR = [[BomeansWifiToIRDiscovery alloc] init];
    
    if( [wifiIR discoryBlockTryTime:5] )
    {
        
        //搜尋所有轉發器裝置
        NSArray *devices = wifiIR.allWifiToIr.allValues;
        //NSLog(@"all : %@",allDevice);
        for(BIRIpAndMac *device in devices)
        {
            NSString *deviceName = [device.extraInfo substringFromIndex:(device.extraInfo.length - 4)];
            NSString *deviceIP = device.ip;
            NSString *deviceMAC = device.mac;
            NSString *deviceCoreID = device.extraInfo;
            
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:deviceName, @"name", deviceIP, @"ip", deviceMAC, @"mac", deviceCoreID, @"coreid", nil];
            
            [deviceArray addObject:dict];
            
            //NSLog(@"IP is %@ , coreID is %@",deviceIP, deviceCoreID);
            
            //使用NSUserDefaults方式儲存 wifiToIR device coreID
            //[_dataProvider.defaultValue setObject:deviceCoreID forKey:@"deviceCoreID"];
            //[_dataProvider.defaultValue setObject:deviceIP forKey:@"deviceIP"];
            
            //NSUserDefaults 同步儲存
            //[_dataProvider.defaultValue synchronize];
            
            //設定此用此裝置
            //[_dataProvider.irKit setWifiToIrIP: deviceIP];
         
        }
    }
    else
    {
        NSLog(@"Not find wifiTO ir");
    }
    
    return deviceArray;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _contentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_contentArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifer = @"wifiSetCell";
    WifiIRSetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:@"WifiIRSetViewCell" owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                UISegmentedControl* segmented = [[UISegmentedControl alloc] initWithItems:[[NSArray alloc] initWithObjects:@"近端", @"遠端", nil]];
                segmented.selectedSegmentIndex = _currentSegmentedIndex;
                cell.accessoryView = segmented;
            }
                break;
            case 1:
            {
                UIButton* button = [[UIButton alloc] init];
                [button setFrame:CGRectMake(0, 0, 25, 25)];
                [button setImage:[UIImage imageNamed:@"Button-Refresh"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(checkWifiIrConnect) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = button;
            }
                break;
            case 2:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"   %@",[[[_contentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"]];
    cell.detailTextLabel.text = [[[_contentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"ip"];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"";
            break;
            
        case 1:
            return @"選擇轉發器";
            break;
            
        default:
            return @"";
            break;
    }
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            WifiSetViewController* view = [[WifiSetViewController alloc] initWithNibName:@"WifiSetViewController" bundle:nil];
            [self.navigationController pushViewController:view animated:YES];
        }
        
    }else{
        WifiIRSetViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString* deviceIP = cell.detailTextLabel.text;
        if (deviceIP) {
            //設定此用此裝置
            [_dataProvider.irKit setWifiToIrIP: deviceIP];
        }
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        NSIndexPath *oldIndex = [self.tableView indexPathForSelectedRow];
        [self.tableView cellForRowAtIndexPath:oldIndex].textLabel.text = [NSString stringWithFormat:@"   %@", [[[_contentArray objectAtIndex:oldIndex.section] objectAtIndex:oldIndex.row] objectForKey:@"name"]];
        [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text = [NSString stringWithFormat:@"\u2713%@",[[[_contentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"]];
    }
    return indexPath;
}

@end
