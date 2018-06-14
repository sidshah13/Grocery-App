//
//  ProductListVC.m
//  Grocery Store
//
//  Created by subhashsanghani on 7/30/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import "ProductListVC.h"
#define PAGE_LIMIT 10
#import "LocalizeLabel.h"
#import "LocalizeButton.h"
#import "ProductPagerVC.h"
@interface ProductListVC ()
{
    NSMutableArray *products_array;
    NSString *cat_id;
    BOOL is_load_more;
    int page_index;
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ProductListVC
@synthesize category,is_search,search_view,searchField,btnSearch;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    is_load_more = true;
    page_index = 1;
   
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self
                            action:@selector(getProducts)
                  forControlEvents:UIControlEventValueChanged];
    
    [scrollview addSubview:self.refreshControl];
    
    [search_view setHidden:true];
    
    if (is_search != nil && ![is_search isEqualToString:@""]) {
        self.navigationItem.title = AMLocalizedString(@"Search", nil);
        [search_view setHidden:false];
        CGRect frame = scrollview.frame;
        frame.size.height =  frame.size.height - search_view.frame.size.height;
        frame.origin.y =    search_view.frame.size.height;
        scrollview.frame = frame;
        btnSearch.layer.cornerRadius = btnSearch.frame.size.height / 2;
        [self addCartButton];
    }else{
        cat_id = [category valueForKey:@"id"];
        [self getProducts];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)searchClick:(id)sender{
    [scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if(searchField.text.length > 0){
        is_search = searchField.text;
        [self getProducts];
    }
}
-(void)getProducts{
    [self.refreshControl beginRefreshing];
    NSDictionary *dictParams = nil;
    if (is_search != nil) {
        dictParams = @{
                       @"search": is_search,
                       @"page" : [NSString stringWithFormat:@"%d",page_index]
                       };
    }else{
        dictParams = @{
                       @"cat_id": cat_id,
                       @"page" : [NSString stringWithFormat:@"%d",page_index]
                       };
    }
    
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_PRODUCTS] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            NSMutableArray *responce_Array = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
            if (page_index == 1) {
                if(products_array != nil)
                    [products_array removeAllObjects];
                
                products_array = responce_Array;
                
            }else{
                [products_array addObjectsFromArray:responce_Array];
            }
            if ([responce_Array count] < PAGE_LIMIT) {
                is_load_more = false;
            }
            [self generateListView];
            
            [[NSUserDefaults standardUserDefaults] setObject:products_array forKey:[NSString stringWithFormat:@"products_%@",cat_id]];
            
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
        [self.refreshControl endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.refreshControl endRefreshing];
    } showLoader:YES hideLoader:YES];
}
-(void)generateListView{
    int cell_height = 80;
    if(products_array !=nil){
        
        for (int i = ((page_index - 1) * PAGE_LIMIT); i < [products_array count]; i++) {
            
            UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(10, (cell_height * i) + (i*5), kScreenWidth - 20, cell_height)];
            [cell setClipsToBounds:true];
            /*UIView *frame = [[UIView alloc] initWithFrame:CGRectMake(2, 2, cell.frame.size.width - 4, cell.frame.size.height - 4)];
            
            frame.layer.cornerRadius = 4.0f;
            frame.layer.masksToBounds = NO;
            frame.layer.shadowColor = [UIColor blackColor].CGColor;
            frame.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
            frame.layer.shadowOpacity = 0.5f;
            frame.layer.borderWidth = 0.5f;
            frame.layer.borderColor = [[UIColor lightTextColor] CGColor];
            
            [frame setClipsToBounds:true];
            [cell addSubview:frame];*/
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
            [imgView.layer setCornerRadius:imgView.layer.frame.size.height / 2];
            [imgView.layer setBorderWidth:1.0];
            [imgView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
            
            LocalizeLabel *lblTitle = [[LocalizeLabel alloc] initWithFrame:CGRectMake(70, 5, cell.frame.size.width - 90 - 70 , 20)];
            lblTitle.adjustsFontSizeToFitWidth = YES;
            [lblTitle setTextColor:[UIColor darkGrayColor]];
            
            LocalizeLabel *lblPrice = [[LocalizeLabel alloc] initWithFrame:CGRectMake(70 , 25, (cell.frame.size.width - 90 - 70) / 2 , 20)];
            lblPrice.adjustsFontSizeToFitWidth = YES;
            [lblPrice setTextColor:[UIColor darkGrayColor]];
            
            LocalizeLabel *lblTotal = [[LocalizeLabel alloc] initWithFrame:CGRectMake(70 , 45, lblPrice.frame.size.width, 20)];
            lblTotal.adjustsFontSizeToFitWidth = YES;
            lblTotal.tag = i+2000;
           [lblTotal setTextColor:[UIColor darkGrayColor]];
            
            
            
            
            UIButton *btnIncrease = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width - 25, 10, 20, 20)];
            [btnIncrease setBackgroundImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
            btnIncrease.tag = i;
            
            UILabel *lblQty = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 65 ,10 , 40, 20)];
            lblQty.tag = i+1000;
            [lblQty setTextAlignment:NSTextAlignmentCenter];
            lblQty.text = @"0.0";
            
            UIButton *btnDecrease = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width - 85, 10, 20, 20)];
            [btnDecrease setBackgroundImage:[UIImage imageNamed:@"ic_less"] forState:UIControlStateNormal];
            btnDecrease.tag = i;
            
            LocalizeButton *btnAdd = [[LocalizeButton alloc] initWithFrame:CGRectMake(cell.frame.size.width - 85, 35, 80, 25)];
            btnAdd.titleLabel.adjustsFontSizeToFitWidth = YES;
            [btnAdd.layer setCornerRadius:btnAdd.frame.size.height / 2];
            btnAdd.titleLabel.font = [UIFont fontWithName:@"CoconNextArabic-Light" size:18];
            [btnAdd setBackgroundColor:SECONDARY_COLOR];
            [btnAdd setTitle:AMLocalizedString(@"Add", nil) forState:UIControlStateNormal];
            btnAdd.tag = i;
            
            [btnIncrease addTarget:self action:@selector(btnIncrease:) forControlEvents:UIControlEventTouchUpInside];
            [btnDecrease addTarget:self action:@selector(btnDecrese:) forControlEvents:UIControlEventTouchUpInside];
            [btnAdd addTarget:self action:@selector(btnAddCart:) forControlEvents:UIControlEventTouchUpInside];
            
            NSMutableDictionary *dict = [products_array objectAtIndex:i];
            
            lblTitle.text = [dict valueForKey:@"product_name"];
            
            NSString *unit =[dict valueForKey:@"unit"];
            
            
            lblPrice.text = [NSString stringWithFormat:@"%@ %@:%@ %@", AMLocalizedString(@"Price per", nil),AMLocalizedString(unit, nil), [dict valueForKey:@"price"], AMLocalizedString(CURRENCY, nil)];
            lblTotal.text =   [NSString stringWithFormat:@"%@ : %.2f %@",AMLocalizedString(@"Total", nil),0.0,AMLocalizedString(CURRENCY, nil) ];
            
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image = [UIImage imageNamed:@"180"];
            //cell.imageview.imageURL =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", URL_API_HOST_BASE, PRO_IMAGE_SMALL_PATH,[dict valueForKey:@"product_image"]]];
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", URL_API_HOST_BASE, PRO_IMAGE_SMALL_PATH,[dict valueForKey:@"product_image"]]]];
                if ( data == nil )
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{
                    // WARNING: is the cell still using the same data by this point??
                    imgView.image = [UIImage imageWithData: data];
                });
                
            });
            
            /*if ([self isRTL]) {
                imgView.frame = [self changeViewDirection:imgView.frame screenwidth:kScreenWidth extraOffset:0];
                lblPrice.frame = [self changeViewDirection:lblPrice.frame screenwidth:kScreenWidth extraOffset:0];
                lblQty.frame = [self changeViewDirection:lblQty.frame screenwidth:kScreenWidth extraOffset:0];
                lblTitle.frame = [self changeViewDirection:lblTitle.frame screenwidth:kScreenWidth extraOffset:0];
                lblTotal.frame = [self changeViewDirection:lblTotal.frame screenwidth:kScreenWidth extraOffset:0];
                btnIncrease.frame = [self changeViewDirection:btnIncrease.frame screenwidth:kScreenWidth extraOffset:0];
                btnAdd.frame = [self changeViewDirection:btnAdd.frame screenwidth:kScreenWidth extraOffset:0];
                btnDecrease.frame = [self changeViewDirection:btnDecrease.frame screenwidth:kScreenWidth extraOffset:0];
                [lblTitle setTextAlignment:NSTextAlignmentRight];
                [lblPrice setTextAlignment:NSTextAlignmentRight];
                [lblTotal setTextAlignment:NSTextAlignmentRight];
            }else{
                [lblTitle setTextAlignment:NSTextAlignmentLeft];
                [lblPrice setTextAlignment:NSTextAlignmentLeft];
                [lblTotal setTextAlignment:NSTextAlignmentLeft];
            }
            */
            [cell addSubview:imgView];
            [cell addSubview:lblPrice];
            [cell addSubview:lblQty];
            [cell addSubview:lblTitle];
            [cell addSubview:lblTotal];
            
            [cell addSubview:btnIncrease];
            [cell addSubview:btnAdd];
            [cell addSubview:btnDecrease];
            
            NSMutableDictionary *cart_item = [cart getCartItemByKey:[dict valueForKey:@"product_id"]];
            if(cart_item != nil){
                lblQty.text = [NSString stringWithFormat:@"%.1f",[[cart_item valueForKey:@"qty"] floatValue]];
                lblTotal.text =   [NSString stringWithFormat:@"%@ : %.2f %@",AMLocalizedString(@"Total", nil),[[dict valueForKey:@"price"] floatValue] * [[cart_item valueForKey:@"qty"] floatValue],AMLocalizedString(CURRENCY, nil) ];
                [btnAdd setTitle:AMLocalizedString(@"Update", nil) forState:UIControlStateNormal];
                [btnAdd setBackgroundColor:[UIColor grayColor]];
            }
            
            cell.layer.borderColor = [[UIColor lightTextColor] CGColor];
            cell.layer.borderWidth = 0.5f;
            cell.layer.cornerRadius = 4.0f;
            
            [scrollview addSubview:cell];
        }
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:BOOL_UPDATE];
        [scrollview setContentSize:CGSizeMake(kScreenWidth, cell_height *[products_array count])];
    }
}

-(IBAction)btnAddCart:(id)sender{
    int tag = (int)[sender tag];
    NSMutableDictionary *product_desc = [products_array objectAtIndex:tag];
    UILabel *lblQty = [scrollview viewWithTag:tag+1000];
    float qty = [lblQty.text floatValue];
    
    
    
    if (qty > 0) {
        
        
        NSString *strQty = [NSString stringWithFormat:@"%f",qty];
        NSDictionary *cartitem = @{
                                   @"product_id": [product_desc valueForKey:@"product_id"],
                                   @"currency" : CURRENCY,
                                   @"price" : [product_desc valueForKey:@"price"],
                                   @"product_name" : [product_desc valueForKey:@"product_name"],
                                   @"product_image" : [product_desc valueForKey:@"product_image"],
                                   @"title" : [product_desc valueForKey:@"title"],
                                   @"unit" : [product_desc valueForKey:@"unit"],
                                   @"unit_value" : [product_desc valueForKey:@"unit_value"],
                                   @"qty" :strQty
                                   };
        [cart addToCart:[[NSMutableDictionary alloc] initWithDictionary:cartitem copyItems:true]];
        numberBudget.value = [cart getCartItemCount];
        
        ProductPagerVC *ppv = (ProductPagerVC *) _parentview;
        [ppv updateBudget];
        
        UIButton *btnAdd = (UIButton*)sender;
        [btnAdd setTitle:AMLocalizedString(@"Update", nil) forState:UIControlStateNormal];
        [btnAdd setBackgroundColor:[UIColor grayColor]];
        
    }
    
    
    
}
-(IBAction)btnIncrease:(id)sender{
    
    int tag = (int)[sender tag];
    NSMutableDictionary *product_desc = [products_array objectAtIndex:tag];
    //NSMutableDictionary *cart_item = [cart getCartItemByKey:[product_desc valueForKey:@"product_id"]];
    //if(cart_item == nil){
        
        UILabel *lblQty = [scrollview viewWithTag:tag+1000];
        float qty = [lblQty.text floatValue];
        
        if ([[product_desc valueForKey:@"increament"] doubleValue] > 0) {
            qty  =qty + [[product_desc valueForKey:@"increament"] doubleValue];
        }else{
            qty  =qty + 1;
        }
        
        lblQty.text = [NSString stringWithFormat:@"%.1f",qty];
        
        UILabel *lblProductTotal = [scrollview viewWithTag:tag+2000];
        float product_price = [[product_desc valueForKey:@"price"] floatValue];
        lblProductTotal.text =   [NSString stringWithFormat:@"%@ : %.2f %@",AMLocalizedString(@"Total", nil),(product_price * qty),AMLocalizedString(CURRENCY, nil) ];
        
    //}
}
-(IBAction)btnDecrese:(id)sender{
    int tag = (int)[sender tag];
    NSMutableDictionary *product_desc = [products_array objectAtIndex:tag];
    //NSMutableDictionary *cart_item = [cart getCartItemByKey:[product_desc valueForKey:@"product_id"]];
    //if(cart_item == nil){
        
        UILabel *lblQty = [scrollview viewWithTag:tag+1000];
        float qty = [lblQty.text floatValue];
        if(qty > 0){
            if ([[product_desc valueForKey:@"increament"] doubleValue] > 0) {
                qty  =qty - [[product_desc valueForKey:@"increament"] doubleValue];
            }else{
                qty  =qty - 1;
            }
            lblQty.text = [NSString stringWithFormat:@"%.1f",qty];
            
        }
        
        UILabel *lblProductTotal = [scrollview viewWithTag:tag+2000];
        float product_price = [[product_desc valueForKey:@"price"] floatValue];
        lblProductTotal.text =   [NSString stringWithFormat:@"%@ : %.2f %@",AMLocalizedString(@"Total", nil),(product_price * qty),AMLocalizedString(CURRENCY, nil) ];
        
    //}
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView tag] == 2) {
        
        
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height) {
            // we are at the end
            if (is_load_more) {
                page_index = page_index + 1;
                [self getProducts];
            }
        }
        
    }
}

@end
