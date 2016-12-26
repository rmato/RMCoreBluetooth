//
//  MasterViewController.h
//  BlueToothExample
//
//  Created by Avi-on on 12/22/16.
//  Copyright © 2016 Avi-on. All rights reserved.
//

#import "BlueToothConnector.h"
#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <BlueToothConnectorDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

