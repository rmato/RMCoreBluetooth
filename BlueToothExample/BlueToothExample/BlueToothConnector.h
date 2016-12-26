//
//  BlueToothConnector.h
//  BlueToothExample
//
//  Created by Avi-on on 12/22/16.
//  Copyright © 2016 Avi-on. All rights reserved.
//

@import CoreBluetooth;
@import QuartzCore;
#import "PeripheralData.h"
#import <Foundation/Foundation.h>

@protocol BlueToothConnectorDelegate <NSObject>

- (void)connectorDiscoveredNewPeripheral:(CBPeripheral*)peripheral;
- (void)connectedToPeripheral:(CBPeripheral*)peripheral;
- (void)didDiscoverServices:(NSArray*)services forPeripheral:(CBPeripheral*)peripheral;
- (void)didDiscoverCharacteristics:(NSArray*)characteristics forService:(CBService*)service;

@end

@interface BlueToothConnector : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) NSMutableArray<PeripheralData*>     *peripherals;
@property (weak, nonatomic) id<BlueToothConnectorDelegate>      delegate;

- (void)startScaning;
- (void)connectToPeripheralAtIndex:(NSInteger)index;

@end
