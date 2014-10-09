//
//  ViewController.m
//  MQTTExample
//
//  Created by Karthik Saligrama on 10/6/14.
//  Copyright (c) 2014 Karthik Saligrama. All rights reserved.
//

#import "ViewController.h"
#import <MQTT/MQTT.h>

@interface ViewController ()<MQTTMessageDelegate>{
    MQTTClient *client;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *vendorId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"%@",vendorId);
    client = [[MQTTClient alloc]initWithClientId:vendorId];
    client.delegate = self;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mosquitto.org"
                                                                              ofType:@"crt"];
    
   
    
    NSMutableDictionary *options = [[NSMutableDictionary alloc]init];
    [options setObject:filePath forKey:CA_FILE];
    [client setSSLSettings:[options copy] passwordCallback:nil];
    [client connectWithHost:@"test.mosquitto.org" withPort:8883 enableSSL:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MQTTMessageDelegate

-(void)onPublishMessage:messageId{
    NSLog(@"message with message id %ld published",(long)[messageId integerValue]);
}

-(void)onConnected:(MQTTConnectionResponseCode)rc{
    NSLog(@"mqtt connected to the remote server ");
    NSLog(@"response code %lu",rc);
    if(rc ==  0){
        [client subscribeToTopic:@"/mqtt/karthik" qos:AtLeastOnce subscribeHandler:^(NSArray *qosGranted) {
            NSLog(@"subscription complete");
        }];
    }
    
}

-(void)onMessageRecieved:(MQTTMessage *)message{
    NSString *msgString = [[NSString alloc] initWithData:[message payload] encoding:NSUTF8StringEncoding];
    NSLog(@"message recieved from the remote server");
    NSLog(@"message = %@",msgString);
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [self.lblMessage setText:msgString];
    }];
}

- (IBAction)btnPubMessage:(id)sender {
    NSString *pubMessage =     [self.txtPubMessage text];
    
    NSNumber *messageId = [client publishMessage:[[MQTTMessage alloc] initWithTopic:@"/mqtt/karthik" payload:[pubMessage dataUsingEncoding:NSUTF8StringEncoding] qos:AtLeastOnce]];
    
    NSLog(@"confirm of push message id %ld",(long)[messageId integerValue]);
}

@end
