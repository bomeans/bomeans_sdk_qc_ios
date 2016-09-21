//
//  IRSetViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/9/20.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "IRSetViewController.h"
#import "DataProvider.h"

@interface IRSetViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UIImageView *_colorImageView;
    __weak IBOutlet UISlider *_rSlider;
    __weak IBOutlet UISlider *_gSlider;
    __weak IBOutlet UISlider *_bSlider;
    __weak IBOutlet UIButton *_hourButton;
    __weak IBOutlet UIButton *_minuteButton;
    __weak IBOutlet UIButton *_secondButton;
    __weak IBOutlet UITableView *_hourTableView;
    __weak IBOutlet UITableView *_minuteTableView;
    __weak IBOutlet UITableView *_secondTableView;
    
    DataProvider* _dataProvider;
    NSMutableArray* _hourArray;
    NSMutableArray* _minuteArray;
    int _hour;
    int _min;
    int _sec;
}

@end

@implementation IRSetViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _hourArray = [[NSMutableArray alloc] initWithCapacity:1];
        _minuteArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataProvider = [DataProvider defaultDataProvider];
    
    for (int i = 0; i<=24; i++) {
        [_hourArray addObject:[NSString stringWithFormat:@"%i",i]];
    }
    for (int i = 0; i<=60; i++) {
        [_minuteArray addObject:[NSString stringWithFormat:@"%i",i]];
    }
    _hourTableView.dataSource = self;
    _hourTableView.delegate = self;
    _minuteTableView.dataSource = self;
    _minuteTableView.delegate = self;
    _secondTableView.dataSource = self;
    _secondTableView.delegate = self;
    _hourTableView.hidden = YES;
    _minuteTableView.hidden = YES;
    _secondTableView.hidden = YES;
    
    NSDate* now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSString *hh = [newDateString substringToIndex:2];
    NSString *mm = [newDateString substringWithRange:NSMakeRange(3, 2)];
    NSString *ss = [newDateString substringFromIndex:6];
    [_hourButton setTitle:hh forState:UIControlStateNormal];
    [_minuteButton setTitle:mm forState:UIControlStateNormal];
    [_secondButton setTitle:ss forState:UIControlStateNormal];
    _hour = [hh intValue];
    _min = [mm intValue];
    _sec = [ss intValue];
    
    [_rSlider addTarget:self action:@selector(rgbSliderValueChange) forControlEvents:UIControlEventValueChanged];
    [_gSlider addTarget:self action:@selector(rgbSliderValueChange) forControlEvents:UIControlEventValueChanged];
    [_bSlider addTarget:self action:@selector(rgbSliderValueChange) forControlEvents:UIControlEventValueChanged];
    
    [self rgbSliderValueChange];
}

-(void)rgbSliderValueChange{
    UIColor* ledColor = [UIColor colorWithRed:_rSlider.value green:_gSlider.value blue:_bSlider.value alpha:1.0];
    _colorImageView.backgroundColor = ledColor;
    [_dataProvider.irKit wifiIRLed_Color:_rSlider.value greenColor:_gSlider.value blueColor:_bSlider.value];
}

- (IBAction)irLedSwitchValueChange:(UISwitch *)sender {
    int returnCode;
    if ([sender isOn]) {
        returnCode = [_dataProvider.irKit wifiIRLed_OnOff:YES];
    }else{
        returnCode = [_dataProvider.irKit wifiIRLed_OnOff:NO];
    }
}

- (IBAction)setIRTimeButtonClick:(UIButton *)sender {
    int returnCode;
    returnCode = [_dataProvider.irKit wifiIR_SetNowTime:_hour min:_min sec:_sec];
}

- (IBAction)irWifiOnTimerButtonClick:(UIButton *)sender {
    int returnCode;
    returnCode = [_dataProvider.irKit wifiIR_SetOnTimer:YES hour:_hour min:_min sec:_sec];
}

- (IBAction)irWifiOffTimerButtonClick:(UIButton *)sender {
    int returnCode;
    returnCode = [_dataProvider.irKit wifiIR_SetOffTimer:YES hour:_hour min:_min sec:_sec];
}

- (IBAction)irWifiCancerTimerButtonClick:(UIButton *)sender {
    int returnCode;
    returnCode = [_dataProvider.irKit wifiIR_SetOnTimer:NO hour:_hour min:_min sec:_sec];
    returnCode = [_dataProvider.irKit wifiIR_SetOffTimer:NO hour:_hour min:_min sec:_sec];
}

- (IBAction)irLedOnTimerButtonClick:(UIButton *)sender {
    int returnCode;
    returnCode = [_dataProvider.irKit wifiIRLed_SetOnTimer:YES hour:_hour min:_min sec:_sec];
}

- (IBAction)irLedOffTimerButtonClick:(UIButton *)sender {
    int returnCode;
    returnCode = [_dataProvider.irKit wifiIRLed_SetOffTimer:YES hour:_hour min:_min sec:_sec];
}

- (IBAction)irLedCancerTimerButtonClick:(UIButton *)sender {
    int returnCode;
    returnCode = [_dataProvider.irKit wifiIRLed_SetOnTimer:NO hour:_hour min:_min sec:_sec];
    returnCode = [_dataProvider.irKit wifiIRLed_SetOffTimer:NO hour:_hour min:_min sec:_sec];
}

- (IBAction)hourButtonClick:(UIButton *)sender {
    if (_hourTableView.hidden == YES) {
        _hourTableView.hidden = NO;
    }
    else _hourTableView.hidden = YES;
}

- (IBAction)minuteButtonClick:(UIButton *)sender {
    if (_minuteTableView.hidden == YES) {
        _minuteTableView.hidden = NO;
    }
    else _minuteTableView.hidden = YES;
}

- (IBAction)secondButtonClick:(UIButton *)sender {
    if (_secondTableView.hidden == YES) {
        _secondTableView.hidden = NO;
    }
    else _secondTableView.hidden = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_hourTableView]) {
        return _hourArray.count;
    }
    return _minuteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if ([tableView isEqual:_hourTableView]) {
        cell.textLabel.text = [_hourArray objectAtIndex:indexPath.row];
    }else
    {
        cell.textLabel.text = [_minuteArray objectAtIndex:indexPath.row];

    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([tableView isEqual:_hourTableView]) {
        [_hourButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
        _hourTableView.hidden = YES;
        _hour = [cell.textLabel.text intValue];
    }
    else if ([tableView isEqual:_minuteTableView]) {
        [_minuteButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
        _minuteTableView.hidden = YES;
        _min = [cell.textLabel.text intValue];
    }
    else if ([tableView isEqual:_secondTableView]) {
        [_secondButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
        _secondTableView.hidden = YES;
        _sec = [cell.textLabel.text intValue];
    }
}

@end
