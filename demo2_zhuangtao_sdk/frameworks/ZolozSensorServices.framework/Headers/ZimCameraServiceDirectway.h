//
//  ZimCameraServiceDirectway.h
//  ZolozSensorServices
//
//  Created by sanyuan.he on 2020/2/25.
//  Copyright © 2020 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>

NS_ASSUME_NONNULL_BEGIN
#define ZIM_PLATFORM_SETTING_INFO_ALIYUN @"aliyun"
#define ZIM_PLATFORM_SETTING_INFO_ALITECH @"alitech"
@interface ZimCameraServiceDirectway : NSObject

@property(nonatomic , assign)UIDeviceOrientation orientation ;
@property(nonatomic , strong)NSString *forceDirection;
@property(nonatomic , assign)BOOL returnContent;
@property(nonatomic , strong ,nullable)NSData *imageContent;
@property(nonatomic , strong ,nullable) NSString*platformInfo;
+ (ZimCameraServiceDirectway *)sharedInstance;
@end

NS_ASSUME_NONNULL_END
