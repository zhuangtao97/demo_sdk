//
//  ViewController.m
//  FaceDetectDemo
//
//  Created by richard on 14/10/2017.
//  Copyright © 2017 com.alipay.faceDetect. All rights reserved.
//

#import "ViewController.h"
#import <AliyunIdentityManager/AliyunIdentityPublicApi.h>
#import <AliyunIdentityManager/PoPGatewayNetwork.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AliyunIdentityManager/OATechGatewayNetwork.h>
#import <CommonCrypto/CommonDigest.h>

@interface ViewController ()< UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIDocumentInteractionControllerDelegate>
{

    NSString  *certifyId;
    UIButton *_submitInfo; //开始认证的Button

}
@property(nonatomic,strong)NSData * imageContentData;

@end


@implementation ViewController

//不支持动态切换横竖屏。
- (BOOL)shouldAutorotate{
    return NO;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [AliyunSdk init];
    
    self.view.backgroundColor = UIColor.whiteColor;

    certifyId = @"b813fc1df4dbc5096506c2cbb8e5b0bed";
    UILabel *initLabelDesc = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 200, 30)];
    initLabelDesc.text = @"认证";
    initLabelDesc.font = [UIFont systemFontOfSize:15];
    initLabelDesc.textColor = [UIColor blueColor];
    [self.view addSubview:initLabelDesc];

    UIView *seperateView = [[UIView alloc] initWithFrame:CGRectMake(20, initLabelDesc.frame.size.height + initLabelDesc.frame.origin.y, self.view.frame.size.width - 40, 1)];
    seperateView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:seperateView];
    //获取certifyId.
    
    UIButton *certifyIdInfoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [certifyIdInfoButton setFrame:CGRectMake((self.view.frame.size.width - 140)/2, seperateView.frame.origin.y + seperateView.frame.size.height + 10, 140, 20)];
    [certifyIdInfoButton setTitle:@"开始刷脸" forState:UIControlStateNormal];
    certifyIdInfoButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:certifyIdInfoButton];
    _submitInfo = certifyIdInfoButton;
    
    //主要代码在submitInfoForAliTech里面。
    [certifyIdInfoButton addTarget:self action:@selector(submitInfoForAliTech) forControlEvents:UIControlEventTouchUpInside];

    
    //SDK初始化，这个函数应该尽可能早调用。
    
}



#pragma mark - 提交认证请求

- (void)submitInfoForAliTech {
    
    [self resisnFirstRespond];
    //要获取到certifyId后，才可以调用这个函数
    
    if ([certifyId length]<1) {
        [self alertInfomation:@"还未获取到certifyId"];
        return;
    }
    certifyId = @"b813fc1df4dbc5096506c2cbb8e5b0bed";
    [_submitInfo setUserInteractionEnabled:NO];
    __weak ViewController*weakSelf = self;
    NSMutableDictionary  *extParams = [NSMutableDictionary new];
    [extParams setValue:self forKey:@"currentCtr"];
    
    [[AliyunIdentityManager sharedInstance] verifyWith:certifyId extParams:extParams onCompletion:^(ZIMResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageContentData = response.imageContent;
               NSString *title = @"刷脸成功";
               switch (response.code) {
                   case 1000:
                       break;
                   case 1003:
                       title = @"用户退出";
                       break;
                   case 2002:
                       title = @"网络错误";
                       break;
                   case 2006:
                       title = @"刷脸失败";
                       break;
                    case 2003:
                       title = @"设备时间不准确";
                       break;
                   default:
                       break;
               }
                [weakSelf alertInfomation:title withMsg:response.retMessageSub];
                [_submitInfo setUserInteractionEnabled:YES];
            });
        }];
}

#pragma mark - 辅助方法
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


 - (NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData {
     if (jsonData == nil) {
         return nil;
     }
     //NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
     NSError *err;
     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
     if(err) {
         NSLog(@"json解析失败：%@",err);
         return nil;
     }
     return dic;
 }


- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resisnFirstRespond];
}
- (void)resisnFirstRespond {
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertInfomation:(NSString*)title{
    [self alertInfomation:@"" withMsg:title];
}

-(void)alertInfomation:(NSString*)title withMsg:(NSString*)msg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end


