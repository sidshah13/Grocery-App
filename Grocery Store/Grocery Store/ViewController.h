//
//  ViewController.h
//  Grocery Store
//
//  Created by subhashsanghani on 7/27/17.
//  Copyright © 2017 Way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface ViewController : BaseVC<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIScrollView *slider_scroll_view;
    IBOutlet UITableView *tableview;
}
@end

