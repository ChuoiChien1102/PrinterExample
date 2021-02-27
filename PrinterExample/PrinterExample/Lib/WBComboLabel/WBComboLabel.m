//
//  ComoLabel.m
//  RTPrinter
//
//  Created by PRO on 15/12/6.
//  Copyright © 2015年 bluedrum. All rights reserved.
//

#import "WBComboLabel.h"
#import "ZHPickView.h"
#import "NSString+FontAwesome.h"

@interface WBComboLabel()<ZHPickViewDelegate>{
       ZHPickView * _pickView;
    NSInteger _comboIndex;
    NSString * _currentText;
    
}

@end



@implementation WBComboLabel

-(IBAction)showPicker:(id)sender{
    [_pickView  show];
}

-(void)setTextValue:(NSString *)text{
    //FACaretDown
    //
    
    _currentText = text;
    
    [self setText:[NSString stringWithFormat:@"%@ %@",text,[NSString fontAwesomeIconStringForEnum:FAChevronCircleDown]]];
    
//    [self setText:[NSString stringWithFormat:@"%@ %@ ",text,[NSString fontAwesomeIconStringForEnum:FAChevronCircleDown]]];
}

-(void)commonInit:(CGRect)frame{
    
    self.userInteractionEnabled       = YES;
    UITapGestureRecognizer *tap = \
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(showPicker:)];
   // tap.minimumPressDuration          = 0.01f;
    [self addGestureRecognizer:tap];
    
    [self setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:16]];
   // [self setTextValue:@"1"];
    
    self.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth =1.0;
    self.layer.cornerRadius = 2.0f;
    self.layer.masksToBounds = YES;
    ZHPickView * pickView = nil;
     NSLog(@"name %@ title %@",self.plistName,self.plistTitle);
    if (self.plistName!=nil) {
        pickView = [[ZHPickView alloc] initPickviewWithPlistName:self.plistName isHaveNavControler:NO];
    } else if (self.plistArray.count>0) {
        pickView=[[ZHPickView alloc] initPickviewWithArray:self.plistArray isHaveNavControler:NO];
    } else {
        return;
    }
    
    [pickView setToolbackgroundColor:[UIColor whiteColor ] ];
    [pickView setTintColor:[UIColor blueColor ] ];
    [pickView setPickViewColer:[UIColor whiteColor ] ];
    [pickView setPickName:self.typeName];
    [pickView setDelegate:self];
   
    [pickView setPickTitle:_plistTitle];
    
    if (pickView.plistArray.count<=0) return;
    
    
    NSString * value = [pickView.plistArray objectAtIndex:self.currentIndex];
     [self setTextValue:value];
    
    [pickView.pickerView  selectRow:self.currentIndex inComponent:0 animated:YES];
    
    
    _pickView = pickView;
    
   // self.inputView = pickView;
    
    
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self commonInit:self.frame];
    
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self commonInit:self.frame];
    }
    return self;
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
 
    _comboIndex = currentIndex;
    _pickView.currentIndex = _comboIndex;
    NSString * value = [_pickView.plistArray objectAtIndex:_comboIndex];
    
    [self setTextValue:value];
    
}

-(NSInteger)currentIndex{
    return _comboIndex;
}


#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    //    UITableViewCell * cell=[self.tableView cellForRowAtIndexPath:_indexPath];
    //   cell.detailTextLabel.text=resultString;
  if([resultString isEqualToString:@""])
      return ;
      
    [self setTextValue:resultString];
    
    self.currentIndex = _pickView.currentIndex;
    
    [self.delegate WBComboValueChanged:self];
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

-(void)setValueArray:(NSArray *)array{
    if (_pickView!=nil) {
        _pickView.plistArray = array;
        [self setCurrentIndex:0];
    }
    self.plistArray=array;
}
-(void)reflush{
    [self commonInit:self.frame];
}
-(void)setValue:(NSString*)val
{
    
    if(val == nil)
        return ;
    
    if(_useIndex)
    {
        self.currentIndex = [val integerValue];
        return ;
    }
    NSInteger index = [_pickView.plistArray indexOfObject:val];
    
    if((index >=0) && (index < _pickView.plistArray.count))
      self.currentIndex = index;
}

-(NSString *)value{
    if(_useIndex)
        return [NSString stringWithFormat:@"%ld",self.currentIndex];
    else
       return _currentText;
}


@end
