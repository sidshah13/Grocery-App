//
//  OrderDetailsVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 8/1/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "OrderDetailsCell.h"
@interface OrderDetailsVC ()
{
    NSMutableArray *dataArray;
}
@end

@implementation OrderDetailsVC
@synthesize dictOrder;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = AMLocalizedString(@"Order Details", nil);
    // Do any additional setup after loading the view.
    lblDate.text = [NSString stringWithFormat:@"%@ :%@",AMLocalizedString(@"Date", nil), [dictOrder valueForKey:@"on_date"]];
    lblTotal.text = [NSString stringWithFormat:@"%@ : %@ %@",AMLocalizedString(@"Total", nil), [dictOrder valueForKey:@"total_amount"], AMLocalizedString(CURRENCY, nil)];
    lblTime.text = [NSString stringWithFormat:@"%@ : %@",AMLocalizedString(@"Time", nil), [dictOrder valueForKey:@"delivery_time_from"]];
    lblDeliveryCharge.text = [NSString stringWithFormat:@"%@ : %@",AMLocalizedString(@"Delivery Charges", nil), [dictOrder valueForKey:@"delivery_charge"]];
    
    [self getDetails];
    [btnCancelOrder setHidden:true];
    
    if ([[dictOrder valueForKey:@"status"] integerValue] == 0) {
        [btnCancelOrder setHidden:false];
    }
    
}
- (IBAction)cancelOrderClick:(id)sender{
    
    NSDictionary *dictParams = nil;
    NSString *url;
    
    dictParams =  @{
                    @"sale_id": [dictOrder valueForKey:@"sale_id"],
                    @"user_id": [app.dictUser valueForKey:@"user_id"]
                    };
    url = [self getStringURLForAPI:URL_API_CANCLE_ORDER];
    [self postResponseFromURL:url withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
           [btnCancelOrder setHidden:true];
           [self showAlertForTitle:@"Canceled" withMessage:@"Your order canceled successfully"];
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getDetails{
    
    NSDictionary *dictParams = @{
                                 @"sale_id": [dictOrder valueForKey:@"sale_id"]
                                 };
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_ORDER_DETAILS] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        //if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
        dataArray = [[NSMutableArray alloc] initWithArray:responseObject];
        
        [tableview reloadData];
        //}
        //else{
        //    [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        //}
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderDetailsCell *cell;
    
        cell= [tableView dequeueReusableCellWithIdentifier:@"OrderDetailsCell"];
   
    
    
    NSMutableDictionary *dict = [dataArray objectAtIndex:indexPath.row];
   
    
    cell.lblProductTitle.text =  [dict valueForKey:@"product_name"];
    
    
    cell.lblProductPrice.text = [NSString stringWithFormat:@"%@ %@:%@ %@", AMLocalizedString(@"Price per", nil), [dict valueForKey:@"unit"], [dict valueForKey:@"price"], AMLocalizedString(CURRENCY, nil)];
    
   
    cell.lblQty.text = [NSString stringWithFormat:@"%@ : %@",AMLocalizedString(@"Qty", nil),[dict valueForKey:@"qty"]];
    
    cell.imageview.clipsToBounds = YES;
    cell.imageview.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageview.imageURL =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", URL_API_HOST_BASE, PRO_IMAGE_SMALL_PATH,[dict valueForKey:@"product_image"]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray!=nil) {
        return dataArray.count;
    }
    return 0;
}
@end
