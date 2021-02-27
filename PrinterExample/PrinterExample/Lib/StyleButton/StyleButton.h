//
//  StyleButton.h
//  RTPrinter
//
//  Created by PRO on 15/12/2.
//  Copyright © 2015年 bluedrum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"

@interface StyleButton : FUIButton

@property (nonatomic,retain) NSString * style; //由Storyboard User Defined Runtime Attributes 来直接赋值
@property (nonatomic) BOOL isVerticalLayout; //图片与标签垂直布局


@end
