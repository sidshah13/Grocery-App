//
//  AddAddressVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 7/31/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "AddAddressVC.h"
#import "ChooseSocityVC.h"
@interface AddAddressVC ()
{
    NSMutableDictionary *selected_socity;
}
@end

@implementation AddAddressVC
@synthesize btnSocity,txtAddress, txtZipCode, txtReceiverName, txtReceiverPhone, is_edit, address_desc;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = AMLocalizedString(@"New Address", nil);
    // Do any additional setup after loading the view.
    if(is_edit && address_desc !=nil){
        [btnSocity setTitle:[address_desc valueForKey:@"socity_name"] forState:UIControlStateNormal];
        txtAddress.text = [address_desc valueForKey:@"house_no"];
        txtReceiverName.text = [address_desc valueForKey:@"receiver_name"];
        txtReceiverPhone.text = [address_desc valueForKey:@"receiver_mobile"];
        selected_socity = [[NSMutableDictionary alloc] initWithDictionary:address_desc];
        
    }
    btnSocity.layer.borderWidth = 0.5f;
    btnSocity.layer.borderColor = [[UIColor lightTextColor] CGColor];
    btnSocity.layer.cornerRadius = 4.0f;
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
-(void)viewWillAppear:(BOOL)animated{
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"selected_socity"] != nil){
        
        selected_socity = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"selected_socity"]];
        [btnSocity setTitle:[selected_socity valueForKey:@"socity_name"] forState:UIControlStateNormal];
        
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)registerButtonClicked:(id)sender {
    [txtReceiverPhone resignFirstResponder];
    [txtReceiverName resignFirstResponder];
    [txtAddress resignFirstResponder];
    BOOL isValidated = YES;
    NSString *strMessage=@"";
    
    if (txtAddress.text.length == 0)
    {
        isValidated = NO;
        strMessage = AMLocalizedString(@"Please Enter Address", @"");
    }
    else if (selected_socity == nil)
    {
        isValidated = NO;
        strMessage = AMLocalizedString(@"Please Choose Socity", @"");
    }
    if(isValidated){
        NSDictionary *dictParams = nil;
        NSString *url;
        if (is_edit) {
            dictParams =  @{
                            @"location_id": [address_desc valueForKey:@"location_id"],
                            @"user_id": [app.dictUser valueForKey:@"user_id"],
                            @"socity_id": [selected_socity valueForKey:@"socity_id"],
                            @"house_no" : txtAddress.text,
                            @"receiver_name" : txtReceiverName.text,
                            @"receiver_mobile" : txtReceiverPhone.text,
                            @"pincode" : txtZipCode.text
                            };
            url = [self getStringURLForAPI:URL_API_EDIT_ADDRESS];
        }else{
            dictParams =  @{
                            @"user_id": [app.dictUser valueForKey:@"user_id"],
                            @"socity_id": [selected_socity valueForKey:@"socity_id"],
                            @"house_no" : txtAddress.text,
                            @"receiver_name" : txtReceiverName.text,
                            @"receiver_mobile" : txtReceiverPhone.text,
                            @"pincode" : txtZipCode.text
                            };
            url = [self getStringURLForAPI:URL_API_ADD_ADDRESS];
        }
        
        [self postResponseFromURL:url withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
            if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"refresh_address"];
                [self.navigationController popViewControllerAnimated:TRUE];
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

-(IBAction)btnChooseSocity:(id)sender{
    ChooseSocityVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseSocityVC"];
    
    [self.navigationController pushViewController:vc animated:TRUE];
}
@end
