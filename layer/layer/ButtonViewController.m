//
//  ButtonViewController.m
//  layer
//
//  Created by whbalzac on 20/08/2017.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "ButtonViewController.h"

@interface ButtonViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button;
@end

@implementation ButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.image = [UIImage imageNamed:@"2.png"];
    [self.view addSubview:self.imageView];
    
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.button.center = CGPointMake(self.view.center.x, self.view.center.y + 200);
    self.button.backgroundColor = [UIColor whiteColor];
    [self.button addTarget:self action:@selector(prepareForSegueSender:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
}
- (void)prepareForSegueSender:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"I am dealloc..");
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.button.transform = CGAffineTransformMakeRotation(-M_PI_4);
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.button.transform = CGAffineTransformIdentity;
    }];
}

@end

