//
//  ViewController.h
//  Prime Print x-callback-url Sample
//
//  Created by komatsu on 2014/04/14.
//  Copyright (c) 2014 iWare inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)pushPrint:(id)sender;
- (IBAction)pushImagePicker:(id)sender;

@end
