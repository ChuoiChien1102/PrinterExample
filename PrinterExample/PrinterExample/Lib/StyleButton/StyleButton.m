//
//  StyleButton.m
//  RTPrinter
//
//  Created by PRO on 15/12/2.
//  Copyright © 2015年 bluedrum. All rights reserved.
//

#import "StyleButton.h"
#import "Style.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"

@interface StyleButton(){
    BOOL _isLayout ;
}

@end

@implementation StyleButton

-(void)commonInit:(CGRect)frame{
    
    
    
//    self.layer.borderColor = [[UIColor grayColor] CGColor];
//    self.layer.borderWidth =1.0;
//    self.layer.cornerRadius = 8.0f;
//    self.layer.masksToBounds = YES;
    
    NSLog(@"style %@,%d",_style,_isVerticalLayout);
    _isLayout = NO;
}


- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit:frame];
    }
    return self;
}

-(id)initWithCoder:(NSCoder*)coder{
    
    
    if ((self = [super initWithCoder:coder])){
        [self commonInit:self.frame];
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // NSLog(@"style2 %@,%d",_style,_isVerticalLayout);
    
    if(self.style == nil)
        return ;
    
    if([self.style isEqualToString:@"vertical"])
    {
        
        int vh = self.bounds.size.height ;
        
#define VB_LINE_PADDING  0
        
        float marginTop  = (vh - self.imageView.frame.size.height - VB_LINE_PADDING - self.titleLabel.frame.size.height)/2.0f;
        
        if(marginTop < 0)
            marginTop  = 0;
        
        
        
        CGRect frame = self.imageView.frame;
        frame = CGRectMake(truncf((self.bounds.size.width - frame.size.width) / 2), marginTop, frame.size.width, frame.size.height);
        self.imageView.frame = frame;
        
        frame = self.titleLabel.frame;
        frame = CGRectMake(0, marginTop + VB_LINE_PADDING + self.imageView.frame.size.height, self.bounds.size.width, frame.size.height);
        
        
        
        self.titleLabel.frame = frame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [ self setBackgroundColor:[ UIColor clearColor]];
    }
    
     if(_isLayout)
         return ;
         
         _isLayout = YES;
    
   
       // _isVerticalLayout = YES;
        if([self.style isEqualToString:@"blue3d"]){
            
            self.buttonColor = FLAT_BLUE_COLOR;
            self.shadowColor = FLAT_DEEP_BLUE_COLOR;
            self.shadowHeight = 3.0f;
            self.cornerRadius = 6.0f;
            self.titleLabel.font = [UIFont boldFlatFontOfSize:16];
            [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

            
        }
    
     else if([self.style isEqualToString:@"blue"]){
         
         self.buttonColor = FLAT_BLUE_COLOR;
         self.shadowColor = [UIColor clearColor];
         self.shadowHeight = 0.0f;
         self.cornerRadius = 6.0f;
         self.titleLabel.font = [UIFont boldFlatFontOfSize:16];
         [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
         [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

     
         
     }
        else if([self.style isEqualToString:@"clear"]){
            
            self.buttonColor = [UIColor whiteColor];
            
            [self setTitleColor:FLAT_BLUE_COLOR forState:UIControlStateNormal];
            [self setTitleColor:FLAT_BLUE_COLOR forState:UIControlStateHighlighted];
        
            
        }
        else if([self.style isEqualToString:@"white"]){
            
            self.buttonColor = [UIColor clearColor];
            self.shadowHeight = 0.0f;
            self.cornerRadius = 6.0f;
            self.layer.borderColor = [[UIColor carrotColor] CGColor];
            self.layer.borderWidth =1.0;
            self.layer.cornerRadius = 4.0f;
            self.layer.masksToBounds = YES;
            [self setTitleColor:[UIColor carrotColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor carrotColor] forState:UIControlStateHighlighted];
            
            
        }
        else if([self.style isEqualToString:@"green"]){
            
            self.buttonColor = FLAT_GREEN_COLOR;
            self.shadowColor = [UIColor clearColor];
            self.shadowHeight = 0.0f;
            self.cornerRadius = 6.0f;
            self.titleLabel.font = [UIFont boldFlatFontOfSize:16];
            [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

         
            
        }
        else if([self.style isEqualToString:@"yellow"]){
            
            self.buttonColor = FLAT_YELLOW_COLOR;
            self.shadowColor = [UIColor clearColor];
            self.shadowHeight = 0.0f;
            self.cornerRadius = 6.0f;
            self.titleLabel.font = [UIFont boldFlatFontOfSize:16];
            [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
            
            
            
        }
        else  if([self.style isEqualToString:@"green3d"]){
            
            self.buttonColor = FLAT_GREEN_COLOR;
            self.shadowColor = FLAT_DEEP_GREEN_COLOR;
            self.shadowHeight = 3.0f;
            self.cornerRadius = 6.0f;
            self.titleLabel.font = [UIFont boldFlatFontOfSize:16];
            [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
            
            
        }

    
    
        return ;

   
   
    
    
  
}

@end
