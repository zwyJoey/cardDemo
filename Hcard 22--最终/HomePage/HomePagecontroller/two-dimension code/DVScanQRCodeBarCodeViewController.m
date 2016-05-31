//
//  DVScanQRCodeBarCodeViewController.m
//  kyzx
//
//  Created by xusc on 16/5/11.
//  Copyright © 2016年 zhiyuan. All rights reserved.
//

#import "DVScanQRCodeBarCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

static const char *kScanCodeQueueName = "ScanCodeQueue";

@interface DVScanQRCodeBarCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic)  UIView *scanFrameView;
@property (strong, nonatomic)  UIButton *button;
@property (strong, nonatomic)  UIButton *lightButton;

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL lastResut;
@end

@implementation DVScanQRCodeBarCodeViewController

- (void)createUI{
    self.view.backgroundColor = [UIColor colorWithRed:0.800 green:0.800 blue:0.800 alpha:1.00];
    
    self.scanFrameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*0.8, self.view.bounds.size.height*0.6)];
    self.scanFrameView.center = self.view.center;
    self.scanFrameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scanFrameView];
    self.scanFrameView.layer.cornerRadius = 5;
    self.scanFrameView.layer.masksToBounds = YES;
    self.scanFrameView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.scanFrameView.layer.borderWidth = 10;
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button setTitle:@"扫描" forState:UIControlStateNormal];
    self.button.tintColor = [UIColor whiteColor];
    self.button.frame = CGRectMake(50, self.view.bounds.size.height-100, 100, 50);
    self.button.backgroundColor = [UIColor orangeColor];
    self.button.layer.cornerRadius = 5;
    self.button.layer.masksToBounds = YES;
    [self.view addSubview:self.button];
    [self.button addTarget:self action:@selector(startScanner:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.lightButton setTitle:@"打开照明" forState:UIControlStateNormal];
    self.lightButton.tintColor = [UIColor whiteColor];
    self.lightButton.frame = CGRectMake(self.view.bounds.size.width-50-100, self.view.bounds.size.height-100, 100, 50);
    self.lightButton.backgroundColor = [UIColor orangeColor];
    self.lightButton.layer.cornerRadius = 5;
    self.lightButton.layer.masksToBounds = YES;
    [self.view addSubview:self.lightButton];
    [self.lightButton addTarget:self action:@selector(openSystemLight:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    _lastResut = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)startReading
{
    [_button setTitle:@"停止" forState:UIControlStateNormal];
    // 获取 AVCaptureDevice 实例
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // 添加输出流
    [_captureSession addOutput:captureMetadataOutput];
    
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 设置元数据类型 设备二维码和条形码
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code ,nil]];
    
    // 创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_scanFrameView.layer.bounds];
    [_scanFrameView.layer addSublayer:_videoPreviewLayer];
    // 开始会话
    [_captureSession startRunning];
    
    return YES;
}

- (void)stopReading
{
    [_button setTitle:@"扫描" forState:UIControlStateNormal];
    // 停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
}

- (void)reportScanResult:(NSString *)result
{
    [self stopReading];
    if (!_lastResut) {
        return;
    }
    _lastResut = NO;
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"扫描结果" message:result preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 发布通知进行回传值
        //通知中心
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        //发送通知
        [center postNotificationName:@"DVScanCodeSuccess" object:nil userInfo:@{@"deviceNO":result}];
        // 以及处理了结果，下次扫描
        _lastResut = YES;
        //关闭页面
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
    
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)systemLightSwitch:(BOOL)open {
    if (open) {
        [_lightButton setTitle:@"关闭照明" forState:UIControlStateNormal];
    } else {
        [_lightButton setTitle:@"打开照明" forState:UIControlStateNormal];
    }
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (open) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

#pragma AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
//        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
//        } else {
//            NSLog(@"不是二维码");
//        }
        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
    }
}

// 扫码按钮点击回调
- (void)startScanner:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"扫描"]) {
        [self startReading];
    } else {
        [self stopReading];
    }
}

// 开灯按钮点击回调
- (void)openSystemLight:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"打开照明"]) {
        [self systemLightSwitch:YES];
    } else {
        [self systemLightSwitch:NO];
    }
}


@end
