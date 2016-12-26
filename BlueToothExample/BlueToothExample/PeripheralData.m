//
//  Peripheral.m
//  BlueToothExample
//
//  Created by Rodrigo Mato on 12/26/16.
//  Copyright © 2016 Avi-on. All rights reserved.
//

#import "PeripheralData.h"

@implementation PeripheralData

- (id)initWithPeripheral:(CBPeripheral *)peripheral andRRSI:(NSNumber *)rssi {
    self = [self init];
    if (self) {
        _peripheral = peripheral;
        _RSSI = rssi;
    }
    return self;
}

@end
