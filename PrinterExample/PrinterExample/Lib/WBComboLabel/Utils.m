//
//  Utils.m
//  falconEyes
//
//  Created by  Andrew Huang on 14-9-12.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "Utils.h"

#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation Utils

+(void)addViewRound:(UIView*)view{
    
//    view.layer.borderColor = [UIColor blackColor].CGColor;
//    
//    view.layer.borderWidth =1.0;
//    
//    view.layer.cornerRadius =5.0;
//    
//    [view.layer setMasksToBounds:YES];
    
    [ Utils addViewRound:view color:[UIColor blackColor]];
    
}

+(void)addViewRound:(UIView*)view color:(UIColor*)color{
    
    view.layer.borderColor = color.CGColor;
    
    view.layer.borderWidth =2.0;
    
    view.layer.cornerRadius =5.0;
    
    [view.layer setMasksToBounds:YES];
    
}

+(void)showDataHex:(Byte *)bytes len:(int)len label:(NSString *)label{
    
    NSMutableString * line =  [ NSMutableString stringWithFormat:@" %@[%d]={",label,len];
    
    
    for(int i=0;i<len;i++) {
        
        
        [line appendFormat:@" %02X",bytes[i]&0xff];
        
    }
    
    [line appendFormat:@"};"];
    
    NSLog(line);

}

+(void)showHexString:(NSData *)data label:(NSString *)label{
    Byte *bytes = (Byte *)[data bytes];
    
    [self showDataHex:bytes len:[data length] label:label];
}



+(NSString *) currentWifiSSID
{
#if TARGET_IPHONE_SIMULATOR
    return @"simulator";
#else
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *ssid = [dctySSID objectForKey:@"SSID"] ;
    
    return ssid;
#endif
    
}

+(void)addBackgourd:(UIView *)view imageName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    view.layer.contents = (id) image.CGImage;
    // 如果需要背景透明加上下面这句
    view.layer.backgroundColor = [UIColor clearColor].CGColor;
}

+ (void)hideNavBar:(UIViewController*)viewController{
    
    
    UINavigationBar * navbar = NULL;
    UITabBar *tabBar = viewController.tabBarController.tabBar;
    
    
    if( (viewController.navigationController.navigationBar != NULL) ||
       (viewController.navigationController.navigationBar != NULL) )
        navbar = viewController.navigationController.navigationBar;
    else
        return ;
    
    //内容显示区
    UIView *contentView;
    
    if ( [[viewController.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [viewController.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [viewController.tabBarController.view.subviews objectAtIndex:0];
    
    
    if(navbar.hidden == NO)
    {
        
        
        [ contentView setFrame:CGRectMake(contentView.bounds.origin.x,contentView.bounds.origin.y,
                                          contentView.bounds.size.width, contentView.bounds.size.height +
                                          tabBar.frame.size.height)];
        
        
        [ navbar setHidden:YES ];
        
    }
    else {
        
        
        [contentView setFrame:CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,
                                         contentView.bounds.size.width, contentView.bounds.size.height - navbar.frame.size.height)];
        
        
        [ navbar setHidden:NO ];
    }
}

+ (void)hideTabBar:(UIViewController*)viewController{
    
    if( (viewController.tabBarController == NULL) || (viewController.tabBarController.tabBar == NULL))
        return ;
    
    UINavigationBar * navbar = NULL;
    UITabBar *tabBar = viewController.tabBarController.tabBar;
    
    
    if( (viewController.navigationController.navigationBar != NULL) ||
       (viewController.navigationController.navigationBar != NULL) )
        navbar = viewController.navigationController.navigationBar;
    
    //内容显示区
    UIView *contentView;
    
    if ( [[viewController.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [viewController.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [viewController.tabBarController.view.subviews objectAtIndex:0];
    
    
    if(tabBar.hidden == NO)
    {
        
        
        [ contentView setFrame:CGRectMake(contentView.bounds.origin.x,contentView.bounds.origin.y,
                                          contentView.bounds.size.width, contentView.bounds.size.height +
                                          tabBar.frame.size.height)];
        
        [ tabBar setHidden:YES ];
        [ navbar setHidden:YES ];
        
    }
    else {
        
        
        [contentView setFrame:CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - tabBar.frame.size.height)];
        
        [ tabBar setHidden:NO ];
        [ navbar setHidden:NO ];
    }
    
    
    
    
}


+(void)openSystemSetting:(NSString *)settingName{
    //iOS8 才有效
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
#define SETTING_URL @"app-settings:"
#else
#define SETTING_URL   UIApplicationOpenSettingsURLString
#endif
    
    //  NSLog(UIApplicationOpenSettingsURLString);
    if (version >= 8.0){
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:SETTING_URL]];
    }
}

+(NSLayoutConstraint *) findFirstConstraint:(UIView *)parentView firstItem:(id)firstItem  attribute:(NSLayoutAttribute)attribute{
    
 
    
    for (NSLayoutConstraint *constraint in parentView.constraints) {
       
      //    NSLog(@"findConstraint firstItem constant %f,first firstAttribute %d,priority %f,%@",constraint.constant,constraint.firstAttribute, constraint.priority, constraint.firstItem);
        if((constraint.firstItem == firstItem) && (constraint.firstAttribute == attribute)){
            NSLog(@"find! %@",firstItem);
            return constraint;
        }
    }
    

    
    return nil;
    
}

+(NSLayoutConstraint *) findSecondConstraint:(UIView *)parentView secondItem:(id)secondItem  attribute:(NSLayoutAttribute)attribute
{
    for (NSLayoutConstraint *constraint in parentView.constraints) {
        //if(constraint.firstItem == firstItem)
       NSLog(@"findConstraint secondItem constant %f,type %d,priority %f,%@,------ %@ firstAttrib %d",constraint.constant,constraint.secondAttribute, constraint.priority, constraint.secondItem,constraint.firstItem,constraint.firstAttribute);
        if((constraint.secondItem == secondItem) && (constraint.secondAttribute == attribute)){
            NSLog(@"find! %@",secondItem);
            return constraint;
        }
    }
    
    
    
    return nil;
}


+ (NSString*)getPreferredLanguage
{
    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
//    
//    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *preferredLang = [languages objectAtIndex:0];
   
    
    NSLog(@"当前语言:%@", preferredLang);
    
    return preferredLang;
    
}


@end
