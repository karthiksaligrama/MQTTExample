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
    
    client = [[MQTTClient alloc]initWithClientId:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    client.delegate = self;
    [client connectWithHost:@"test.mosquitto.org" withSSL:NO];
    
    [client subscribeToTopic:@"/mqtt/karthik" qos:AtLeastOnce subscribeHandler:^(NSArray *qosGranted) {
        NSLog(@"subscription complete");
    }];
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
}

-(void)onMessageRecieved:(MQTTMessage *)message{
    NSString *msgString = [[NSString alloc] initWithData:[message payload] encoding:NSUTF8StringEncoding];
    NSLog(@"message recieved from the remote server");
    NSLog(@"message = %@",msgString);
    [self.lblMessage setText:msgString];
}


@end
