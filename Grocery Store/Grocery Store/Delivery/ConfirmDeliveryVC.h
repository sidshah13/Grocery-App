//
//  ConfirmDeliveryVC.h
//  Grocery Store
//
//  Created by subhashsanghani on 8/2/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface ConfirmDeliveryVC : BaseVC
{
    IBOutlet UILabel *lbl_date_time, *lbl_receiver_name, *lbl_receiver_mobile, *lbl_pincode, *lbl_house_no, *lbl_socity, *lbl_total_item, *lbl_amount, *lbl_delivery_charge, *lbl_total_amount;
    
    IBOutlet UIView *frame1, *frame2, *frame3;
    
}
@end
