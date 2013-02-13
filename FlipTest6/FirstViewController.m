//
//  FirstViewController.m
//  FlipTest6
//
//  Created by Tyler Laracuente on 1/5/13.
//  Copyright (c) 2013 Tyler Laracuente. All rights reserved.
//

//view comments in swipe action method for next steps

#import "FirstViewController.h"

#define Array_Size 5

@interface FirstViewController ()
@property (strong, nonatomic) IBOutlet UIView *pageView;
@property (weak, nonatomic) IBOutlet UIView *flipView;

@property (weak, nonatomic) IBOutlet UIView *backSideView;
@property (weak, nonatomic) IBOutlet UIView *backSideView2;
@property (weak, nonatomic) IBOutlet UIView *backSideView3;
@property (weak, nonatomic) IBOutlet UIView *backSideView4;
@property (weak, nonatomic) IBOutlet UIView *backSideView5;

@property (weak, nonatomic) IBOutlet UIImageView *frontImageView;
@property (weak, nonatomic) IBOutlet UIImageView *frontImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *frontImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *frontImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *frontImageView5;

@property (strong, nonatomic) UIView *activeView;
@property (strong, nonatomic) UIView *backActiveView;
@property (strong, nonatomic) UIView *intermediateView;
@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) UIView *rightView;

@property (strong, nonatomic) NSMutableArray *frontViewArray;
@property (strong, nonatomic) NSMutableArray *backViewArray;



@property (nonatomic, assign) BOOL front;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#pragma mark - gesture setup
    
    //Double Tap gesture recognizer that calls flipAction
    UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(flipAction:)];
    singleFingerDTap.numberOfTapsRequired = 2;
    
    
    //Swipe gesture recognizers that call swipeAction
    //left Swipe
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]
                                                        initWithTarget:self
                                                                action: @selector(swipeAction:)];
    leftSwipe.direction =  UISwipeGestureRecognizerDirectionLeft; 
    
    //right swipe
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action: @selector(swipeAction:)];
    rightSwipe.direction =  UISwipeGestureRecognizerDirectionRight;
    

    //Set up gesture recognizers
    [self.flipView addGestureRecognizer:leftSwipe];
    [self.flipView addGestureRecognizer:rightSwipe];
    [self.flipView addGestureRecognizer:singleFingerDTap];
    
    
#pragma mark - view setup 
    
    //load new view arrays
    self.frontViewArray = [self loadFrontViewArray:[[NSMutableArray alloc] init]];
    self.backViewArray = [self loadBackViewArray: [[NSMutableArray alloc] init]];
    
    //initializing the default active view and its back side
    self.activeView = self.frontViewArray[2];
    self.backActiveView = self.backViewArray[2];
    
    //setting the left and right views to the left (1st) and right (3rd)
    self.rightView = self.frontViewArray[3];
    self.leftView = self.frontViewArray[1];
    
    //start by saying we are front facing, which will allow us to swipe 
    self.front = YES;
    
    //hide all views except for the middle image view and its back side
    for (UIImageView* image in self.frontViewArray){
        if (image != self.frontViewArray[2]){
            [image setHidden: YES]; 
        }
    }
    for (UIView* view in self.backViewArray){
        if (view != self.backViewArray[2]){
            [view setHidden: YES];
        }
    }
}

//FIX: set other properties to nil here when done
- (void)viewDidUnload
{
	[super viewDidUnload];
    
    self.frontImageView = nil;
    self.backSideView = nil;
    self.flipView = nil;
    self.pageView = nil;
}

//load images from events on orgsync, makes the images views, then puts the views into an array.
//DEBUG: start with a hard coded array of views
- (NSMutableArray *)loadFrontViewArray: (NSMutableArray *) viewArray 
{
    viewArray[0] = self.frontImageView;
    viewArray[1] = self.frontImageView2;
    viewArray[2] = self.frontImageView3;
    viewArray[3] = self.frontImageView4;
    viewArray[4] = self.frontImageView5;
    
    NSLog(@"Front Views Loaded"); 
    
    
    return viewArray; 
}

//load info from events on orgysnc, make the info into a button interface, put that interface view into an array, match it with its front side, and load into app. 
- (NSMutableArray *)loadBackViewArray: (NSMutableArray *) backViewArray
{
    backViewArray[0] = self.backSideView;
    backViewArray[1] = self.backSideView2;
    backViewArray[2] = self.backSideView3;
    backViewArray[3] = self.backSideView4;
    backViewArray[4] = self.backSideView5;
    
    NSLog(@"Back Views Loaded");
    
    return backViewArray; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)swipeAction:(UISwipeGestureRecognizer *)recognizer{

    if (self.front) {
        float width = self.activeView.frame.size.width;
        float height = self.activeView.frame.size.height;
        
        if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
            
            [self.rightView setFrame:CGRectMake(width, 0.0, width, height)];
            [self.flipView addSubview:self.rightView];
            [self.activeView setHidden: YES];
            [self.rightView setHidden: NO];
            
            [UIView animateWithDuration:0.33f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 [self.activeView setFrame:CGRectMake(-width, 0.0, width, height)];
                                 [self.rightView setFrame: self.activeView.frame];
                             }
                             completion:^(BOOL finished){
                                 //I would rather have a loop do this, but I couldnt figure it out
                                 if (self.activeView == self.frontViewArray[0]){
                                     self.rightView = self.frontViewArray[2];
                                     self.activeView = self.frontViewArray[1];
                                     self.leftView = self.frontViewArray[0];
                                 }
                                 else if (self.activeView == self.frontViewArray[1]) {
                                     self.rightView = self.frontViewArray[3];
                                     self.activeView = self.frontViewArray[2];
                                     self.leftView = self.frontViewArray[1];
                                 }
                                 else if (self.activeView == self.frontViewArray[2]) {
                                     self.rightView = self.frontViewArray[4];
                                     self.activeView = self.frontViewArray[3];
                                     self.leftView = self.frontViewArray[2];
                                     
                                 }
                                 else if (self.activeView == self.frontViewArray[3]) {
                                     self.rightView = self.frontViewArray[4];
                                     self.activeView = self.frontViewArray[4];
                                     self.leftView = self.frontViewArray[3];
                                     
                                 }
                                 else if (self.activeView == self.frontViewArray[4]) {
                                     self.rightView = self.frontViewArray[4];
                                     self.activeView = self.frontViewArray[4];
                                     self.leftView = self.frontViewArray[3];
                                     
                                 }
                                 else {
                                     self.rightView = self.frontViewArray[3];
                                     self.activeView = self.frontViewArray[2];
                                     self.leftView = self.frontViewArray[1];
                                     
                                 }
                            }];
            
            NSLog(@"Left Swipe");
                                
        }
        else {
            
            [self.leftView setFrame:CGRectMake(-width, 0.0, width, height)];
            [self.flipView addSubview:self.leftView];
            [self.activeView setHidden: YES];
            [self.leftView setHidden: NO];
            
            [UIView animateWithDuration:0.33f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 [self.leftView setFrame: self.activeView.frame];
                                 [self.activeView setFrame:CGRectMake(width, 0.0, width, height)];
                             }
                             completion:^(BOOL finished){
                                 
                                 //I would rather have a loop do this, but I couldnt figure it out
                                 if (self.activeView == self.frontViewArray[0]){
                                     self.rightView = self.frontViewArray[1];
                                     self.activeView = self.frontViewArray[0];
                                     self.leftView = self.frontViewArray[0];
                                 }
                                 else if (self.activeView == self.frontViewArray[1]) {
                                     self.rightView = self.frontViewArray[1];
                                     self.activeView = self.frontViewArray[0];
                                     self.leftView = self.frontViewArray[0];
                                 }
                                 else if (self.activeView == self.frontViewArray[2]) {
                                     self.rightView = self.frontViewArray[2];
                                     self.activeView = self.frontViewArray[1];
                                     self.leftView = self.frontViewArray[0];
                                     
                                 }
                                 else if (self.activeView == self.frontViewArray[3]) {
                                     self.rightView = self.frontViewArray[3];
                                     self.activeView = self.frontViewArray[2];
                                     self.leftView = self.frontViewArray[1];
                                     
                                 }
                                 else if (self.activeView == self.frontViewArray[4]) {
                                     self.rightView = self.frontViewArray[4];
                                     self.activeView = self.frontViewArray[3];
                                     self.leftView = self.frontViewArray[2];
                                     
                                 }
                                 else {
                                     self.rightView = self.frontViewArray[3];
                                     self.activeView = self.frontViewArray[2];
                                     self.leftView = self.frontViewArray[1];
                                     
                                 }
                            }];

            NSLog(@"Right Swipe"); 
        }
    }
    
}
- (IBAction)flipAction:(id)sender
{
    //if the active view is the front one, change it to the back one with a right flip animation
    if(self.front){
        [UIView transitionFromView:self.activeView
                            toView:self.backActiveView
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromRight + UIViewAnimationOptionShowHideTransitionViews
                        completion:^(BOOL finished){
                            //change the active view to the back one
                            self.front = NO;
                            NSLog(@"Flipped from right, show back");
                            }];
        
        
    }
    
    //else, the active view is the back one, changeit to the front one with a left flip animation
    else {
         [UIView transitionFromView:self.activeView
                             toView:self.backActiveView
                           duration:1
                            options: UIViewAnimationOptionTransitionFlipFromLeft + UIViewAnimationOptionShowHideTransitionViews
                         completion:^(BOOL finished){
                             //change the active view to the front one
                             self.front = YES;
                             NSLog(@"Flipped from left, show front");
         }];
        
        
        
    }
    self.intermediateView = self.activeView;
    self.activeView = self.backActiveView;
    self.backActiveView = self.intermediateView;
    
}
@end
