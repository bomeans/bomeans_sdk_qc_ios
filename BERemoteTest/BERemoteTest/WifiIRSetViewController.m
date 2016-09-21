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
#import "IRDetailViewController.h"
#import "IRSetViewController.h"

@interface WifiIRSetViewController ()<BIRWifiToIRDiscoveryDelegate> {
    DataProvider* _dataProvider;
    BomeansWifiToIRDiscovery* _discovery;
    NSMutableArray* _contentArray;
    NSMutableArray* _contentTitleArray;
    NSInteger _currentSegmentedIndex;
    NSIndexPath* _currentSelectIrIndexPath;
    BOOL _irConnectFlag;
}
@end

@implementation WifiIRSetViewController

- (void)dealloc{
    [_discovery cancelNext];
}

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
    _discovery = [[BomeansWifiToIRDiscovery alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _currentSegmentedIndex = 0;
    
    NSMutableArray* irStateArray = [[NSMutableArray alloc] initWithCapacity:1];
    //NSMutableArray* wifiIrArray = [[NSMutableArray alloc] initWithArray:[self discoveryWifiToIR]];
    NSMutableArray* wifiIrArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"轉發器", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"轉發器狀態", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Wifi設定", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    [irStateArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Led及定時設定", @"name", @"", @"ip", @"", @"mac", @"", @"coreid", nil]];
    
    _contentArray = [[NSMutableArray alloc] initWithObjects:irStateArray, wifiIrArray, nil];
    _contentTitleArray = [NSMutableArray arrayWithObjects:@"", @"選擇轉發器", nil];
    
    [self checkWifiIrConnect];
    [self choiceServer:nil];
}

//轉發器連接狀態
-(void)checkWifiIrConnect{
    int irState = [_dataProvider getWifiIRState];
    _irConnectFlag = irState==BIROK?true:false;
    NSLog(@"wifi: %i",irState);
    
    NSString* state;
    
    switch (irState) {
        case BIROK:
            state = @"已連線";
            break;
        case BIRNotConnectToNetWork:
            state = @"未連線至網路";
            break;
        case BIRNotFindWifiToIR:
            state = @"找不到轉發器";
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:[[_contentArray objectAtIndex:0] objectAtIndex:1]];
    [dict setValue:state forKey:@"ip"];
    
    [[_contentArray objectAtIndex:0] replaceObjectAtIndex:1 withObject:dict];
    [self.tableView reloadData];
}

-(NSArray*)discoveryWifiToIR{
    NSMutableArray* deviceArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    if(( [_discovery discoryBlockTryTime:5] ) || (_discovery.allWifiToIr.allValues.count > 0))
    {
        //搜尋所有轉發器裝置
        NSArray *devices = _discovery.allWifiToIr.allValues;
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
        }
    }
    else
    {
        NSLog(@"Not find wifiTO ir");
    }
    
    return deviceArray;
}

-(void)choiceServer:(UISegmentedControl*)sender{
    if (sender) {
        _currentSegmentedIndex = sender.selectedSegmentIndex;
    }
    
    NSLog(@"choice server : %ld", _currentSegmentedIndex);
    NSMutableArray* wifiIrArray = [[NSMutableArray alloc] initWithCapacity:1];
    switch (_currentSegmentedIndex) {
        case 0:
        {
            [_dataProvider setIRHW:BIRLocal];
            wifiIrArray = [NSMutableArray arrayWithArray:[self discoveryWifiToIR]];
        }
            break;
        case 1:
        {
            [_dataProvider setIRHW:BIRCloud];
            [wifiIrArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"name1", @"name", @"ip1", @"ip", @"mac1", @"mac", @"coreid1", @"coreid", nil]];
            [wifiIrArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"nam2", @"name", @"ip2", @"ip", @"mac2", @"mac", @"coreid2", @"coreid", nil]];
            //遠端時先改為群體廣播...清空近端時的裝置設定用 可不清
            [_dataProvider.irKit setWifiToIrIP: nil];
        }
            break;
        default:
            break;
    }
    [_contentArray replaceObjectAtIndex:1 withObject:wifiIrArray];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _contentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_contentArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* nibName = @"WifiIRSetViewCell";
    static NSString* cellIdentifer = @"wifiSetCell";
    static NSString* cellIdentiferForSW = @"wifiSetCellSW";
    static NSString* cellIdentiferForState = @"wifiSetCellState";
    static NSString* cellIdentiferForWifiSet = @"wifiSetCellWifiSet";
    
     WifiIRSetViewCell *cell;
     if (indexPath.section == 0) {
         switch (indexPath.row) {
             case 0:
                 cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForSW];
                 break;
             case 1:
                 cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForState];
                 break;
             default:
                 cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForWifiSet];
                 break;
         }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    }
    
     if (!cell) {
         if (indexPath.section == 0) {
             switch (indexPath.row) {
                 case 0:
                 {
                     [tableView registerClass:[WifiIRSetViewCell class] forCellReuseIdentifier:cellIdentiferForSW];
                     cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForSW];
                 }
                     break;
                 case 1:
                 {
                     [tableView registerClass:[WifiIRSetViewCell class] forCellReuseIdentifier:cellIdentiferForState];
                     cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForState];
                     cell = [cell initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentiferForState];
                 }
                     break;
                 default:
                 {
                     [tableView registerClass:[WifiIRSetViewCell class] forCellReuseIdentifier:cellIdentiferForWifiSet];
                     cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForWifiSet];
                 }
                     break;
             }
         }else{
             [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:cellIdentifer];
             cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
         }
     }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_contentTitleArray objectAtIndex:section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                UISegmentedControl* segmented = [[UISegmentedControl alloc] initWithItems:[[NSArray alloc] initWithObjects:@"近端", @"遠端", nil]];
                segmented.selectedSegmentIndex = _currentSegmentedIndex;
                [segmented addTarget:self action:@selector(choiceServer:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = segmented;
            }
                break;
            case 1:
            {
                UIButton* button = [[UIButton alloc] init];
                [button setFrame:CGRectMake(0, 0, 25, 25)];
                [button setBackgroundImage:[UIImage imageNamed:@"Button-Refresh"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(checkWifiIrConnect) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = button;
            }
                break;
            default:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }

    cell.textLabel.text = [NSString stringWithFormat:@"   %@",[[[_contentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"]];
    cell.detailTextLabel.text = [[[_contentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"ip"];
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            WifiSetViewController* view = [[WifiSetViewController alloc] initWithNibName:@"WifiSetViewController" bundle:nil];
            [self.navigationController pushViewController:view animated:YES];
        }
        else if (indexPath.row == 3){
            IRSetViewController* view = [[IRSetViewController alloc] initWithNibName:@"IRSetViewController" bundle:nil];
            [self.navigationController pushViewController:view animated:YES];

        }
    }else{
        _currentSelectIrIndexPath = indexPath;
        WifiIRSetViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString* deviceIP = cell.detailTextLabel.text;
        if (deviceIP) {
            //設定此用此裝置
            [_dataProvider.irKit setWifiToIrIP: deviceIP];
        }
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSIndexPath *oldIndex = [self.tableView indexPathForSelectedRow];
        if (oldIndex == nil) {
            oldIndex = _currentSelectIrIndexPath;
        }
        [self.tableView cellForRowAtIndexPath:oldIndex].textLabel.text = [NSString stringWithFormat:@"   %@", [[[_contentArray objectAtIndex:oldIndex.section] objectAtIndex:oldIndex.row] objectForKey:@"name"]];
        [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text = [NSString stringWithFormat:@"\u2713%@",[[[_contentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"]];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    IRDetailViewController* view = [[IRDetailViewController alloc] initWithNibName:@"IRDetailViewController" bundle:nil];
    view.wifiIrDict = [[_contentArray objectAtIndex:1] objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:view animated:YES];
    
}

#pragma mark - BIRWifiToIRDiscoveryDelegate
-(void)wifiToIR:(id)obj discoryWifiToIr:(BIRIpAndMac*)ipAndMac
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [_contentArray replaceObjectAtIndex:1 withObject:[self discoveryWifiToIR]];
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
                       [_contentArray replaceObjectAtIndex:1 withObject:[self discoveryWifiToIR]];
                       [self.tableView reloadData];
                   });
}

@end
