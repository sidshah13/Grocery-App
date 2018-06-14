//
//  CartCell.m
//  Rabbit
//
//  Created by subhashsanghani on 2/4/17.
//  Copyright © 2017 Rabbit. All rights reserved.
//

#import "CartCell.h"
#import "BaseCart.h"
@implementation CartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_imageview.layer setCornerRadius:_imageview.layer.frame.size.height / 2];
    [_imageview.layer setBorderWidth:1.0];
    [_imageview.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    //_qty = 0;
    [_btnIncrease addTarget:self action:@selector(btnIncrease:) forControlEvents:UIControlEventTouchUpInside];
    [_btnDecrease addTarget:self action:@selector(btnDecrese:) forControlEvents:UIControlEventTouchUpInside];
    [_btnAdd addTarget:self action:@selector(btnAddCart:) forControlEvents:UIControlEventTouchUpInside];
    _btnAdd.layer.cornerRadius =_btnAdd.frame.size.height / 2;
    [self lblTotalSet:_qty];
    _lblQty.text = [NSString stringWithFormat:@"%.1f",_qty];
}
-(void)updateUI{
    [self lblTotalSet:_qty];
    _lblQty.text = [NSString stringWithFormat:@"%.1f",_qty];
}
-(IBAction)btnIncrease:(id)sender{
    _qty  =_qty + 1;
    _lblQty.text = [NSString stringWithFormat:@"%.1f",_qty];
    [self lblTotalSet:_qty];
}
-(IBAction)btnDecrese:(id)sender{
    if(_qty > 0){
        _qty  =_qty - 1;
        _lblQty.text = [NSString stringWithFormat:@"%.1f",_qty];
        [self lblTotalSet:_qty];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)lblTotalSet:(float)intQty{
    _lblProductTotal.text =   [NSString stringWithFormat:@"%@ : %.2f %@",AMLocalizedString(@"Total", nil),(_product_price * intQty),AMLocalizedString(CURRENCY, nil) ];
}
-(IBAction)btnAddCart:(id)sender{
    if (_qty > 0) {
        
        BaseCart *bc = [[BaseCart alloc] init];
        
        NSString *strQty = [NSString stringWithFormat:@"%.1f",_qty];
        _product_desc = [bc getCartItemAtIndex:(int)self.tag];
        
        NSDictionary *cartitem = @{
                                   @"product_id": [_product_desc valueForKey:@"product_id"],
                                   @"currency" : CURRENCY,
                                   @"price" : [_product_desc valueForKey:@"price"],
                                   @"product_name" : [_product_desc valueForKey:@"product_name"],
                                   @"product_image" : [_product_desc valueForKey:@"product_image"],
                                   @"title" : [_product_desc valueForKey:@"title"],
                                   @"unit" : [_product_desc valueForKey:@"unit"],
                                   @"unit_value" : [_product_desc valueForKey:@"unit_value"],
                                   @"qty" :strQty
                                   };
        _product_desc = [[NSMutableDictionary alloc] initWithDictionary:cartitem];
        [self.delegate addToCartTap:self cartitem:cartitem];
        
    }
}

@end
