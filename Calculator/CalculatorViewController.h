//
//  CalculatorViewController.h
//  Calculator
//
//  Created by LoveBingbing on 12/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController <UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *description;

@end
