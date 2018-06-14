//
//  RegisterVC.m
//  Clinic App
//
//  Created by subhashsanghani on 7/7/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = AMLocalizedString(@"Register", nil);
    _btnRegister.layer.cornerRadius = _btnRegister.frame.size.height / 2;
    // Do any additional setup after loading the view.
    [_scrollview setContentSize:CGSizeMake(kScreenWidth, 550)];
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
- (IBAction)registerButtonClicked:(id)sender {
    [_txtPhone resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtEmailId resignFirstResponder];
    [_txtUsername resignFirstResponder];
    BOOL isValidated = YES;
    NSString *strMessage=@"";
    
    if (_txtPhone.text.length == 0)
    {
        isValidated = NO;
        strMessage = AMLocalizedString(@"Please Enter Phone Number", @"");
    }
    else if (_txtPassword.text.length == 0)
    {
        isValidated = NO;
        strMessage = AMLocalizedString(@"Please Enter Password", @"");
    }
    else if (_txtUsername.text.length == 0)
    {
        isValidated = NO;
        strMessage = AMLocalizedString(@"Please Enter User Name", @"");
    }else if (_txtEmailId.text.length == 0)
    {
        isValidated = NO;
        strMessage = AMLocalizedString(@"Please Enter Email Id", @"");
    }
    
    if (!isValidated)
    {
        [self showAlertForTitle:AMLocalizedString(@"Error!",@"") withMessage:strMessage];
        return;
    }
    
    NSDictionary *dictParams = @{
                                 @"password": _txtPassword.text,
                                 @"user_mobile": _txtPhone.text,
                                 @"user_name": _txtUsername.text,
                                 @"user_email": _txtEmailId.text
                                 };
    
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_REGISTER] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[responseObject objectForKey:PARAM_DATA]] forKey:USERDEFAULTS_USERDATA];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //app.dictUser = [[NSMutableDictionary alloc] initWithDictionary:[[responseObject objectForKey:PARAM_DATA] mutableCopy]];
            
            UINavigationController *secondViewController =
            [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigation"];
            [self presentViewController:secondViewController animated:YES completion:nil];
            
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
    
    
}
@end
