//
//  MasterViewController.m
//  BlueToothExample
//
//  Created by Avi-on on 12/22/16.
//  Copyright © 2016 Avi-on. All rights reserved.
//

#import "PeripheralData.h"
#import "PeripheralTableViewCell.h"
#import "MBProgressHUD.h"
#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()
@property (strong, nonatomic) BlueToothConnector *bluetoothConnector;
@property (strong, nonatomic) CBPeripheral *connectedPeripheral;
@end

@implementation MasterViewController

static const NSString *specialUUID = @"special UUID";

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _bluetoothConnector = [BlueToothConnector new];
        _bluetoothConnector.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.bluetoothConnector startScaning];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        CBPeripheral *object = self.bluetoothConnector.peripherals[indexPath.row];
//        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
//        [controller setItemIndex:indexPath.row];
//        controller.bluetoothConnector = self.bluetoothConnector;
//        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        controller.navigationItem.leftItemsSupplementBackButton = YES;
//    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bluetoothConnector.peripherals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PeripheralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeripheralCell" forIndexPath:indexPath];

    PeripheralData *peripheralData = self.bluetoothConnector.peripherals[indexPath.row];
    CBPeripheral *peripheral = peripheralData.peripheral;
    cell.nameLabel.text = [NSString stringWithFormat:@"Name: %@", peripheral.name];
    cell.idLabel.text = [NSString stringWithFormat:@"ID: %@", peripheral.identifier];
    cell.RSSILabel.text = [NSString stringWithFormat:@"RSSI: %@", peripheralData.RSSI.stringValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.bluetoothConnector connectToPeripheralAtIndex:indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}


#pragma mark - BlueToothConnector delegate 

- (void)connectorDiscoveredNewPeripheral:(CBPeripheral *)peripheral {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)connectedToPeripheral:(CBPeripheral*)peripheral {
    self.connectedPeripheral = peripheral;
}

- (void)didDiscoverServices:(NSArray*)services forPeripheral:(CBPeripheral*)peripheral {
    
}

- (void)didDiscoverCharacteristics:(NSArray*)characteristics forService:(CBService*)service {
    for (CBCharacteristic *charcteristic in characteristics) {
        if ([charcteristic.UUID.UUIDString isEqualToString:[specialUUID copy]])  {
            
            NSString *message = [NSString stringWithFormat:@"Characteristic:%@ , Value:%@", charcteristic.UUID.UUIDString, charcteristic.value];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Characteristic found!" message:message preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }
}

@end
