//
//  SettingViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/8/15.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "SettingViewController.h"
#import "FGLanguageTool.h"
#import "SpeechToTextModule.h"
#import "WifiIRSetViewController.h"

@interface SettingViewController ()<SpeechToTextModuleDelegate>{
    FGLanguageTool* _fgLanguage;
    SpeechToTextModule* _speechToTextModule;
    BOOL _isRecording;
    //int second;
    //NSTimer *timer;
    
    __weak IBOutlet UIButton* _speakButton;
    __weak IBOutlet UILabel *_speakResultLable;
}
@end

@implementation SettingViewController
@synthesize pickerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    _fgLanguage = [FGLanguageTool sharedInstance];
    
    _speechToTextModule = [[SpeechToTextModule alloc] initWithCustomDisplay:nil];
    [_speechToTextModule setDelegate:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_SET];
    NSInteger row;
    if ([tmp isEqualToString:CNT]) {
        row = 1;
    }else if ([tmp isEqualToString:CNS]){
        row = 2;
    }else{
        row = 0;
    }
    
    [pickerView selectRow:row inComponent:0 animated:false];
    
    self.languageLable.text = Loc(@"語言");
    self.navigationItem.title = Loc(@"設定");
    self.navigationController.tabBarItem.title = Loc(@"設定");
}

-(IBAction)showWifiIRViewButtonClick:(id)sender{
    WifiIRSetViewController* view = [[WifiIRSetViewController alloc] initWithNibName:@"WifiIRSetViewController" bundle:nil];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)saveLanguage:(UIBarButtonItem *)sender {
    
    [_fgLanguage changeNowLanguage: (int)[pickerView selectedRowInComponent:0]];
}

- (IBAction)speakTap:(id)sender{
    if (_isRecording == NO) {
        //5秒後自動關閉語音輸入
        //[timer invalidate]; //先停止所有已註冊的動作，避免產生多個timer
        //second = 5;
        //timer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(stopRecording) userInfo:nil repeats:YES];
        [self startRecording];
    } else {
        //[timer invalidate];
        [self stopRecording];
    }
}

- (void)startRecording {
    if (_isRecording == NO) {
        [_speakButton setTitle:@"Recoding" forState:UIControlStateNormal];
        [_speechToTextModule beginRecording];
        _isRecording = YES;
    }
}

- (void)stopRecording {
    if (_isRecording) {
        [_speakButton setTitle:@"Standby" forState:UIControlStateNormal];
        [_speechToTextModule stopRecording:YES];
        _isRecording = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopRecording];
}

- (void)dealloc{
    if (_speechToTextModule){
        [self stopRecording];
        _speechToTextModule = nil;
    }
}

#pragma mark - SpeechToTextModuleDelegate
- (BOOL)didReceiveVoiceResponse:(NSDictionary *)data {
    
    NSLog(@"data %@",data);
    [self stopRecording];
    NSString *result = @"";
    id tmp = data[@"transcript"];
    if ([tmp isKindOfClass:[NSNumber class]] || [tmp rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound) {
        // Spell out number
        // incase user spell number
        NSNumber *resultNumber = [NSNumber numberWithInteger:[tmp integerValue]];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterSpellOutStyle];
        result = [formatter stringFromNumber:resultNumber];
    } else {
        result = tmp;
    }
    if (result == nil) {
        _speakResultLable.text = @"無法辨識，請再次測試";
    } else {
        _speakResultLable.text = result;
    }
    return YES;
}


#pragma mark - UIPickerViewDataSource
//設定選單項目的列數，例如時間 (小時：分鐘) 的 pickerView 就是 return 2
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//設定選單選項的數量
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //return [dataArray count];
    return [_fgLanguage.languageArray count];
}

#pragma mark - UIPickerViewDelegate
//設定選單項目
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component{
    return [_fgLanguage.languageArray objectAtIndex:row];
}

//當選單被滑動（Sliding）的時候，改變 textField 的值
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component{
    
    
}

@end
