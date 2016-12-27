//
//  BlueToothConnector.m
//  BlueToothExample
//
//  Created by Avi-on on 12/22/16.
//  Copyright © 2016 Avi-on. All rights reserved.
//

#import "BlueToothConnector.h"

@interface BlueToothConnector ()

@property (nonatomic, strong) CBCentralManager                  *centralManager;

@end

@implementation BlueToothConnector


- (id)init {
    self = [super init];
    if (self) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        _peripherals = [NSMutableArray new];
    }
    return self;
}

- (void)startScaning {
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)connectToPeripheralAtIndex:(NSInteger)index {
    PeripheralData *data = self.peripherals[index];
    if (data) {
        [self.centralManager connectPeripheral:data.peripheral options:nil];
    }

}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
   
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    NSString *connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@ connected: %@", peripheral.name, connected);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
   NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([localName length] > 0) {
        NSLog(@"Found Peripheral: %@", localName);
        [self.peripherals addObject:[[PeripheralData alloc] initWithPeripheral:peripheral andRRSI:RSSI]];
        peripheral.delegate = self;
        [self.delegate connectorDiscoveredNewPeripheral:peripheral];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    // Determine the state of the peripheral
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
        [self startScaning];
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }
}

#pragma mark - CBPeripheralDelegate

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
    if (peripheral.services) {
        [self.delegate didDiscoverServices:peripheral.services forPeripheral:peripheral];
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *charcteristic in service.characteristics) {
        NSLog(@"Discovered characteristic: %@", charcteristic.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
    if (service.characteristics) {
        [self.delegate didDiscoverCharacteristics:service.characteristics forService:service];
    }
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

@end
