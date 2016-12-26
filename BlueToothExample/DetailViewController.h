//
//  DetailViewController.h
//  BlueToothExample
//
//  Created by Avi-on on 12/22/16.
//  Copyright © 2016 Avi-on. All rights reserved.
//

#import "BlueToothConnector.h"
#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property BlueToothConnector *bluetoothConnector;

- (void)setItemIndex:(NSInteger)index;

@end

