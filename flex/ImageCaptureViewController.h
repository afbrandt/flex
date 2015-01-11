//
//  ImageCaptureViewController.h
//  flex
//
//  Created by Andrew Brandt on 1/10/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface ImageCaptureViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;

@end
