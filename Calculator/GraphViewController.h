//
//  GraphViewController.h
//  Calculator
//
//  Created by Zhe Sun on 12/20/12.
//  Copyright (c) 2012 CocoaXcode.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@protocol GraphViewControllerDelegate <NSObject>

- (id)resultOfProgramWithVariableValues:(NSDictionary *)variableValues;

@end


@interface GraphViewController : UIViewController

@property (weak, nonatomic) id <GraphViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *descriptionOfProgram;

@end
