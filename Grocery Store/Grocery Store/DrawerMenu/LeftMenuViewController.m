//
//  LeftMenuViewController.m
//  reportapp
//
//  Created by subhashsanghani on 10/30/15.
//  Copyright © 2015 com. All rights reserved.
//

#import "LeftMenuViewController.h"

#import "BaseVC.h"
#import "LoginVC.h"
#import "UpdateProfileVC.h"
#import "ChangePasswordVC.h"
#import "MyOrdersVC.h"
#import "InfoPagesVC.h"

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 0
#define PANEL_WIDTH_SIDE 60
#define HEADER_HEIGHT 60
@interface LeftMenuViewController ()
{
    //CommonFramework *common;
    CGFloat screenWidth;
    CGFloat screenHeight;
    UILabel *lblBudget;

    
}
@end

@implementation LeftMenuViewController
@synthesize userMenu;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    //common = [[CommonFramework alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.view.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft) {
        self.view.frame = CGRectMake(  screenWidth + 1 , 0, screenWidth - PANEL_WIDTH_SIDE, self.view.frame.size.height);
    }else{
         self.view.frame = CGRectMake( - screenWidth - PANEL_WIDTH_SIDE , 0, screenWidth - PANEL_WIDTH_SIDE, self.view.frame.size.height);
    }
    [self.view setBackgroundColor:[UIColor colorWithRed:255.0/250.0 green:255.0/250.0 blue:255.0/250.0 alpha:0.9]];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.view.layer.shadowOpacity = 0.5f;
    self.view.layer.shadowPath = shadowPath.CGPath;
    
    //[lblAppName setFont:[self getBoldItalicFont:26.0f]];
    [userImage.layer setCornerRadius:userImage.layer.frame.size.height / 2];
    [userImage.layer setBorderWidth:1.0];
    [userImage setClipsToBounds:true];
    
    [userImage.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
}

- (void)leftSideMenuButtonPressed {
    NSMutableArray *arrayOne = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_USERDATA])
    {
        lblUserName.text = [app.dictUser valueForKey:@"user_fullname"];
        lblEmailId.text = [app.dictUser valueForKey:@"user_email"];
        [self setSimpleImageToView:userImage imgpath:[NSString stringWithFormat:@"%@%@/%@",URL_API_HOST_BASE,IMAGE_PROFILE_PATH,[app.dictUser valueForKey:@"user_image"]]];
        self.userMenu = [[NSMutableArray alloc] init];
        
        
        [dict setValue:AMLocalizedString(@"My Profile", nil)  forKey:@"name"];
        [dict setValue:@"ic_nav_profile" forKey:@"icon"];
        [arrayOne addObject:dict];
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setValue:AMLocalizedString(@"My Orders", nil) forKey:@"name"];
        [dict setValue:@"ic_nav_order" forKey:@"icon"];
        [arrayOne addObject:dict];
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setValue:AMLocalizedString(@"Logout", nil) forKey:@"name"];
        [dict setValue:@"ic_exit" forKey:@"icon"];
        [arrayOne addObject:dict];
        
        
        [userMenu addObject:arrayOne];
        
        
        
    }else{
        self.userMenu = [[NSMutableArray alloc] init];
        
        NSMutableArray *arrayOne = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:AMLocalizedString(@"Login Now", nil) forKey:@"name"];
        [dict setValue:@"ic_menu_profile" forKey:@"icon"];
        [arrayOne addObject:dict];
        
        
       
        [userMenu addObject:arrayOne];
        
        
    }
    arrayOne = [[NSMutableArray alloc] init];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:AMLocalizedString(@"Support", nil) forKey:@"name"];
    [dict setValue:@"ic_nav_support" forKey:@"icon"];
    [arrayOne addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:AMLocalizedString(@"About Us", nil) forKey:@"name"];
    [dict setValue:@"ic_nav_about" forKey:@"icon"];
    [arrayOne addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:AMLocalizedString(@"Terms & Condition", nil) forKey:@"name"];
    [dict setValue:@"ic_nav_policy" forKey:@"icon"];
    [arrayOne addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:AMLocalizedString(@"Review Us", nil) forKey:@"name"];
    [dict setValue:@"ic_nav_review" forKey:@"icon"];
    [arrayOne addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:AMLocalizedString(@"Share with Friends", nil) forKey:@"name"];
    [dict setValue:@"ic_nav_share" forKey:@"icon"];
    [arrayOne addObject:dict];
    
    
    
    
    
    [userMenu addObject:arrayOne];
    
    if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.view.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft) {
        if(self.is_open_menu){
            self.is_open_menu = false;
            [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.view.frame = CGRectMake( screenWidth + 1 , 0, screenWidth - PANEL_WIDTH_SIDE, screenHeight - HEADER_HEIGHT);
                [self.view setBackgroundColor:[UIColor colorWithRed:255.0/250.0 green:255.0/250.0 blue:255.0/250.0 alpha:0.9]];
            }
                             completion:^(BOOL finished) {
                                 if (finished) {
                                     //[centerView setAlpha:1];
                                     //self.rightButton.tag = 0;
                                 }
                             }];
            //self.parentViewController.navigationItem.leftBarButtonItems[0].image = [UIImage imageNamed:@"icon_Menu1"];
            
        }else{
            self.is_open_menu = true;
            [tableview reloadData];
            [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.view.frame = CGRectMake( PANEL_WIDTH_SIDE , 0, screenWidth - PANEL_WIDTH_SIDE, screenHeight - HEADER_HEIGHT);
                [self.view setBackgroundColor:[UIColor colorWithRed:255.0/250.0 green:255.0/250.0 blue:255.0/250.0 alpha:0.9]];
            }
                             completion:^(BOOL finished) {
                                 if (finished) {
                                     //[centerView setAlpha:0.4];
                                     //self.rightButton.tag = 0;
                                 }
                             }];
            
            //self.parentViewController.navigationItem.leftBarButtonItems[0].image = [UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"];
        }
    }else{
    if(self.is_open_menu){
        self.is_open_menu = false;
        [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.view.frame = CGRectMake(- screenWidth - PANEL_WIDTH_SIDE , 0, screenWidth - PANEL_WIDTH_SIDE, screenHeight - HEADER_HEIGHT);
            [self.view setBackgroundColor:[UIColor colorWithRed:255.0/250.0 green:255.0/250.0 blue:255.0/250.0 alpha:0.9]];
        }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 //[centerView setAlpha:1];
                                 //self.rightButton.tag = 0;
                             }
                         }];
        //self.parentViewController.navigationItem.leftBarButtonItems[0].image = [UIImage imageNamed:@"icon_Menu1"];
        
    }else{
        self.is_open_menu = true;
        [tableview reloadData];
        [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.view.frame = CGRectMake(0, 0, screenWidth - PANEL_WIDTH_SIDE, screenHeight - HEADER_HEIGHT);
            [self.view setBackgroundColor:[UIColor colorWithRed:255.0/250.0 green:255.0/250.0 blue:255.0/250.0 alpha:0.9]];
        }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 //[centerView setAlpha:0.4];
                                 //self.rightButton.tag = 0;
                             }
                         }];
        
        //self.parentViewController.navigationItem.leftBarButtonItems[0].image = [UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"];
    }
    }
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [userMenu count];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return  AMLocalizedString(@"User", nil);
    }else{
        return AMLocalizedString(@"Grocery Store", nil);
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[userMenu objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if ([cell subviews]){
        for (UIView *subview in [cell subviews]) {
            [subview removeFromSuperview];
        }
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[userMenu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    UILabel *lblTitle1 = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, cell.frame.size.width, cell.frame.size.height)];
    [lblTitle1 setFont:[UIFont systemFontOfSize:12.0f]];
    [lblTitle1 setTextColor:[UIColor blackColor]];
    [lblTitle1 setText:[dict valueForKey:@"name"]];
    [lblTitle1 setTextAlignment:NSTextAlignmentLeft];
    [cell addSubview:lblTitle1];
    
  
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 25, 25)];
    [imageview setImage:[UIImage imageNamed:[dict valueForKey:@"icon"]]];
    [cell addSubview:imageview];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self leftSideMenuButtonPressed];
    if(indexPath.section == 0){
        if ([[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_USERDATA])
        {
            switch (indexPath.row) {
                case 0:{
                    UpdateProfileVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdateProfileVC"];
                    [self.navigationController pushViewController:vc animated:true];
                    break;
                }
                case 1:{
                    MyOrdersVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrdersVC"];
                    [self.navigationController pushViewController:vc animated:true];
                    break;
                }
                case 2:{
                    [self updateRemData];
                    break;
                }
                default:
                    break;
            }
        }else{
            LoginVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            [self.navigationController pushViewController:vc animated:true];
            
            return;
        }
    }else{
        switch (indexPath.row) {
            case 0:{
                InfoPagesVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoPagesVC"];
                vc.api_url = URL_API_SUPPORT;
                vc.title = AMLocalizedString(@"Support", nil);
                [self.navigationController pushViewController:vc animated:true];
                break;
            }
            case 1:{
                InfoPagesVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoPagesVC"];
                vc.api_url = URL_API_ABOUTUS;
                vc.title = AMLocalizedString(@"About Us", nil);
                [self.navigationController pushViewController:vc animated:true];
                break;
            }
            case 2:{
                InfoPagesVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoPagesVC"];
                vc.api_url = URL_API_TERMS;
                vc.title = AMLocalizedString(@"Terms & Condition", nil);
                [self.navigationController pushViewController:vc animated:true];
                break;
            }
            case 4:{
                [self shareLink];
                break;
            }
            case 3:{
                [self appStoreOpen];
                break;
            }
            default:
                break;
        }
    }
    
    
}
-(void)shareLink{
    NSArray* sharedObjects=[NSArray arrayWithObjects:APP_STORE_LINK,  nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
}
-(void)appStoreOpen{
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:APP_STORE_LINK]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_LINK]];

}
-(void)logoutMe{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULTS_USERDATA];
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    UINavigationController *secondViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavigation"];
    [self presentViewController:secondViewController animated:YES completion:nil];
    
   

}
-(IBAction)updateRemData{
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:AMLocalizedString(@"Logout", @"")
                                 message:AMLocalizedString(@"Are you sure wont to logout ?", @"")
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:AMLocalizedString(@"Confirm", @"")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self logoutMe];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:AMLocalizedString(@"Cancel", @"")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
