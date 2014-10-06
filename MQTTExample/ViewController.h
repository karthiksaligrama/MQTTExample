//
//  ViewController.h
//  MQTTExample
//
//  Created by Karthik Saligrama on 10/6/14.
//  Copyright (c) 2014 Karthik Saligrama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UITextField *txtPubMessage;
- (IBAction)btnPubMessage:(id)sender;

@end

