//
//  CartCell.h
//  Rabbit
//
//  Created by subhashsanghani on 2/4/17.
//  Copyright © 2017 Rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "API_Settings.h"
#import "LocalizationSystem.h"
@protocol CartCellDelegate;
@interface CartCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblProductTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblProductPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblProductTotal;
@property (strong, nonatomic) IBOutlet UIButton *btnIncrease;
@property (strong, nonatomic) IBOutlet UIButton *btnDecrease;
@property (strong, nonatomic) IBOutlet UILabel *lblQty;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet AsyncImageView *imageview;
@property (assign, nonatomic) double product_price;
@property (assign, nonatomic) float qty;
@property (retain, nonatomic) NSMutableDictionary *product_desc;
-(void)updateUI;
-(void)lblTotalSet:(float)intQty;

@property (nonatomic, assign) id<CartCellDelegate> delegate;
@end

@protocol CartCellDelegate <NSObject>
-(void) addToCartTap:(CartCell*) sender cartitem:(NSDictionary*)cartitem;
@end
