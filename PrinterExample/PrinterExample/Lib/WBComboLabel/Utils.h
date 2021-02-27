//
//  Utils.h
//  falconEyes
//
//  Created by  Andrew Huang on 14-9-12.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>


#define UIKitLocalizedString(key) [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] localizedStringForKey:key value:@"" table:nil]

#define WB_LOCAL_SERACH UIKitLocalizedString(@"Search")
#define WB_LOCAL_DONE UIKitLocalizedString(@"Done")
#define WB_LOCAL_CANCEL UIKitLocalizedString(@"Cancel")
#define WB_LOCAL_OK UIKitLocalizedString(@"OK")

@interface Utils : NSObject

+(void)addViewRound:(UIView*)view;

+(void)addViewRound:(UIView*)view color:(UIColor*)color;

+(void)showHexString:(NSData *)data label:(NSString *)label;

+(void)showDataHex:(Byte *)bytes len:(int)len label:(NSString *)label;

+(NSString *)currentWifiSSID;

+ (void)hideTabBar:(UIViewController*)viewController;
+ (void)hideNavBar:(UIViewController*)viewController;
/*
 自动将图片平辅到View 上
 */
+(void)addBackgourd:(UIView *)view imageName:(NSString *)imageName;

+(void)openSystemSetting:(NSString *)settingName;

//parentView 包含布局变量容量类， firstItem 布局变量约束类,attribute 布局变量类型
+(NSLayoutConstraint *) findFirstConstraint:(id)parentView firstItem:(id)firstItem  attribute:(NSLayoutAttribute)attribute;

+(NSLayoutConstraint *) findSecondConstraint:(UIView *)parentView secondItem:(id)firstItem  attribute:(NSLayoutAttribute)attribute;

+ (NSString*)getPreferredLanguage;
@end
