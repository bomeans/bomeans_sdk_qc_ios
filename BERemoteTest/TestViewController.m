//
//  TestViewController.m
//  BERemoteTest
//
//  Created by Hung Ricky on 2016/10/6.
//  Copyright © 2016年 Hung Ricky. All rights reserved.
//

#import "TestViewController.h"
#import "DataProvider.h"
#import "IR/BomeansIRKit.h"
#import "IR/BIRBrandItem.h"
#import <Speech/Speech.h>

@interface TestViewController ()<SFSpeechRecognizerDelegate>{
    __weak IBOutlet UILabel *_countLable;
    __weak IBOutlet UILabel *_errorNumNoteLable;
    
    
    __weak IBOutlet UIButton *_microphoneButton;
    __weak IBOutlet UITextView *_textView;
    
    DataProvider* _dataProvider;
    id<BIRRemote> _remote;
    int _count;
    int _errorCount;
    NSTimer* _myTimer;
    NSTimer* _onecTimer;
    
    SFSpeechRecognizer *_speechRecognizer;
    SFSpeechAudioBufferRecognitionRequest *_recognitionRequest; //這個物件負責發起語音識別請求。它為語音識別器指定一個音頻輸入源。
    SFSpeechRecognitionTask *_recognitionTask;  //這個物件用於保存發起語音識別請求后的返回值。通過這個物件，你可以取消或中止當前的語音識別任務。
    AVAudioEngine *_audioEngine; //這個物件引用了語音引擎。它負責提供錄音輸入。
    
}
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.navigationController = [[UINavigationController alloc]init];
    
    _dataProvider = [DataProvider initDataProvider];
    
    _remote = [_dataProvider createRemoterWithType:@"1" withBrand:@"12" andModel:@"LCD100"];
    
    //_myTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(irWifiTimerTest) userInfo:nil repeats:YES];
    _count = 0;
    _errorCount = 0;
    
    /*****/
    //首先，我們建立了一個 SFSpeechRecognizer 物件，並指定其 locale identifier 為 en-US，也就是通知語音識別器用戶所使用的語言。這個對象將用於語音識別。
    _speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"zh-Hant"]];
    //根據預設，我們將禁用 microphone 按鈕，一直到語音識別器被激活。
    [_microphoneButton setEnabled:false];
    //將語音識別器的 delegate 設為 self，也就是我們的 ViewController。
    _speechRecognizer.delegate = self;
    
    //然後，調用 SFSpeechRecognizer.requestAuthorization 獲得語音識別的授權。
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        Boolean isButtonEnabled = false;
        //最後，判斷授權狀態，如果用戶已授權，啟用麥克風按鈕。否則顯示錯誤信息並禁用麥克風按鈕。
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                isButtonEnabled = true;
                break;
                
            case SFSpeechRecognizerAuthorizationStatusDenied:
                isButtonEnabled = false;
                NSLog(@"User denied access to speech recognition");
                break;
                
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                isButtonEnabled = false;
                NSLog(@"Speech recognition restricted on this device");
                break;
                
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                isButtonEnabled = false;
                NSLog(@"Speech recognition not yet authorized");
                break;
                
            default:
                break;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_microphoneButton setEnabled:isButtonEnabled];
        }];
    }];
    
    _audioEngine = [AVAudioEngine new];
    /*****/
}

-(void)viewDidDisappear:(BOOL)animated{
    [_myTimer invalidate];
    [_onecTimer invalidate];
    _myTimer = nil;
    _onecTimer = nil;
}

- (IBAction)microphoneTapped:(UIButton *)sender {
    [_onecTimer invalidate];
    if (_audioEngine.isRunning) {
        [self microphoneOff];
    } else {
        [self microphoneOn];
        _onecTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(microphoneOff) userInfo:nil repeats:NO];
    }
}

-(void)microphoneOn{
    [self startRecording];
    [_microphoneButton setTitle:@"Stop Recording" forState:UIControlStateNormal];
}

-(void)microphoneOff{
    [_audioEngine stop];
    [_recognitionRequest endAudio];
    [_microphoneButton setEnabled:false];
    [_microphoneButton setTitle:@"Start Recording" forState:UIControlStateNormal];
}

-(void)startRecording{
    //檢查 recognitionTask 任務是否處於運行狀態。如果是，取消任務，開始新的語音識別任務。
    if (_recognitionTask != nil) {
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }
    
    //建立一個 AVAudioSession 用於錄音。將它的 category 設置為 record，mode 設置為 measurement，然後開啟 audio session。因為對這些屬性進行設置有可能出現異常情況，因此你必須將它們放到 try catch 語句中。
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    @try {
        [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
        [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
        [audioSession setActive:true withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    } @catch (NSException *exception) {
        NSLog(@"audioSession properties weren't set because of an error.");
    }
    
    //初始化 recognitionRequest 物件。這裡我們建立了一個 SFSpeechAudioBufferRecognitionRequest 物件。在後面，我們會用它將錄音數據轉發給蘋果伺務器。
    _recognitionRequest = [SFSpeechAudioBufferRecognitionRequest new];
    
    //檢查 audioEngine (即你的iPhone) 是否擁有有效的錄音設備。如果沒有，我們產生一個致命錯誤。
    AVAudioInputNode *inputNode = _audioEngine.inputNode;
    if (inputNode == nil) {
        NSLog(@"Audio engine has no input node");
    }
    
    //檢查 recognitionRequest 物件是否初始化成功 （即是值不能設為nil）。
    if (_recognitionRequest == nil) {
        NSLog(@"Unable to create an SFSpeechAudioBuferRecognitionRequest object");
    }
    
    //告訴 recognitionRequest 在用戶說話的同時，將識別結果分批返回。
    _recognitionRequest.shouldReportPartialResults = true;
    
    //呼叫 speechRecognizer 裡的recognitionTask 方法開始識別。方法參數中包括一個處理函數。當語音識別引擎每次採集到語音數據、修改當前識別、取消、停止、以及返回最終譯稿時都會調用處理函數。
    _recognitionTask = [_speechRecognizer recognitionTaskWithRequest:_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        
        //定義一個 boolean 變數，用於檢查識別是否結束。
        Boolean isFinal = false;
        
        //如果 result 不是 nil，將 textView.text 設置為 result 的最佳音譯。如果 result 是最終譯稿，將 isFinal 設置為 true。
        if (result != nil) {
            _textView.text = result.bestTranscription.formattedString;
            isFinal = result.isFinal;
        }
        
        //如果沒有錯誤發生，或者 result 已經結束，停止 audioEngine (錄音) 並終止 recognitionRequest 和 recognitionTask。同時，使 「開始錄音」按鈕可用。
        if ((error != nil) || isFinal) {
            [_audioEngine stop];
            [inputNode removeTapOnBus:0];
            
            _recognitionRequest = nil;
            _recognitionTask = nil;
            
            [_microphoneButton setEnabled:true];
        }
    }];
    
    //向 recognitionRequest 加入一個音頻輸入。注意，可以在啟動 recognitionTask 之後再添加音頻輸入。Speech 框架會在添加完音頻輸入後立即開始識別。
    AVAudioFormat* recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [_recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    //最後，啟動 audioEngine。
    [_audioEngine prepare];
    
    @try {
        [_audioEngine startAndReturnError:nil];
    } @catch (NSException *exception) {
        NSLog(@"audioEngine couldn't start because of an error.");
    }
    
    _textView.text = @"Say something, I'm listening!";
}

#pragma mark - SFSpeechRecognizerDelegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer
   availabilityDidChange:(BOOL)available{
    [_microphoneButton setEnabled:available];
}

- (void)irWifiTimerTest{
    /*
     if ([_ledSwitch isOn]) {
     _ledSwitch.on = false;
     NSLog(@"change off");
     }
     else {
     _ledSwitch.on = true;
     NSLog(@"change on");
     }
     
     _count++;
     _countLable.text = [NSString stringWithFormat:@"%i",_count];
     NSLog(@"test count : %i", _count);
     switch (_count % 3) {
     case 0:
     [_dataProvider.irKit wifiIRLed_Color:122/255.0 greenColor:0 blueColor:0];
     break;
     case 1:
     [_dataProvider.irKit wifiIRLed_Color:0 greenColor:122/255.0 blueColor:0];
     break;
     case 2:
     [_dataProvider.irKit wifiIRLed_Color:0 greenColor:0 blueColor:122/255.0];
     break;
     default:
     break;
     }
     [self irLedSwitchValueChange:_ledSwitch];
     */
    
    /*
     _count++;
     _countLable.text = [NSString stringWithFormat:@"%i",_count];
     NSLog(@"test count : %i", _count);
     
     [_dataProvider.irKit wifiIRLed_OnOff:NO];
     
     int returnCode;
     
     returnCode = [_dataProvider.irKit wifiIR_SetOffTimer:YES hour:0 min:0+1 sec:0];
     returnCode = [_dataProvider.irKit wifiIR_SetOnTimer:YES hour:0 min:0+2 sec:0];
     [_dataProvider.irKit wifiIRLed_OnOff:YES];
     */
    /*
     BomeansIRKit* testKit = [[BomeansIRKit alloc] initWithKey:@""];
     
     _count++;
     _countLable.text = [NSString stringWithFormat:@"%i",_count];
     NSLog(@"test count : %i", _count);
     
     NSString* deviceIP1 = @"192.168.1.21";
     [testKit setWifiToIrIP: deviceIP1];
     
     [testKit wifiIRLed_OnOff:NO];
     
     int returnCode;
     
     returnCode = [testKit wifiIR_SetOffTimer:YES hour:0 min:0+1 sec:0];
     returnCode = [te    stKit wifiIR_SetOnTimer:YES hour:0 min:0+2 sec:0];
     [testKit wifiIRLed_OnOff:YES];
     */
    //[_dataProvider getWifiIRState];
    [self irWifiAfterCheckConnect];
    //_onecTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(irWifiAfterCheckConnect) userInfo:nil repeats:NO];
    
}

-(void)irWifiAfterCheckConnect{
    //BomeansIRKit* testKit = [[BomeansIRKit alloc] initWithKey:@""];
    
    _count++;
    _countLable.text = [NSString stringWithFormat:@"%i",_count];
    NSLog(@"test count : %i", _count);
    
    //NSString* deviceIP1 = @"192.168.1.21";
    
    //[testKit setWifiToIrIP: deviceIP1];
    //id<BIRRemote> remote = [_dataProvider createRemoterWithType:@"1" withBrand:@"12" andModel:@"LCD100"];
    [_remote transmitIR:@"IR_KEY_POWER_TOGGLE" withOption:nil];
    /*
     [testKit wifiIRLed_OnOff:NO];
     
     int returnCode;
     
     returnCode = [testKit wifiIR_SetOffTimer:YES hour:0 min:0+1 sec:0];
     returnCode = [testKit wifiIR_SetOnTimer:YES hour:0 min:0+2 sec:0];
     [testKit wifiIRLed_OnOff:YES];
     */
}

- (IBAction)countButtonClick:(UIButton *)sender {
    _errorNumNoteLable.text = _countLable.text;
    
    _errorCount++;
    [sender setTitle:[NSString stringWithFormat:@"%i",_errorCount] forState:UIControlStateNormal];
}

- (IBAction)testButtonClick:(UIButton *)sender {
    /*
     BomeansIRKit* testIrKit;
     testIrKit = [[BomeansIRKit alloc] initWithKey:@""];
     [BomeansIRKit setUseChineseServer:YES]; //預設值:NO=tw, YES=cn
     id<BIRRemote> _myRemote = [testIrKit createBigCombineRemote:@"1" withBrand:@"336" getNew:YES];
     //NSLog(@"cn top 10 tv : %@", [testIrKit webGetTopBrandList:@"1" start:1 number:5 language:@"cn" getNew:YES]);
     for (BIRBrandItem* item in [testIrKit webGetTopBrandList:@"1" start:1 number:5 language:@"cn" getNew:YES]) {
     NSLog(@"cn top 5 tv : %@",item.name);
     }
     [BomeansIRKit setUseChineseServer:NO]; //預設值:NO=tw, YES=cn
     //NSLog(@"tw top 10 tv : %@", [testIrKit webGetTopBrandList:@"1" start:1 number:5 language:@"tw" getNew:YES]);
     for (BIRBrandItem* item in [testIrKit webGetTopBrandList:@"1" start:1 number:5 language:@"tw" getNew:YES]) {
     NSLog(@"tw top 5 tv : %@",item.name);
     }
     NSString* _message = _myRemote?@"Create Success":@"Create Fail";
     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"test" message:_message preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
     [alert addAction:okAction];
     [self presentViewController:alert animated:YES completion:nil];
     */
    
    BomeansIRKit* testIrKit;
    testIrKit = [[BomeansIRKit alloc] initWithKey:@""];
    [BomeansIRKit setUseChineseServer:NO]; //預設值:NO=tw, YES=cn
    
    [testIrKit setWifiToIrIP: nil];
    
    NSString* deviceIP1 = @"192.168.1.21";
    [testIrKit setWifiToIrIP: deviceIP1];
    [testIrKit wifiIRLed_OnOff:NO];
    
    int returnCode;
    
    returnCode = [testIrKit wifiIR_SetOffTimer:YES hour:0 min:0+1 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Wifi Off Time result: %i", returnCode]];
    returnCode = [testIrKit wifiIR_SetOnTimer:YES hour:0 min:0+2 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Wifi On Time result: %i", returnCode]];
    returnCode = [testIrKit wifiIRLed_SetOffTimer:YES hour:0 min:0+1 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Led Off Timer result: %i", returnCode]];
    returnCode = [testIrKit wifiIRLed_SetOnTimer:YES hour:0 min:0+2 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Led On Timer result: %i", returnCode]];
    [testIrKit wifiIRLed_OnOff:YES];
    NSLog(@"IP1 Off=H:%i, M:%i, S:%i", 0, 0+1, 0);
    
    NSString* _message = @"test set on";
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"test" message:_message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)chage21ButtonClick:(UIButton *)sender {
    int returnCode;
    NSString* deviceIP1 = @"192.168.1.21";
    [_dataProvider.irKit setWifiToIrIP: deviceIP1];
    [_dataProvider.irKit wifiIRLed_OnOff:NO];
    
    returnCode = [_dataProvider.irKit wifiIR_SetOffTimer:YES hour:0 min:0+1 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Wifi Off Time result: %i", returnCode]];
    returnCode = [_dataProvider.irKit wifiIR_SetOnTimer:YES hour:0 min:0+2 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Wifi On Time result: %i", returnCode]];
    returnCode = [_dataProvider.irKit wifiIRLed_SetOffTimer:YES hour:0 min:0+1 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Led Off Timer result: %i", returnCode]];
    returnCode = [_dataProvider.irKit wifiIRLed_SetOnTimer:YES hour:0 min:0+2 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Led On Timer result: %i", returnCode]];
    
    [_dataProvider.irKit wifiIRLed_OnOff:YES];
    NSLog(@"IP1 Off=H:%i, M:%i, S:%i", 0, 0+1, 0);
    //[self showAlert:@"test set on"];
}
- (IBAction)change32ButtonClick:(UIButton *)sender {
    int returnCode;
    NSString* deviceIP2 = @"192.168.1.32";
    [_dataProvider.irKit setWifiToIrIP: deviceIP2];
    [_dataProvider.irKit wifiIRLed_OnOff:NO];
    
    returnCode = [_dataProvider.irKit wifiIR_SetOffTimer:YES hour:0 min:0+2 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Wifi Off Time result: %i", returnCode]];
    returnCode = [_dataProvider.irKit wifiIR_SetOnTimer:YES hour:0 min:0+3 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Wifi On Time result: %i", returnCode]];
    returnCode = [_dataProvider.irKit wifiIRLed_SetOffTimer:YES hour:0 min:0+2 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Led Off Timer result: %i", returnCode]];
    returnCode = [_dataProvider.irKit wifiIRLed_SetOnTimer:YES hour:0 min:0+3 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Led On Timer result: %i", returnCode]];
    
    [_dataProvider.irKit wifiIRLed_OnOff:YES];
    NSLog(@"IP2 Off=H:%i, M:%i, S:%i", 0, 0+2, 0);
    //[self showAlert:@"test set on"];
}

- (IBAction)wifiTestButtonClick:(UIButton *)sender {
    
    int returnCode;
    
    [_dataProvider.irKit setWifiToIrIP: nil];
    
    NSString* deviceIP1 = @"192.168.1.21";
    [_dataProvider.irKit setWifiToIrIP: deviceIP1];
    [_dataProvider.irKit wifiIRLed_OnOff:NO];
    
    returnCode = [_dataProvider.irKit wifiIR_SetOffTimer:YES hour:0 min:0+1 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Wifi Off Time result: %i", returnCode]];
    returnCode = [_dataProvider.irKit wifiIR_SetOnTimer:YES hour:0 min:0+2 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Wifi On Time result: %i", returnCode]];
    returnCode = [_dataProvider.irKit wifiIRLed_SetOffTimer:YES hour:0 min:0+1 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Led Off Timer result: %i", returnCode]];
    returnCode = [_dataProvider.irKit wifiIRLed_SetOnTimer:YES hour:0 min:0+2 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Led On Timer result: %i", returnCode]];
    [_dataProvider.irKit wifiIRLed_OnOff:YES];
    NSLog(@"IP1 Off=H:%i, M:%i, S:%i", 0, 0+1, 0);
    
    NSString* deviceIP2 = @"192.168.1.32";
    [_dataProvider.irKit setWifiToIrIP: deviceIP2];
    [_dataProvider.irKit wifiIRLed_OnOff:NO];
    
    returnCode = [_dataProvider.irKit wifiIR_SetOffTimer:YES hour:0 min:0+2 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Wifi Off Time result: %i", returnCode]];
    returnCode = [_dataProvider.irKit wifiIR_SetOnTimer:YES hour:0 min:0+3 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Wifi On Time result: %i", returnCode]];
    returnCode = [_dataProvider.irKit wifiIRLed_SetOffTimer:YES hour:0 min:0+2 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Led Off Timer result: %i", returnCode]];
    returnCode = [_dataProvider.irKit wifiIRLed_SetOnTimer:YES hour:0 min:0+3 sec:0];
    //[self showAlert: [NSString stringWithFormat:@"Set IR Led On Timer result: %i", returnCode]];
    [_dataProvider.irKit wifiIRLed_OnOff:YES];
    NSLog(@"IP2 Off=H:%i, M:%i, S:%i", 0, 0+2, 0);
    //[self showAlert:@"test set on"];
    
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
