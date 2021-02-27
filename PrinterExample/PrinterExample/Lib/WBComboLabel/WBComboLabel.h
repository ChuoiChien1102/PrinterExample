//
//  ComoLabel.h
//  RTPrinter
//
//  Created by PRO on 15/12/6.
//  Copyright © 2015年 bluedrum. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBComboLabel;

@protocol WBComboLabelDelegate <NSObject>

@optional
-(void)WBComboValueChanged:(WBComboLabel *)sender;

@end

@interface WBComboLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, strong) NSString * plistName;
@property (nonatomic, strong) NSString * plistTitle;
@property (nonatomic, strong) NSString * typeName;
@property (nonatomic, strong) NSString * value;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) BOOL useIndex; //== YES,表示取下标值,否则取显示值
@property (nonatomic,strong) NSArray *plistArray;

@property(nonatomic,weak) id<WBComboLabelDelegate> delegate;

-(void)setValueArray:(NSArray *)array;
-(void)setValue:(NSString*)val;
-(void)reflush;


@end
