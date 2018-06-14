//
//  DeliveryDetailsVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 7/31/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "DeliveryDetailsVC.h"
#import "CalenderVC.h"
#import "ChoosetimeVC.h"
#import "AddressCell.h"
#import "AddAddressVC.h"
#import "ConfirmDeliveryVC.h"
@interface DeliveryDetailsVC ()
{
    NSMutableDictionary *selected_location;
    NSMutableArray *addresses;
    float cart_total;
    
}
@end

@implementation DeliveryDetailsVC
@synthesize btn_choose_date, btn_choose_time, lblTotalCharges,lblDeliveryCharge, btn_add;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = AMLocalizedString(@"Delivery", nil);
    cart_total = [cart getCartTotal];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"selected_date"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"selected_time"];
    btn_choose_date.layer.cornerRadius = 4.0f;
    btn_choose_time.layer.cornerRadius = 4.0f;
    btn_add.layer.cornerRadius = 4.0f;
    [self getAddress];
}
-(void)updateTotal{
    lblTotalCharges.text = [NSString stringWithFormat:@"%@ : %.2f %@ + %@ %.2f %@",AMLocalizedString(@"Total", nil),cart_total,AMLocalizedString(CURRENCY, nil), AMLocalizedString(@"Delivery Charges", nil),[[selected_location valueForKey:@"delivery_charge"] floatValue],AMLocalizedString(CURRENCY, nil)];
    _lblTotalItems.text = [NSString stringWithFormat:@"%@ : %d",AMLocalizedString(@"Item", nil),[cart getCartItemCount]];
}
-(void)viewWillAppear:(BOOL)animated{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"refresh_address"]){
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"refresh_address"];
        [self getAddress];
    }
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"selected_date"] != nil){
        [btn_choose_date setTitle:[NSString stringWithFormat:@"%@ : %@",AMLocalizedString(@"Delivery Date", nil),[self getStringDateFormate:[[NSUserDefaults standardUserDefaults] valueForKey:@"selected_date"]]] forState:UIControlStateNormal];
        [btn_choose_date setBackgroundColor:PRIMARY_COLOR];
        [btn_choose_date setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"selected_time"] != nil){
        [btn_choose_time setTitle:[NSString stringWithFormat:@"%@ : %@",AMLocalizedString(@"Delivery Time", nil),[[NSUserDefaults standardUserDefaults] valueForKey:@"selected_time"]] forState:UIControlStateNormal];
        [btn_choose_time setBackgroundColor:PRIMARY_COLOR];
        [btn_choose_time setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}


-(IBAction)btnChooseTime:(id)sender{
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"selected_date"] != nil){
        ChoosetimeVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChoosetimeVC"];
        vc.selected_date = [self getStringDateFormate:[[NSUserDefaults standardUserDefaults] valueForKey:@"selected_date"]];
        [self.navigationController pushViewController:vc animated:TRUE];
    }
    
}

-(void)getAddress{
    
    NSDictionary *dictParams = @{
                                 @"user_id": [app.dictUser valueForKey:@"user_id"]
                                 };
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_ADDRESS] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            addresses = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
            if (addresses != nil && [addresses count] > 0) {
                selected_location = [addresses objectAtIndex:0];
                [tableview reloadData];
                [self updateTotal];
            }
            
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
    
    AddressCell *cell= [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    NSMutableDictionary *desc = [addresses objectAtIndex:indexPath.row];
    cell.lblStreet.text = [NSString stringWithFormat:@"%@ : %@",AMLocalizedString(@"Socity", nil),[desc valueForKey:@"socity_name"]];
    
    
    cell.lblAddress.text = [NSString stringWithFormat:@"%@ : %@",AMLocalizedString(@"Address", nil),[desc valueForKey:@"house_no"]];
    cell.lblDeliveryCharge.text = [NSString stringWithFormat:@"%@ : %@",AMLocalizedString(@"Delivery Charges", nil),[desc valueForKey:@"delivery_charge"]];
    cell.lblReciverPhone.text = [desc valueForKey:@"receiver_mobile"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if ([desc isEqual:selected_location]) {
        [cell.imgRadioImage setImage:[UIImage imageNamed:@"radio_checked"]];
    }else{
        [cell.imgRadioImage setImage:[UIImage imageNamed:@"radio"]];
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (addresses!=nil) {
        return addresses.count;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selected_location = [addresses objectAtIndex:indexPath.row];
    [tableview reloadData];
    [self updateTotal];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        //add code here for when you hit delete
        
    }
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSLog(@"Delete");
                                        // Delete something here
                                        [self deleteAddress:[[addresses objectAtIndex:indexPath.row] valueForKey:@"location_id"] index:indexPath.row];
                                    }];
    delete.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *more = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                  {
                                      NSLog(@"Edit");
                                      AddAddressVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAddressVC"];
                                      vc.is_edit = true;
                                      vc.address_desc = [addresses objectAtIndex:indexPath.row];
                                      [self.navigationController pushViewController:vc animated:true];
                                      //Just as an example :
                                      //[self presentUIAlertControllerActionSheet];
                                  }];
    more.backgroundColor = [UIColor colorWithRed:0.188 green:0.514 blue:0.984 alpha:1];
    
    return @[delete, more]; //array with all the buttons you want. 1,2,3, etc...
}
- (void)deleteAddress:(NSString*)deleted_id  index:(NSInteger)index{
    
    NSDictionary *dictParams = nil;
    NSString *url;
    
    dictParams =  @{
                    @"location_id": deleted_id,
                    @"user_id": [app.dictUser valueForKey:@"user_id"]
                    };
    url = [self getStringURLForAPI:URL_API_DELETET_ADDRESS];
    [self postResponseFromURL:url withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            [addresses removeObjectAtIndex:index];
            [tableview reloadData];
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
    
    
}
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
    if(selected_location == nil)
    {
        
        isValidated = NO;
        strMessage = AMLocalizedString(@"Please Choose Delivery Location", @"");
    }
    
    if(isValidated){
        [[NSUserDefaults standardUserDefaults] setObject:selected_location forKey:@"selected_location"];
        ConfirmDeliveryVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmDeliveryVC"];
        [self.navigationController pushViewController:vc animated:true];
    }else{
        [self showAlertForTitle:AMLocalizedString(@"Error!", nil) withMessage:AMLocalizedString(strMessage, nil)];
    }
}
@end
