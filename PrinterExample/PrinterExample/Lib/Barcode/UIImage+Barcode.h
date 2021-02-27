//
//  UIImage+Barcode.h
//  RTPrinter
//
//  Created by PRO on 15/12/3.
//  Copyright © 2015年 bluedrum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumTypeDef.h"

@interface UIImage(Barcode)




//Code138条码
+(UIImage *)generateBarCode:(NSString *)code  width:(CGFloat)width height:(CGFloat)height;
+(UIImage *)generateBarCode:(NSString *)code  frame:(CGRect)frame;
+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;

+(UIImage *)generateQRCode:(NSString *)code frame:(CGRect)frame;
+(UIImage *)generateBarCode:(NSString *)code  barcodeType:(BarcodeType)barcodeType frame:(CGRect)frame barcode:(NSString **)barcode;

@end
