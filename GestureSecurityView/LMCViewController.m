//
//  ViewController.m
//  GestureSecurityView
//
//  Created by LiuMingchuan on 15/10/18.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import "LMCViewController.h"
#import "LMCGestureSecurityViewController.h"

@interface LMCViewController ()

@end

@implementation LMCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *selfIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    selfIV.center = CGPointMake(self.view.center.x, 200);
    selfIV.layer.cornerRadius = 75;
    selfIV.layer.borderColor = [UIColor whiteColor].CGColor;
    selfIV.layer.borderWidth = 4;
    selfIV.layer.masksToBounds = YES;
    [selfIV setImage:[UIImage imageNamed:@"self.jpg"]];
    
    [self.view addSubview:selfIV];
    
    [self setTitle:@"LMCGestureSecurityView"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSetPWD:(id)sender {
    LMCGestureSecurityViewController *setPWDCtrl = [[LMCGestureSecurityViewController alloc]initWithNibName:@"SecurityView" bundle:nil];
    [setPWDCtrl setIsSetMode:YES];
    [self.navigationController pushViewController:setPWDCtrl animated:YES];
}

- (IBAction)btnTestPWD:(id)sender {
    LMCGestureSecurityViewController *setPWDCtrl = [[LMCGestureSecurityViewController alloc]initWithNibName:@"SecurityView" bundle:nil];
    [setPWDCtrl setIsSetMode:NO];
    [self.navigationController pushViewController:setPWDCtrl animated:YES];
}
@end
