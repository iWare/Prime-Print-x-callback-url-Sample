//
//  ViewController.m
//  Prime Print x-callback-url Sample
//
//  Created by komatsu on 2014/04/14.
//  Copyright (c) 2014 iWare inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)pushPrint:(id)sender
{
    if(self.imageView.image == nil) return;
    
    /* You can also set an URL, a plain text and an array of images. */
    [UIPasteboard generalPasteboard].image = self.imageView.image;
    //[UIPasteboard generalPasteboard].string = @"http://iwares.jp";
    //[UIPasteboard generalPasteboard].string = @"Test print";

    NSString *scheme = [self scheme];
    NSString *applicationName = [self applicationName];
    if(scheme && applicationName) {
        NSString *urlString = [NSString stringWithFormat:@"primeprint-x-callback-url://x-callback-url/clipboard-print?x-success=%@://x-callback-url&x-source=%@", scheme, applicationName];
        
        // append print parameter
        NSString *paramString = [urlString stringByAppendingString:[self printParameter]];
        
        NSString *escapedUrlString =
        (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                              (CFStringRef)paramString,
                                                                              NULL,
                                                                              (CFStringRef)@" !*'();@+$,%#[]",
                                                                              kCFStringEncodingUTF8 ));
        NSURL *url = [NSURL URLWithString:escapedUrlString];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSLog(@"Check info.plist (CFBundleURLSchemes)");
    }
}

- (IBAction)pushImagePicker:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)scheme
{
    NSString *result = nil;
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSArray *types = info[@"CFBundleURLTypes"];
    if(types.count) {
        NSDictionary *type = types[0];
        NSArray *schemes = type[@"CFBundleURLSchemes"];
        if(schemes.count) {
            result = schemes[0];
        }
    }
    
    return result;
}

- (NSString *)applicationName
{
    NSString *result = nil;
    result = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
    if(result == nil) {
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        result = [info objectForKey:@"CFBundleName"];
    }
    return result;
}

/*
    Print Parameter
    
    <key>       : <value>
    color       : color / monochrome
    orientation : portrait / landscape
    papersize   : a4, letter, a3, a5, b4, b5, legal, 3.5x5, 5x7, 4x6, 8x10
    media       : plain, fine, photo
    duplex      : off, long-edge, short-edge
    border      : normal, borderless
    copies      : 1 to 100
*/
- (NSString *)printParameter
{
    NSString *result = @"";
    
    NSString *color         = @"color";
    NSString *orientation   = @"portrait";
    NSString *paperSize     = @"a4";
    NSString *media         = @"plain";
    NSString *copies        = @"1";
    NSString *border        = @"normal";
    NSString *duplex        = @"long-edge";
    
    result = [NSString stringWithFormat:@"&color=%@&orientation=%@&papersize=%@&media=%@&copies=%@&border=%@&duplex=%@",
              color, orientation, paperSize, media, copies, border, duplex];
    
    return result;
}

@end
