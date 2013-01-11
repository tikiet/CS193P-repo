//
//  CalculatorViewController.h
//  Calculator
//
//  Created by nemo on 1/4/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *history;
@property (weak, nonatomic) IBOutlet UILabel *variableLabel;
@end
