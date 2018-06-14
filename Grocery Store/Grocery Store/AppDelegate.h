//
//  AppDelegate.h
//  Grocery Store
//
//  Created by subhashsanghani on 7/27/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "API_Settings.h"
#import "API_Parameters.h"
#import "BaseCart.h"
#import "LocalizationSystem.h"
#import "AFHTTPSessionManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDictionary *dictUser;
@property (strong, nonatomic) NSMutableArray *app_settings;
-(void)loadSharedInstance;
@end

