//
//  ViewController.m
//  ZHJJQNUPLoad
//
//  Created by 张建军 on 16/10/18.
//  Copyright © 2016年 张建军. All rights reserved.
//

#import "ViewController.h"
#import "ZHJJQNUploadManager.h"
#import "QNUrlSafeBase64.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "QN_GTM_Base64.h"
#import "QiniuSDK.h"
#import "UIButton+WebCache.h"
@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) UIImage *pickImage;
@property(nonatomic,strong)UIButton * button3 ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    // 添加观察者
    [center addObserver:self selector:@selector(notice:) name:@"downLoad" object:nil];
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
    UIButton * button  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    [button setTitle:@"选择图片" forState:(UIControlStateNormal)];
    
    button.frame = CGRectMake(100, 100, 100, 30);
    
    [button addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    button.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:button];
    
    UIButton * button1  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
   [button1 setTitle:@"开始上传" forState:(UIControlStateNormal)];
    button1.backgroundColor = [UIColor blueColor];
    
    button1.frame = CGRectMake(100, 200, 100, 30);
    
    [button1 addTarget:self action:@selector(buttonAction1) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:button1];
    
    
    self.button3  = [UIButton buttonWithType:(UIButtonTypeCustom)];

    
    //    button3.backgroundColor = [UIColor blueColor];
    
    [self.button3 addTarget:self action:@selector(button3Action) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.button3.frame = CGRectMake(100, 300, 100, 130);
    
    
    
    [self.view addSubview:self.button3];

  

}
// 选择
-(void)buttonAction{
    
    
    [self gotoImageLibrary];
    
}


-(void)buttonAction1{
    
    if (self.pickImage == nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"还未选择图片"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
    } else {
//        [self uploadImageToQNFilePath:[self getImagePath:self.pickImage]];
        
        [[ZHJJQNUploadManager sharedInstance] uploadImageToQNFilePath:[self getImagePath:self.pickImage]];
    }
    
}


-(void)notice:(NSNotification *)sender {
    
    NSLog(@"这个是传过来的值%@",sender);

 // 正确的接受消息的方法-------注意哈·~
    NSDictionary *sDict = [[NSDictionary alloc] init];
    sDict = sender.userInfo;

    NSLog(@"这个是传递的字典%@",sDict);

    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://of897578a.bkt.clouddn.com/%@",[sDict objectForKey:@"hash"]]];
    [self.button3 sd_setImageWithURL:url forState:UIControlStateNormal];
}

-(void)button3Action{
   
    
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"大哥" message:@"别点了，疼~~~" delegate:self cancelButtonTitle:@"好哒" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)uploadImageToQNFilePath:(NSString *)filePath {
    
    
    self.token = [ZHJJQNUploadManager sharedInstance].uploadToken;
    
    NSLog(@"=======%@",self.token);
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption * uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putFile:filePath key:nil token:self.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://of897578a.bkt.clouddn.com/%@",[resp objectForKey:@"hash"]]];
        
        [self.button3 sd_setImageWithURL:url forState:UIControlStateNormal];
        
    }
                option:uploadOption];
}

- (void)gotoImageLibrary {
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"访问图片库错误"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
    }
}

//再调用以下委托：
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    self.pickImage = image; //imageView为自己定义的UIImageView
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image {
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/theFirstImage.png"];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
