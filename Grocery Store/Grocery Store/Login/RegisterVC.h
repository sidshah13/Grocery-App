//
//  RegisterVC.h
//  Clinic App
//
//  Created by subhashsanghani on 7/7/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface RegisterVC : BaseVC
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailId;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@end
