//
//  CreateDemoViewController.m
//  Symfony iOS Oauth Demo
//
//  Created by Paul Sohier on 21-06-14.
//  Copyright (c) 2014 Paul Sohier. All rights reserved.
//

#import "CreateDemoViewController.h"
#import "Demo+Create.h"
#import <QuartzCore/QuartzCore.h>

@interface CreateDemoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *description;
@property (weak, nonatomic) IBOutlet UITextField *demotitle;

@end

@implementation CreateDemoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideColor
{
    self.demotitle.layer.borderColor=[[UIColor clearColor]CGColor];
    self.demotitle.layer.cornerRadius = 0;
    
    self.description.layer.borderColor=[[UIColor clearColor]CGColor];
    self.description.layer.cornerRadius = 0;
}

- (IBAction)createDemo:(id)sender {
    NSLog(@"Saving...");
    
    NSString *title = self.demotitle.text;
    NSString *desc = self.description.text;
    NSNumber *serverId = [NSNumber numberWithInt:arc4random()];
    
    if ([title length] == 0 || [desc length] == 0)
    {
        if ([title length] == 0)
        {
            self.demotitle.layer.cornerRadius=8.0f;
            self.demotitle.layer.borderColor=[[UIColor redColor]CGColor];
            self.demotitle.layer.borderWidth= 1.0f;
            
            NSLog(@"Missing title");
            
        }
        if ([desc length] == 0)
        {
            self.description.layer.cornerRadius=8.0f;
            self.description.layer.borderColor=[[UIColor redColor]CGColor];
            self.description.layer.borderWidth= 1.0f;
            
            NSLog(@"Missing desc");
        }
        
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(hideColor)
                                       userInfo:nil
                                        repeats:NO];
    }
    else
    {
        [Demo createDemo:title desc:desc serverId:serverId inManagedObjectContext:self.managedObjectContext];
        
        NSLog(@"Created demo with serverId %@", serverId);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    NSLog(@"Got a managed context");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
