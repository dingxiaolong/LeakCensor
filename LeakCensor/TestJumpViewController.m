//
//  TestJumpViewController.m
//  LeakCensor
//
//  Created by tonbright on 2020/4/7.
//  Copyright © 2020 tonbright. All rights reserved.
//

#import "TestJumpViewController.h"

@interface TestJumpViewController ()
typedef void(^TestBlock)();
@property (nonatomic,copy)TestBlock testBlock;
@end

@implementation TestJumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.testBlock = ^{
        self.view.backgroundColor = [UIColor redColor];
    };
}



- (void)dealloc {
    NSLog(@"我被释放了");
}
- (IBAction)testBtnClick:(id)sender {
    if (self.testBlock) {
        self.testBlock();
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
