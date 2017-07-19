//
//  ALWViewController.m
//  ALWStepper
//
//  Created by lisong on 07/19/2017.
//  Copyright (c) 2017 lisong. All rights reserved.
//

#import "ALWViewController.h"
#import "ALWStepper.h"

@interface ALWViewController ()

@end

@implementation ALWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    ALWStepper *stepper = [[ALWStepper alloc] initWithMinValue:5 maxValue:10 stepValue:1 updateValueBlock:^(NSInteger currentValue) {
        ;
    }];
    
    stepper.center = self.view.center;
    
    [self.view addSubview:stepper];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
