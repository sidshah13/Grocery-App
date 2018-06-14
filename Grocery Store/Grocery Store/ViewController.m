//
//  ViewController.m
//  Grocery Store
//
//  Created by subhashsanghani on 7/27/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "ViewController.h"
#import "CategoryCell.h"
#import "ProductPagerVC.h"
@import FirebaseInstanceID;
@import FirebaseMessaging;
@interface ViewController ()
{
    NSMutableArray *categoryArray;
    NSMutableArray *myImages;
    NSTimer *timer;
    NSInteger imageCount;
    BOOL animating;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = AMLocalizedString(@"Glocery", nil);
    // Do any additional setup after loading the view, typically from a nib.
    categoryArray = [[NSMutableArray alloc] init];
    myImages = [[NSMutableArray alloc] init];
    [self load_slides];
    [self getCategories];
    [self addMenuButton];
    
    

}
-(void)registerGCMTokenToSite{
    
    NSString *token = [[FIRInstanceID instanceID] token];
    if (token != nil && ![token isEqual:[NSNull null]]) {
        
        
        [[FIRMessaging messaging] subscribeToTopic:@"/topics/grocerystore"];
        NSLog(@"InstanceID token: %@", token);
        if([[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_USERDATA] ){
            NSDictionary *dictParams = @{
                                         @"user_id": [app.dictUser valueForKey:@"user_id"],
                                         @"token": token,
                                         @"device" : @"ios"
                                         };
            
            [self postResponseFromURL:[self getStringURLForAPI:URL_API_APN_REGISTER] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
                
            } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
                if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"apn_registered"];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            } showLoader:YES hideLoader:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self addCartButton];
}
-(void)getCategories{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init] ;
    
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_CATEGORY] withParams:params progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            [categoryArray removeAllObjects];
            [categoryArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
            [tableview reloadData];
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
}
-(void)load_slides{
    NSURL *URL = [NSURL URLWithString:[self getStringURLForAPI:URL_API_SLIDERS]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:responseObject];
        for (int i = 0; i < [array count]; i++) {
            NSMutableDictionary *desc = [array objectAtIndex:i];
            [myImages addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",URL_API_HOST_BASE,SLIDER_IMAGE_BIG_PATH,[desc valueForKey:@"slider_image"]]]];
            
            
            
        }
        
        [self createSlider];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}
-(void)createSlider{
    slider_scroll_view.frame = CGRectMake(0, 0, kScreenWidth, slider_scroll_view.frame.size.height);
    for (int i=0; i<[myImages count]; i++) {
        
        AsyncImageView *recipeImageView ;
        recipeImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake((kScreenWidth)*i, 0, kScreenWidth , slider_scroll_view.frame.size.height)];
        recipeImageView.clipsToBounds = YES;
        recipeImageView.contentMode = UIViewContentModeScaleAspectFill;
        recipeImageView.imageURL = [myImages objectAtIndex:i];
        //recipeImageView.image = [UIImage imageNamed:[myImages objectAtIndex:i]];
        
        [slider_scroll_view addSubview:recipeImageView];
    }
    [slider_scroll_view setContentSize:CGSizeMake(kScreenWidth * [myImages count] - 1, slider_scroll_view.frame.size.height)];
    timer = [NSTimer scheduledTimerWithTimeInterval:(6.0) target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    [timer fire];
}
-(void)changeImage{
    
    if(imageCount>([myImages count]-1)){
        imageCount=0;
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:0.6];
        slider_scroll_view.contentOffset = CGPointMake(imageCount*self.view.frame.size.width,slider_scroll_view.contentOffset.y);
        [UIImageView commitAnimations];
        imageCount+=1;}
    else{
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:0.6];
        slider_scroll_view.contentOffset = CGPointMake(imageCount*self.view.frame.size.width,slider_scroll_view.contentOffset.y);
        [UIImageView commitAnimations];
        imageCount+=1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = nil;
    
    simpleTableIdentifier=@"CategoryCell";
    
    
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    
    NSMutableDictionary *dictdoct = [categoryArray objectAtIndex:indexPath.row];
    cell.lblName.text = [dictdoct valueForKey:@"title"];
    
    
 
    
    [self setSimpleImageToView:cell.imageIcon imgpath:[NSString stringWithFormat:@"%@%@%@",URL_API_HOST_BASE,PATH_CATEGORY_IMAGE,[dictdoct valueForKey:@"image"]]];
    //[cell.imageIcon.layer setCornerRadius:cell.imageIcon.frame.size.width / 2];
    [cell.imageIcon setClipsToBounds:true];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageIcon.layer.cornerRadius = 4.0f;

    cell.viewFrame.layer.cornerRadius = 4.0f;
    cell.viewFrame.layer.masksToBounds = NO;
    cell.viewFrame.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.viewFrame.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    cell.viewFrame.layer.shadowOpacity = 0.5f;
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (categoryArray!=nil) {
        return categoryArray.count;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductPagerVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductPagerVC"];
    vc.category = [categoryArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:true];
}
@end
