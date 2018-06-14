//
//  ConfirmDeliveryVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 8/2/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "ConfirmDeliveryVC.h"
#import "ThanksScreenVC.h"
@interface ConfirmDeliveryVC ()
{
    NSMutableDictionary *selected_location;
}
@end

@implementation ConfirmDeliveryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = AMLocalizedString(@"Confirm", nil);
    // Do any additional setup after loading the view.
    lbl_date_time.text = [NSString stringWithFormat:@"%@ - %@",[self getStringDateFormate:[[NSUserDefaults standardUserDefaults] valueForKey:@"selected_date"]],[[NSUserDefaults standardUserDefaults] valueForKey:@"selected_time"]];
    selected_location = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"selected_location"]];
    
    lbl_receiver_name.text = [NSString stringWithFormat:@"%@ : %@",AMLocalizedString(@"Receiver Name", nil),[selected_location valueForKey:@"receiver_name"]];
    lbl_receiver_mobile.text = [NSString stringWithFormat:@"%@ : %@",AMLocalizedString(@"Receiver Mobile No.", nil),[selected_location valueForKey:@"receiver_mobile"]];
    lbl_pincode.text = [NSString stringWithFormat:@"%@ : %@",AMLocalizedString(@"Pincode", nil),[selected_location valueForKey:@"pincode"]];
    lbl_house_no.text = [NSString stringWithFormat:@"%@ : %@",AMLocalizedString(@"House No.", nil),[selected_location valueForKey:@"house_no"]];
    lbl_socity.text = [NSString stringWithFormat:@"%@ : %@",AMLocalizedString(@"Socity", nil),[selected_location valueForKey:@"socity_name"]];
    
    lbl_total_item.text = [NSString stringWithFormat:@"%@ : %d",AMLocalizedString(@"Items", nil),[cart getCartItemCount]];
    lbl_amount.text = [NSString stringWithFormat:@"%@ : %.2f",AMLocalizedString(@"Amount", nil),[cart getCartTotal]];
    lbl_delivery_charge.text = [NSString stringWithFormat:@"%@ : %.2f",AMLocalizedString(@"Delivery Charges", nil),[[selected_location valueForKey:@"delivery_charge"] floatValue]];
    float delivery_charge = [[selected_location valueForKey:@"delivery_charge"] floatValue];
    float total_amount = [cart getCartTotal];
    
    lbl_total_amount.text = [NSString stringWithFormat:@"%@ : %.2f + %.2f = %.2f %@",AMLocalizedString(@"Total Amount", nil),total_amount,delivery_charge,total_amount + delivery_charge, AMLocalizedString(CURRENCY, nil)];
    
    [self setShadowView:frame1];
    [self setShadowView:frame2];
    [self setShadowView:frame3];
    
}
-(void)setShadowView:(UIView*)viewFrame{
    viewFrame.layer.masksToBounds = NO;
    viewFrame.layer.shadowColor = [UIColor blackColor].CGColor;
    viewFrame.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    viewFrame.layer.shadowOpacity = 0.5f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)btnSendOrderClick:(id)sender{
    BOOL isValidated = YES;
    NSString *strMessage=@"";
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"selected_date"] == nil)
    {
        isValidated = NO;
        strMessage = AMLocalizedString(@"Please Choose Delivery Date", @"");
    }
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"selected_time"] == nil)
    {
        isValidated = NO;
        strMessage = AMLocalizedString(@"Please Choose Delivery Time", @"");
    }
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"selected_location"] == nil)
    {
        isValidated = NO;
        strMessage = AMLocalizedString(@"Please Choose Delivery Location", @"");
    }
    
    if(isValidated){
        NSArray *info = [NSArray arrayWithArray:[cart getCartItems]];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[cart getCartItems]
                                                           options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSDictionary *dictParams = @{
                                     @"user_id": [app.dictUser valueForKey:@"user_id"],
                                     @"date" : [self getMySqlDateFormate:[[NSUserDefaults standardUserDefaults] valueForKey:@"selected_date"]],
                                     @"time" : [[NSUserDefaults standardUserDefaults] valueForKey:@"selected_time"],
                                     @"location" : [selected_location valueForKey:@"location_id"],
                                     @"data" : jsonString
                                     };
        
        [self postResponseFromURL:[self getStringURLForAPI:URL_API_ADD_ORDER] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
            if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
                
                [cart emptyCart];
                
                
                ThanksScreenVC *VC =
                [self.storyboard instantiateViewControllerWithIdentifier:@"ThanksScreenVC"];
                VC.appointment = [responseObject valueForKey:@"data"];
                
                [self.navigationController pushViewController:VC animated:true];
                
            }
            else{
                [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        } showLoader:YES hideLoader:YES];
    }else{
        [self showAlertForTitle:AMLocalizedString(@"Error!", nil) withMessage:AMLocalizedString(strMessage, nil)];
    }
    
}
@end
