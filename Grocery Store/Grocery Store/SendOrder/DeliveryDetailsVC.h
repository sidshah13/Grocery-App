//
//  DeliveryDetailsVC.h
//  Grocery Store
//
//  Created by subhashsanghani on 7/31/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface DeliveryDetailsVC : BaseVC<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *tableview;
}
@property (strong, nonatomic) IBOutlet UIButton *btn_choose_date;
@property (strong, nonatomic) IBOutlet UIButton *btn_choose_time;
@property (strong, nonatomic) IBOutlet UIButton *btn_add;
@property (strong, nonatomic) IBOutlet UILabel *lblDeliveryCharge;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalCharges;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalItems;
@end
