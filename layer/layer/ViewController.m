//
//  ViewController.m
//  layer
//
//  Created by whbalzac on 20/08/2017.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "ViewController.h"
#import "WHBubbleTransition.h"
#import "ButtonViewController.h"

@interface ViewController ()<CAAnimationDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CALayer *maskLayer;

@property (nonatomic, strong) WHBubbleTransition *transition;
@property (strong, nonatomic) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.image = [UIImage imageNamed:@"1.jpeg"];
    [self.view addSubview:self.imageView];
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.button.center = CGPointMake(self.view.center.x, self.view.center.y + 200);
    self.button.backgroundColor = [UIColor redColor];
    [self.button addTarget:self action:@selector(prepareForSegueSender:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
}

- (void)prepareForSegueSender:(id)sender {
    
    ButtonViewController *demoVC = [[ButtonViewController alloc] init];
    demoVC.transitioningDelegate = self;
    demoVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:demoVC animated:YES completion:nil];
}


-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.transition.transitionMode = WHBubbleTransitionModePresent;
    self.transition.startPoint = self.button.center;
    return self.transition;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transition.transitionMode = WHBubbleTransitionModeDismiss;
    self.transition.startPoint = self.button.center;
    return self.transition;
}

-(WHBubbleTransition *)transition
{
    if (!_transition) {
        _transition = [[WHBubbleTransition alloc] init];
    }
    return _transition;
}



@end
