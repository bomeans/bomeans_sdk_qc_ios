//
//  ACRemoteViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/9/14.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "ACRemoteViewController.h"
#import "DataProvider.h"
#import "IR/BIRKeyOption.h"
#import "IR/BIRGUIFeature.h"

@interface ACRemoteViewController () <UITableViewDataSource,UITableViewDelegate>

{
    
    __weak IBOutlet UIView *_lcdView;
    __weak IBOutlet UITableView *_keyTableView;
    __weak IBOutlet UIImageView *_modeImageView;
    __weak IBOutlet UIImageView *_turboImageView;
    __weak IBOutlet UIImageView *_airSwapImageView;
    __weak IBOutlet UIImageView *_lightImageView;
    __weak IBOutlet UIImageView *_warmUpImageView;
    __weak IBOutlet UIImageView *_swingLeftRightImageView;
    __weak IBOutlet UIImageView *_swingUpDownImageView;
    __weak IBOutlet UIImageView *_sleepImageView;
    __weak IBOutlet UIImageView *_airCleanImageView;
    __weak IBOutlet UILabel *_fanSpeedLabel;
    __weak IBOutlet UILabel *_temperatureLabel;
    __weak IBOutlet UISwitch *_powerSwitch;
    __weak IBOutlet UIStepper *_temperatureStepper;
    
    DataProvider* _dataProvider;
    id<BIRRemote> _remoter;
    NSMutableArray* _keyArray;
    
    NSMutableArray* _powerArray;
    NSMutableArray* _modeArray;
    NSMutableArray* _temperatureArray;
    NSMutableArray* _fanspeedArray;
    NSMutableArray* _swingUpDownArray;
    NSMutableArray* _swingLeftRightArray;
    NSMutableArray* _turboArray;
    NSMutableArray* _airSwapArray;
    NSMutableArray* _lightArray;
    NSMutableArray* _warmUpArray;
    NSMutableArray* _sleepArray;
    NSMutableArray* _airCleanArray;
    
}
@property (nonatomic, strong) NSString* power;
@property (nonatomic, strong) NSString* mode;
@property (nonatomic, strong) NSString* temperature;
@property (nonatomic, strong) NSString* swingUpDown;
@property (nonatomic, strong) NSString* swingLeftRight;
@property (nonatomic, strong) NSString* timer;
@property (nonatomic, strong) NSString* fanspeed;
@property (nonatomic, strong) NSString* turbo;
@property (nonatomic, strong) NSString* airSwap;
@property (nonatomic, strong) NSString* light;
@property (nonatomic, strong) NSString* warmUp;
@property (nonatomic, strong) NSString* sleep;
@property (nonatomic, strong) NSString* airClean;
@end

@implementation ACRemoteViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _keyArray = [[NSMutableArray alloc] initWithCapacity:1];
        self.power = @"IR_ACOPT_POWER_OFF";
        self.mode = @"IR_ACOPT_MODE_COOL";
        self.temperature = @"IR_ACSTATE_TEMP_26";
        self.swingUpDown = @"IR_ACOPT_AIRSWING_UD_OFF";
        self.swingLeftRight = @"IR_ACOPT_AIRSWING_LR_OFF";
        self.timer = @"";
        self.fanspeed = @"IR_ACOPT_FANSPEED_A";
        self.turbo= @"IR_ACOPT_POWER_OFF";
        self.airSwap = @"IR_ACOPT_POWER_OFF";
        self.light = @"IR_ACOPT_POWER_OFF";
        self.warmUp = @"IR_ACOPT_POWER_OFF";
        self.sleep = @"IR_ACOPT_POWER_OFF";
        self.airClean = @"IR_ACOPT_POWER_OFF";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataProvider = [DataProvider defaultDataProvider];
    _remoter = [_dataProvider createRemoterWithType:self.typeID withBrand:self.brandID andModel:self.modelID];
    _keyArray = [NSMutableArray arrayWithArray:[_remoter getActiveKeys]];

    self.navigationItem.title = [_remoter getBrandName];//self.brandName;
    UIBarButtonItem *naviLeftButton = [[UIBarButtonItem alloc] initWithTitle:@"＜Back" style:UIBarButtonItemStylePlain target:self action:@selector(popToRootViewController:)];
    self.navigationItem.leftBarButtonItem = naviLeftButton;
    
    _keyTableView.delegate = self;
    _keyTableView.dataSource = self;
    [_powerSwitch addTarget:self action:@selector(powerSwitchChange:) forControlEvents:UIControlEventValueChanged];
    
    _temperatureArray = [_remoter getKeyOption:@"IR_ACKEY_TEMP"].options;
    
    NSRange range = [[_temperatureArray firstObject] rangeOfString:@"IR_ACSTATE_TEMP_"];
    NSString* minTemperatuer;
    NSString* maxTemperatuer;
    if (NSNotFound != range.location)
    {
        minTemperatuer = [[_temperatureArray firstObject] substringFromIndex:range.location+range.length];
        maxTemperatuer = [[_temperatureArray lastObject] substringFromIndex:range.location+range.length];
    }
    else
    {
        range = [[_temperatureArray firstObject] rangeOfString:@"IR_ACOPT_TEMP_"];

        if (NSNotFound != range.location)
        {
            minTemperatuer = [[_temperatureArray firstObject] substringFromIndex:range.location+range.length];
            maxTemperatuer = [[_temperatureArray lastObject] substringFromIndex:range.location+range.length];
        }
    }
    
    //設定stepper的範圍與起始值
    [_temperatureStepper setMinimumValue:[minTemperatuer doubleValue]];
    [_temperatureStepper setMaximumValue:[maxTemperatuer doubleValue]];
    [_temperatureStepper setValue:[minTemperatuer doubleValue]];
    
    //設定stepper每次增減的值
    [_temperatureStepper setStepValue:1.0];
    
    //設定stepper可以按住不放來連續更改數值
    [_temperatureStepper setContinuous:YES];
    
    //設定stepper是否循環（到最大值時再增加數值最從最小值開始）
    [_temperatureStepper setWraps:NO];
    
    //將stepper加入UIControlEventValueChanged的觸發事件中並設定觸發時所處理的函式
    [_temperatureStepper addTarget:self action:@selector(temperatuerStepperValueChange) forControlEvents:UIControlEventValueChanged];
    
    [self reloadData];
    
}

-(void)popToRootViewController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)powerSwitchChange:(id)sender {
    //BIRGUIFeature *gui = [_remoter getGuiFeature];
    //NSLog(@"%@", gui);
    //NSArray* timerKeys = [_remoter getTimerKeys];
    //NSLog(@"%@", timerKeys);
    //NSArray* acData = [_remoter getACStoreDatas];
    [_remoter transmitIR:@"IR_ACKEY_POWER" withOption:nil];
    //if ([_powerSwitch isOn]) {
    //    [_remoter setOffTimeHour:15 minute:27 second:0];
    //}
    [self reloadData];
}

-(void)temperatuerStepperValueChange{
    //NSLog(@"temp : %.1f", _temperatureStepper.value);
    NSString* temp = [_temperatureArray objectAtIndex:_temperatureStepper.value - _temperatureStepper.minimumValue];
    [_remoter transmitIR:@"IR_ACKEY_TEMP" withOption:temp];
    [self reloadData];
}

-(void)reloadData{
    _powerArray = [_remoter getKeyOption:@"IR_ACKEY_POWER"].options;
    _modeArray = [_remoter getKeyOption:@"IR_ACKEY_MODE"].options;
    _temperatureArray = [_remoter getKeyOption:@"IR_ACKEY_TEMP"].options;
    _fanspeedArray = [_remoter getKeyOption:@"IR_ACKEY_FANSPEED"].options;
    _swingUpDownArray = [_remoter getKeyOption:@"IR_ACKEY_AIRSWING_UD"].options;
    _swingLeftRightArray = [_remoter getKeyOption:@"IR_ACKEY_AIRSWING_LR"].options;
    _turboArray = [_remoter getKeyOption:@"IR_ACKEY_TURBO"].options;
    _airSwapArray = [_remoter getKeyOption:@"IR_ACKEY_AIRSWAP"].options;
    _lightArray = [_remoter getKeyOption:@"IR_ACKEY_LIGHT"].options;
    _warmUpArray = [_remoter getKeyOption:@"IR_ACKEY_WARMUP"].options;
    _sleepArray = [_remoter getKeyOption:@"IR_ACKEY_SLEEP"].options;
    _airCleanArray = [_remoter getKeyOption:@"IR_ACKEY_AIRCLEAN"].options;
    
    self.power = [_powerArray objectAtIndex:[_remoter getKeyOption:@"IR_ACKEY_POWER"].currentOption];
    self.mode = [_modeArray objectAtIndex:[_remoter getKeyOption:@"IR_ACKEY_MODE"].currentOption];
    self.temperature = [_temperatureArray objectAtIndex:[_remoter getKeyOption:@"IR_ACKEY_TEMP"].currentOption];
    self.fanspeed = [_fanspeedArray objectAtIndex:[_remoter getKeyOption:@"IR_ACKEY_FANSPEED"].currentOption];
    self.swingUpDown = _swingUpDownArray == nil ? @"IR_ACOPT_AIRSWING_UD_OFF" : [_swingUpDownArray objectAtIndex:[_remoter getKeyOption:@"IR_ACKEY_AIRSWING_UD"].currentOption];
    self.swingLeftRight = _swingLeftRightArray == nil ? @"IR_ACOPT_AIRSWING_LR_OFF" : [_swingLeftRightArray objectAtIndex:[_remoter getKeyOption:@"IR_ACKEY_AIRSWING_LR"].currentOption];
    self.turbo = _turboArray == nil ? @"IR_ACOPT_TURBO_OFF" : [_turboArray objectAtIndex:[_remoter getKeyOption:@"IR_ACKEY_TURBO"].currentOption];
    self.airSwap = _airSwapArray == nil ? @"IR_ACOPT_AIRSWAP_OFF" : [_airSwapArray objectAtIndex:[_remoter getKeyOption:@"IR_ACKEY_AIRSWAP"].currentOption];
    self.light = _lightArray == nil ? @"IR_ACOPT_LIGHT_OFF" : [_lightArray objectAtIndex:[_remoter getKeyOption:@"IR_ACKEY_LIGHT"].currentOption];
    self.warmUp = _warmUpArray == nil ? @"IR_ACOPT_WARMUP_OFF" : [_warmUpArray objectAtIndex:[_remoter getKeyOption:@"IR_ACKEY_WARMUP"].currentOption];
    self.sleep = _sleepArray == nil ? @"IR_ACOPT_SLEEP_OFF" : [_sleepArray objectAtIndex:[_remoter getKeyOption:@"IR_ACKEY_SLEEP"].currentOption];
    self.airClean = _airCleanArray == nil ? @"IR_ACOPT_AIRCLEAN_OFF" : [_airCleanArray objectAtIndex:[_remoter getKeyOption:@"IR_ACKEY_AIRCLEAN"].currentOption];
    
    if (NSOrderedSame == [@"IR_ACOPT_POWER_OFF" compare:self.power])
    {
        _lcdView.hidden = YES;
        
        [_powerSwitch setOn:NO animated:YES];
    }
    else if (NSOrderedSame == [@"IR_ACOPT_POWER_ON" compare:self.power])
    {
        _lcdView.hidden = NO;
        
        [_powerSwitch setOn:YES animated:YES];
    }
    
    if (NSOrderedSame == [@"IR_ACOPT_MODE_AUTO" compare:self.mode])
    {
        _modeImageView.image = [UIImage imageNamed:@"remoter-AC-modeauto"];
    }
    else if (NSOrderedSame == [@"IR_ACOPT_MODE_COOL" compare:self.mode])
    {
        _modeImageView.image = [UIImage imageNamed:@"remoter-AC-modecold"];
    }
    else if (NSOrderedSame == [@"IR_ACOPT_MODE_DRY" compare:self.mode])
    {
        _modeImageView.image = [UIImage imageNamed:@"remoter-AC-cleanwater"];
    }
    else if (NSOrderedSame == [@"IR_ACOPT_MODE_FAN" compare:self.mode])
    {
        _modeImageView.image = [UIImage imageNamed:@"remoter-AC-modewind"];
    }
    else if (NSOrderedSame == [@"IR_ACOPT_MODE_WARM" compare:self.mode])
    {
        _modeImageView.image = [UIImage imageNamed:@"remoter-AC-modehot"];
    }

    if (NSOrderedSame == [@"IR_ACOPT_FANSPEED_A" compare:self.fanspeed])
    {
        //_fanspeedLabel.text = [NSString stringWithFormat:L(@"FanSpeedA"), @"自动"];
        _fanSpeedLabel.text = @"風速：自動";
    }
    else if (NSOrderedSame == [@"IR_ACOPT_FANSPEED_L" compare:self.fanspeed])
    {
        _fanSpeedLabel.text = @"風速：低";
    }
    else if (NSOrderedSame == [@"IR_ACOPT_FANSPEED_M" compare:self.fanspeed])
    {
        _fanSpeedLabel.text = @"風速：中";
    }
    else if (NSOrderedSame == [@"IR_ACOPT_FANSPEED_H" compare:self.fanspeed])
    {
        _fanSpeedLabel.text = @"風速：高";
    }
    else if (NSOrderedSame == [@"IR_ACOPT_FANSPEED_H1" compare:self.fanspeed])
    {
        _fanSpeedLabel.text = @"風速：高1檔";
    }
    else if (NSOrderedSame == [@"IR_ACOPT_FANSPEED_H2" compare:self.fanspeed])
    {
        _fanSpeedLabel.text = @"風速：高2檔";
    }
    
    NSRange range = [self.temperature rangeOfString:@"IR_ACSTATE_TEMP_"];
    if (NSNotFound != range.location)
    {
        _temperatureLabel.text = [self.temperature substringFromIndex:range.location+range.length];
    }
    else
    {
        NSRange range = [self.temperature rangeOfString:@"IR_ACOPT_TEMP_"];
        if (NSNotFound != range.location)
        {
            _temperatureLabel.text = [self.temperature substringFromIndex:range.location+range.length];
        }
    }
    
    if (self.swingUpDown.length > 0 && NSOrderedSame != [@"IR_ACOPT_AIRSWING_UD_OFF" compare:self.swingUpDown])
    {
        _swingUpDownImageView.hidden = NO;
    }
    else
    {
        _swingUpDownImageView.hidden = YES;
    }
    
    if (self.swingLeftRight.length > 0 && NSOrderedSame != [@"IR_ACOPT_AIRSWING_LR_OFF" compare:self.swingLeftRight])
    {
        _swingLeftRightImageView.hidden = NO;
    }
    else
    {
        _swingLeftRightImageView.hidden = YES;
    }
    
    if (self.turbo.length > 0 && NSOrderedSame != [@"IR_ACOPT_TURBO_OFF" compare:self.turbo])
    {
        _turboImageView.hidden = NO;
    }
    else
    {
        _turboImageView.hidden = YES;
    }
    
    if (self.airSwap.length > 0 && NSOrderedSame != [@"IR_ACOPT_AIRSWAP_OFF" compare:self.airSwap])
    {
        _airSwapImageView.hidden = NO;
    }
    else
    {
        _airSwapImageView.hidden = YES;
    }
    
    if (self.light.length > 0 && NSOrderedSame != [@"IR_ACOPT_LIGHT_OFF" compare:self.light])
    {
        _lightImageView.hidden = NO;
    }
    else
    {
        _lightImageView.hidden = YES;
    }
    
    if (self.warmUp.length > 0 && NSOrderedSame != [@"IR_ACOPT_WARMUP_OFF" compare:self.warmUp])
    {
        _warmUpImageView.hidden = NO;
    }
    else
    {
        _warmUpImageView.hidden = YES;
    }
    
    if (self.sleep.length > 0 && NSOrderedSame != [@"IR_ACOPT_SLEEP_OFF" compare:self.sleep])
    {
        _sleepImageView.hidden = NO;
    }
    else
    {
        _sleepImageView.hidden = YES;
    }
    
    if (self.airClean.length > 0 && NSOrderedSame != [@"IR_ACOPT_AIRCLEAN_OFF" compare:self.airClean])
    {
        _airCleanImageView.hidden = NO;
    }
    else
    {
        _airCleanImageView.hidden = YES;
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _keyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"remoteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = [_keyArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* irkey = cell.textLabel.text;
    //NSLog(@"transmitIR : %@",irkey);
    [_remoter transmitIR:irkey withOption:nil];
    [self reloadData];
}


@end
