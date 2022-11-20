//
//  RNNetPrinter.m
//  RNThermalReceiptPrinter
//
//  Created by MTT on 06/11/19.
//  Copyright © 2019 Facebook. All rights reserved.
//


#import "RNNetPrinter.h"
#import "MWIFIManager.h"
#import "TscCommand.h"
#import "ImageTranster.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NSString *const EVENT_SCANNER_RESOLVED = @"scannerResolved";
NSString *const EVENT_SCANNER_RUNNING = @"scannerRunning";

@interface PrivateIP : NSObject

@end

@implementation PrivateIP

- (NSString *)getIPAddress {

    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];

                }

            }

            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;

}

@end

@implementation RNNetPrinter

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents
{
    return @[EVENT_SCANNER_RESOLVED, EVENT_SCANNER_RUNNING];
}

RCT_EXPORT_METHOD(init:(RCTResponseSenderBlock)successCallback
                  fail:(RCTResponseSenderBlock)errorCallback) {
    connected_ip = nil;
    is_scanning = NO;
    _printerArray = [NSMutableArray new];
    successCallback(@[@"Init successful"]);
}

RCT_EXPORT_METHOD(connectPrinter:(NSString *)host
                  withPort:(nonnull NSNumber *)port
                  success:(RCTResponseSenderBlock)successCallback
                  fail:(RCTResponseSenderBlock)errorCallback) {
    [[MWIFIManager shareWifiManager] MConnectWithHost:host port:9100 completion: ^(BOOL result){
            if (result) {
                connected_ip = host;
                successCallback(@[@"Connected"]);
            } else {
                errorCallback(@[@"Connection failed"]);
            }
    }];
}


RCT_EXPORT_METHOD(sendClearTSCCommand:(RCTResponseSenderBlock)successCallback fail:(RCTResponseSenderBlock)errorCallback) {
    if(!connected_ip) {
        errorCallback(@[@"No printer connected"]);
        return;
    }

    NSData *cls = [TscCommand cls];
    [[MWIFIManager shareWifiManager]  MWriteCommandWithData:cls withResponse:^(NSData *data1) {
        successCallback(@[@"Clear command sent"]);
    }];
}

RCT_EXPORT_METHOD(sendBeepTSCCommand:(nonnull NSNumber*)level andInterval:(nonnull NSNumber*)interval  success:(RCTResponseSenderBlock)successCallback fail:(RCTResponseSenderBlock)errorCallback) {
    if(!connected_ip) {
        errorCallback(@[@"No printer connected"]);
        return;
    }

    NSData *beep = [TscCommand soundWithLevel:[level intValue] andInterval:[interval intValue]];
    [[MWIFIManager shareWifiManager]  MWriteCommandWithData:beep withResponse:^(NSData *data1) {
        successCallback(@[@"Beep command sent"]);
    }];
}

RCT_EXPORT_METHOD(sendSetLabelSizeTSCCommand:(NSNumber*)width height:(NSNumber*)height  success:(RCTResponseSenderBlock)successCallback fail:(RCTResponseSenderBlock)errorCallback) {
    if(!connected_ip) {
        errorCallback(@[@"No printer connected"]);
        return;
    }

    NSData *beep = [TscCommand sizeBymmWithWidth:[width doubleValue] andHeight:[height doubleValue]];
    [[MWIFIManager shareWifiManager]  MWriteCommandWithData:beep withResponse:^(NSData *data1) {
        successCallback(@[@"SetLabelSize command sent"]);
    }];
}

RCT_EXPORT_METHOD(sendDelayTSCCommand:(NSNumber*)delay success:(RCTResponseSenderBlock)successCallback fail:(RCTResponseSenderBlock)errorCallback) {
    if(!connected_ip) {
        errorCallback(@[@"No printer connected"]);
        return;
    }

    NSData *command = [TscCommand delay:[delay intValue]];
    [[MWIFIManager shareWifiManager]  MWriteCommandWithData:command withResponse:^(NSData *data1) {
        successCallback(@[@"Delay command sent"]);
    }];
}

RCT_EXPORT_METHOD(sendEOJTSCCommand:(RCTResponseSenderBlock)successCallback fail:(RCTResponseSenderBlock)errorCallback) {
    if(!connected_ip) {
        errorCallback(@[@"No printer connected"]);
        return;
    }

    NSData *command = [TscCommand eoj];
    [[MWIFIManager shareWifiManager]  MWriteCommandWithData:command withResponse:^(NSData *data1) {
        successCallback(@[@"EOJ command sent"]);
    }];
}

RCT_EXPORT_METHOD(sendPrintCommand:(RCTResponseSenderBlock)successCallback fail:(RCTResponseSenderBlock)errorCallback) {
    if(!connected_ip) {
        errorCallback(@[@"No printer connected"]);
        return;
    }

    NSData *command = [TscCommand print:1];
    [[MWIFIManager shareWifiManager]  MWriteCommandWithData:command withResponse:^(NSData *data1) {
        successCallback(@[@"Print command sent"]);
    }];
}

RCT_EXPORT_METHOD(disconnect:(RCTResponseSenderBlock)successCallback fail:(RCTResponseSenderBlock)errorCallback) {
    if(!connected_ip) {
        errorCallback(@[@"No printer connected"]);
        return;
    }
    [[MWIFIManager shareWifiManager] MDisConnect];
    connected_ip = nil;
    successCallback(@[@"Disconnected"]);
}

RCT_EXPORT_METHOD(sendImageCommand:(NSString *)base64Qr success:(RCTResponseSenderBlock)successCallback fail:(RCTResponseSenderBlock)errorCallback) {
    @try {
        if(!connected_ip) {
            errorCallback(@[@"No printer connected"]);
            return;
        }
        if([base64Qr isEqual: @""]){
            errorCallback(@[@"No image"]);
            return;
        }
        NSURL *url = [NSURL URLWithString:base64Qr];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:imageData];
        NSData *dataImage = UIImagePNGRepresentation(image);
        if(image == nil) {
            errorCallback(@[@"error image convert"]);
        }
        NSData *data = [TscCommand bitmapWithX:0 andY:0 andMode:0 andImage:image andBmpType:0 andPaperHeight:240];
        [[MWIFIManager shareWifiManager]  MWriteCommandWithData:data withResponse:^(NSData *data1) {
            successCallback(@[@"Image command sent"]);
        }];
     } @catch (NSException *exception) {
        errorCallback(@[exception.reason]);
     }
}

RCT_EXPORT_METHOD(sendImageWithOptionsCommand:(NSString *)base64Qr printerOptions:(NSDictionary *)options success:(RCTResponseSenderBlock)successCallback fail:(RCTResponseSenderBlock)errorCallback) {
    @try {
        if(!connected_ip) {
            errorCallback(@[@"No printer connected"]);
            return;
        }
        if([base64Qr isEqual: @""]){
            errorCallback(@[@"No image"]);
            return;
        }
        NSNumber* width = [options valueForKey:@"width"];
        NSNumber* height = [options valueForKey:@"height"];
        NSNumber* paperHeight = [options valueForKey:@"paperHeight"];
        NSURL *url = [NSURL URLWithString:base64Qr];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:imageData];
        UIImage* printImage = [self getPrintImage:image width:width height:height];
        NSData *dataImage = UIImagePNGRepresentation(image);
        if(image == nil) {
            errorCallback(@[@"error image convert"]);
        }
        NSData *data = [TscCommand bitmapWithX:0 andY:0 andMode:0 andImage:printImage andBmpType:0 andPaperHeight:[paperHeight intValue]];
        [[MWIFIManager shareWifiManager]  MWriteCommandWithData:data withResponse:^(NSData *data1) {
            successCallback(@[@"Image command sent"]);
        }];
     } @catch (NSException *exception) {
        errorCallback(@[exception.reason]);
     }
}

-(UIImage *)getPrintImage:(UIImage *)image width:(NSNumber*)width height:(NSNumber*)height {
     CGFloat newWidth = [width doubleValue];
     CGFloat _newHeight = [height doubleValue];
     CGSize newSize = CGSizeMake(newWidth, _newHeight);
     UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
     [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return newImage;
}

@end
