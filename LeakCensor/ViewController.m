//
//  ViewController.m
//  LeakCensor
//
//  Created by tonbright on 2020/3/31.
//  Copyright © 2020 tonbright. All rights reserved.
//

#import "ViewController.h"
#import "TestJumpViewController.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)jumpBtnClick:(id)sender {
    TestJumpViewController *jumpViewController = [TestJumpViewController new];
    [self.navigationController pushViewController:jumpViewController animated:YES];
}


@end
