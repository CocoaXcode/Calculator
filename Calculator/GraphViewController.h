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

- (id)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
- (NSString *)descriptionOfProgram:(id)program;

@end


@interface GraphViewController : UIViewController

@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) UIBarButtonItem *splitViewBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *descriptionOnToolbar;
@property (weak, nonatomic) IBOutlet UILabel *descriptionOnGraph;
@property (weak, nonatomic) id <GraphViewControllerDelegate> delegate;
@property (strong, nonatomic) id program;

@end
