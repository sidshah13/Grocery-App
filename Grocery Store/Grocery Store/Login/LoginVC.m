//
//  LoginVC.m
//  Clinic App
//
//  Created by subhashsanghani on 7/7/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = AMLocalizedString(@"Login Now", nil);
    // Do any additional setup after loading the view.
    _btnLogin.layer.cornerRadius = _btnLogin.frame.size.height / 2;
    _btnRegister.layer.cornerRadius = _btnRegister.frame.size.height / 2;
     [_scrollview setContentSize:CGSizeMake(kScreenWidth, 550)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonClicked:(id)sender {
    [_txtUsername resignFirstResponder];
    [_txtPassword resignFirstResponder];
    BOOL isValidated = YES;
    NSString *strMessage=@"";
    
    if (_txtPassword.text.length == 0)
    {
        isValidated = NO;
        strMessage = AMLocalizedString(@"Please Enter Password", @"");
    }
    else if (_txtUsername.text.length == 0)
    {
        isValidated = NO;
        strMessage = AMLocalizedString(@"Please Enter User Name", @"");
    }
    if (!isValidated)
    {
        [self showAlertForTitle:AMLocalizedString(@"Error!",@"") withMessage:strMessage];
        return;
    }
    if(isValidated){
        NSDictionary *dictParams = @{
                                     @"password": _txtPassword.text,
                                     @"user_email": _txtUsername.text
                                     };
        
        [self postResponseFromURL:[self getStringURLForAPI:URL_API_LOGIN] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
            if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[responseObject objectForKey:PARAM_DATA]] forKey:USERDEFAULTS_USERDATA];
                [[NSUserDefaults standardUserDefaults] synchronize];
                app.dictUser = [[NSMutableDictionary alloc] initWithDictionary:[[responseObject objectForKey:PARAM_DATA] mutableCopy]];
                
                [self.navigationController popViewControllerAnimated:true];
                
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
- (IBAction)forgotPasswordClick:(id)sender {
    [_txtUsername resignFirstResponder];
    
    BOOL isValidated = YES;
    NSString *strMessage=@"";
    
    if (_txtUsername.text.length == 0)
    {
        isValidated = NO;
        strMessage = AMLocalizedString(@"Please Enter User Name", @"");
    }
    if (!isValidated)
    {
        [self showAlertForTitle:AMLocalizedString(@"Error!",@"") withMessage:strMessage];
        return;
    }
    if(isValidated){
        NSDictionary *dictParams = @{
                                     @"email": _txtUsername.text
                                     };
        
        [self postResponseFromURL:[self getStringURLForAPI:URL_API_FORGOT_PASSWORD] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
            if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
                _txtUsername.text = @"";
                
                [self showAlertForTitle:@"Success" withMessage:AMLocalizedString(@"Recovery Mail Sent Successfully to your registered email", nil)];
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
