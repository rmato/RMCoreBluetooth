//
//  DetailViewController.m
//  BlueToothExample
//
//  Created by Avi-on on 12/22/16.
//  Copyright © 2016 Avi-on. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (assign, nonatomic) NSInteger itemIndex;

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)connectToPeripheral {
    [self.bluetoothConnector connectToPeripheralAtIndex:self.itemIndex];
}

- (void)setItemIndex:(NSInteger)index {
    self.itemIndex = index;
    [self connectToPeripheral];
}


@end
