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

@property (nonatomic, weak) IBOutlet GraphView *graphView;
@property (nonatomic, weak) IBOutlet UILabel *descriptionOnGraph;
@property (nonatomic, weak) id <GraphViewControllerDelegate> delegate;
@property (nonatomic, strong) id program;

@end
