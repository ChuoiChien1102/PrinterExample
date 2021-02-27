//
//  UIImage+Barcode.m
//  RTPrinter
//
//  Created by PRO on 15/12/3.
//  Copyright © 2015年 bluedrum. All rights reserved.
//

#import "UIImage+Barcode.h"
#import "NKDBarcodeFramework.h"



@implementation UIImage(Barcode)

+ (UIImage *)generateBarCode:(NSString *)code  width:(CGFloat)width height:(CGFloat)height {
    
    // 生成条形码图片
    
    CIImage *barcodeImage;
    
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    
   CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
  

    
    
    
    [filter setValue:data forKey:@"inputMessage"];
    
    barcodeImage = [filter outputImage];
    
    
    
    // 消除模糊
    
    CGFloat scaleX = width / barcodeImage.extent.size.width; // extent 返回图片的frame
    
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    
    
    return [UIImage imageWithCIImage:transformedImage];
    
}

+(UIImage *)generateBarCode:(NSString *)code  frame:(CGRect)frame{
    return [self generateBarCode:code  width:frame.size.width height:frame.size.height];
}



+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    
    
    // 生成二维码图片
    
    CIImage *qrcodeImage;
    
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    
    
    [filter setValue:data forKey:@"inputMessage"];
    
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    qrcodeImage = [filter outputImage];
    
    
    
    // 消除模糊
    
    CGFloat scaleX = width / qrcodeImage.extent.size.width; // extent 返回图片的frame
    
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    
    
    return [UIImage imageWithCIImage:transformedImage];
    
}

+(UIImage *)generateQRCode:(NSString *)code frame:(CGRect)frame{
    return [self generateQRCode:code width:frame.size.width height:frame.size.height];
}


+(UIImage *)generateBarCode:(NSString *)code  barcodeType:(BarcodeType)barcodeType frame:(CGRect)frame barcode:(NSString **)barcode{
    
    //NSLog(@"generateBarCode %x:%@",barcodeType,code);
    NKDBarcode * ndkBarcode;
    switch(barcodeType){
        case  BarcodeTypeUPC_A:
            ndkBarcode = (NKDBarcode*)[[NKDUPCABarcode alloc] initWithContent:code printsCaption:NO];
            break ;
        case BarcodeTypeUPC_E:
            ndkBarcode = [[NKDUPCEBarcode alloc] initWithContent:code  ];
            break ;
        case   BarcodeTypeEAN13:
            ndkBarcode = [[NKDEAN13Barcode alloc] initWithContent:code  ];
            break ;
        case   BarcodeTypeEAN8:
            ndkBarcode = [[NKDEAN8Barcode alloc] initWithContent:code  ];
            break ;
        case   BarcodeTypeCODE39:
            ndkBarcode = [[NKDCode39Barcode alloc] initWithContent:code  ];
            break ;
        case  BarcodeTypeITF:    
            ndkBarcode = [[NKDInterleavedTwoOfFiveBarcode alloc] initWithContent:code  ];
            break ;
        case   BarcodeTypeCODABAR:
            ndkBarcode = [[NKDCodabarBarcode alloc] initWithContent:code];
            break ;
        case   BarcodeTypeCODE128:
            ndkBarcode = [[NKDCode128Barcode alloc] initWithContent:code];
            break;
        case BarcodeTypeQrcode:
            *barcode = code;
            return [self generateQRCode:code width:frame.size.width height:frame.size.height];
            break ;
            
    }
    
    if(![ndkBarcode isContentValid])
        return nil;
    *barcode = [ndkBarcode completeContent];
    return [UIImage imageFromBarcode:ndkBarcode inRect:frame];
}

@end
