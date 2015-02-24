//
//  ImageCaptureViewController.m
//  flex
//
//  Created by Andrew Brandt on 1/10/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import "ImageCaptureViewController.h"
#import "HistoryTableViewController.h"
#import "ProductHelper.h"

@interface ImageCaptureViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation ImageCaptureViewController

- (void)viewDidLoad {
    self.captureSession = [[AVCaptureSession alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureStarted) name:AVCaptureSessionDidStartRunningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureError) name:AVCaptureSessionErrorKey object:nil];
    
    self.context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    //configure camera input
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *camera;
    
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo] && [device position] == AVCaptureDevicePositionBack) {
            camera = device;
        }
    }

    NSError *error;
    AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:camera error:&error];
    
    if ([self.captureSession canAddInput:cameraInput]) {
        [self.captureSession addInput:cameraInput];
    }

    //configure two output, preview layer and metadata delegate
    AVCaptureMetadataOutput *scanner = [[AVCaptureMetadataOutput alloc] init];
    self.serialQueue = dispatch_queue_create("metadata-queue", DISPATCH_QUEUE_SERIAL);
    [scanner setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    NSArray *codex = [NSArray arrayWithObject:AVMetadataObjectTypeEAN13Code];
    
    if ([self.captureSession canAddOutput:scanner]) {
        [self.captureSession addOutput:scanner];
    }
    [scanner setMetadataObjectTypes:codex];
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    
}

- (IBAction)startImageCapture:(id)sender {
    CALayer *rootLayer = [self.view layer];
    [self.preview setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:self.preview];
    //blocking operation!
    [self.captureSession startRunning];
}

- (void)captureStarted {
    NSLog(@"capture started!");
}

- (void)captureError {
    NSLog(@"capture error");
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate method

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"Received metadata!");
    
    NSString *upc = nil;
    
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeEAN13Code]) {
            upc = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            [self.captureSession stopRunning];
            break;
        }
    }
    
    NSLog(@"%@",upc);
    //have to trim first character in upc
    NSRange range = NSMakeRange(0, 1);
    upc = [upc stringByReplacingCharactersInRange:range withString:@""];
    NSLog(@"trimmed upc: %@", upc);

    ProductHelper *helper = [ProductHelper sharedHelper];
    [helper processUPC:upc];
    helper.hasNewProduct = YES;
    
    UIView *from = self.tabBarController.selectedViewController.view;
    UIView *to = ((UIViewController *)self.tabBarController.viewControllers[1]).view;
    
    [UIView transitionFromView:from toView:to duration:0.5f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        if (finished) {
            self.tabBarController.selectedIndex = 1;
            [self.preview removeFromSuperlayer];
        }
    }];
}



@end
