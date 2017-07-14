//
//  DeviceView.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2017/3/16.
//  Copyright © 2017年 Hung Ricky. All rights reserved.
//

#import "DeviceView.h"

@interface DeviceView () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)NSIndexPath*    currentSelectIrIndexPath;

@end

@implementation DeviceView

- (UITabBarItem*)tabBarItem
{
    if (nil == _tabBarItem) {
        _tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Device Manager" image:[UIImage imageNamed:@"second"] tag:1];
    }
    return _tabBarItem;
}

- (UISegmentedControl*)segmented
{
    if (!_segmented) {
        _segmented= [[UISegmentedControl alloc] initWithItems:[[NSArray alloc] initWithObjects:@"近端", @"遠端", nil]];
        [_segmented addTarget:self action:@selector(segmentedControlClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmented;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
        [self loadView];
    }
    return self;
}

- (void)loadData
{
    self.currentSegmentedIndex = 0;
    self.currentSelectIrIndexPath = 0;
}

- (void)loadView
{
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UITableView *libTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    libTableView.delegate = self;
    libTableView.dataSource = self;
    [self setMyTableView:libTableView];
    [self addSubview:self.myTableView];
}

- (void)segmentedControlClick:(UISegmentedControl*)sender
{
    self.currentSegmentedIndex = sender.selectedSegmentIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeSegmented:withArray:)]) {
        [self.delegate changeSegmented:sender.selectedSegmentIndex withArray:self.cellArray];
    }
}

- (void)checkStateClick:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellCheckState:)]) {
        [self.delegate cellCheckState:self.cellArray];
    }
}

- (void)choiceNearDevice:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellChoiceNearDevice:withArray:)]) {
        [self.delegate cellChoiceNearDevice:index withArray:self.cellArray];
    }
}

- (void)choiceFarDevice:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellChoiceFarDevice:withArray:)]) {
        [self.delegate cellChoiceFarDevice:index withArray:self.cellArray];
    }
}

- (void)willShowInfo:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellWillShowInfo:withArray:)]) {
        [self.delegate cellWillShowInfo:index withArray:self.cellArray];
    }
}

- (void)wifiSetClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showWifiSet)]) {
        [self.delegate showWifiSet];
    }
}

- (void)deviceProcessClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showDeviceProcess)]) {
        [self.delegate showDeviceProcess];
    }
}

- (void)deviceTimingClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showTimingSet)]) {
        [self.delegate showTimingSet];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.cellArray objectAtIndex:section] count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString* nibName = @"WifiIRSetViewCell";
    static NSString* cellIdentifer = @"wifiSetCell";
    static NSString* cellIdentiferForSW = @"wifiSetCellSW";
    static NSString* cellIdentiferForState = @"wifiSetCellState";
    static NSString* cellIdentiferForWifiSet = @"wifiSetCellWifiSet";
    
    UITableViewCell *cell;
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
                    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentiferForSW];
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForSW];
                }
                    break;
                case 1:
                {
                    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentiferForState];
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForState];
                    cell = [cell initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentiferForState];
                }
                    break;
                default:
                {
                    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentiferForWifiSet];
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForWifiSet];
                }
                    break;
            }
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
//            [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:cellIdentifer];
//            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.text = header.textLabel.text;
    
    header.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                cell.accessoryView = self.segmented;
            }
                break;
            case 1:
            {
                UIButton* button = [[UIButton alloc] init];
                [button setFrame:CGRectMake(0, 0, 25, 25)];
                [button setBackgroundImage:[UIImage imageNamed:@"Button-Refresh"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(checkStateClick:) forControlEvents:UIControlEventTouchUpInside];
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"   %@",[[[self.cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"]];
    cell.detailTextLabel.text = [[[self.cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"ip"];
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            [self wifiSetClick];
        }
        else if (indexPath.row == 3){
            [self deviceTimingClick];
        }
        else if (indexPath.row == 4){
            [self deviceProcessClick];
        }
    }else{
        //選擇轉發器
        if (_currentSegmentedIndex == 0) {
            //近端
            _currentSelectIrIndexPath = indexPath;
            [self choiceNearDevice:indexPath.row];
        }else{
            //遠端
            _currentSelectIrIndexPath = indexPath;
            [self choiceFarDevice:indexPath.row];
        }
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSIndexPath *oldIndex = [tableView indexPathForSelectedRow];
//        if (oldIndex == nil) {
//            oldIndex = _currentSelectIrIndexPath;
//        }
        [tableView cellForRowAtIndexPath:oldIndex].textLabel.text = [NSString stringWithFormat:@"   %@", [[[self.cellArray objectAtIndex:oldIndex.section] objectAtIndex:oldIndex.row] objectForKey:@"name"]];
        [tableView cellForRowAtIndexPath:indexPath].textLabel.text = [NSString stringWithFormat:@"\u2713%@",[[[self.cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"]];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self willShowInfo:indexPath.row];
}

@end
