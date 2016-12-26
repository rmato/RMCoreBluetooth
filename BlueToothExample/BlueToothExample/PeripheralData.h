//
//  Peripheral.h
//  BlueToothExample
//
//  Created by Rodrigo Mato on 12/26/16.
//  Copyright © 2016 Avi-on. All rights reserved.
//

@import CoreBluetooth;
#import <Foundation/Foundation.h>

@interface PeripheralData : NSObject

@property (strong, nonatomic) CBPeripheral  *peripheral;
@property (strong, nonatomic) NSNumber      *RSSI;

- (id)initWithPeripheral:(CBPeripheral*)peripheral andRRSI:(NSNumber*)rssi;

@end
