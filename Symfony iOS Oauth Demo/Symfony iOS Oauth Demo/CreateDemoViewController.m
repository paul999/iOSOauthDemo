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
#import <NXOAuth2.h>

@interface CreateDemoViewController () <NXOAuth2ConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *demotitle;
@property (weak, nonatomic) IBOutlet UITextField *demodesc;
@property (weak, nonatomic) IBOutlet UIButton *save;

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
    self.save.enabled = true;
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
    
    self.demodesc.layer.borderColor=[[UIColor clearColor]CGColor];
    self.demodesc.layer.cornerRadius = 0;
}

- (IBAction)createDemo:(id)sender {
    NSLog(@"Saving...");
    
    NSString *title = self.demotitle.text;
    NSString *desc = self.demodesc.text;
    
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
            self.demodesc.layer.cornerRadius=8.0f;
            self.demodesc.layer.borderColor=[[UIColor redColor]CGColor];
            self.demodesc.layer.borderWidth= 1.0f;
            
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
        self.save.enabled = FALSE;
        [self createDemoOnServer:title desc:desc];
    }
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    NSLog(@"Got a managed context");
}

- (void)createDemoOnServer:(NSString *)title
                      desc:(NSString *)desc
{
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]init];
    [dt setValue:title forKey:@"title"];
    [dt setValue:desc forKey:@"description"];
    
    NSData *jsonData;
    
    if ([NSJSONSerialization isValidJSONObject:dt]) {
        
        NSError *error;
        jsonData = [NSJSONSerialization dataWithJSONObject:dt options:NSJSONWritingPrettyPrinted error:&error];
        
        if (error != nil)
        {
            NSLog(@"Error creating JSON data: %@", error);
            return;
        }
    }
    else
    {
        return;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);  // To verify the jsonString.
    
    
    NXOAuth2Request *theRequest = [[NXOAuth2Request alloc] initWithResource:[NSURL URLWithString:@"http://api.ip-6.nl/demos"]
                                                                     method:@"POST"
                                                                 parameters:nil];
    theRequest.account = self.account;
    
    NSMutableURLRequest *sigendRequest = [[theRequest signedURLRequest] mutableCopy];
    
    [sigendRequest setHTTPMethod:@"POST"];
    [sigendRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [sigendRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [sigendRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [sigendRequest setHTTPBody:jsonData];
    
    
    NXOAuth2Connection *connection = [[NXOAuth2Connection alloc] initWithRequest:sigendRequest
                                                               requestParameters:nil
                                                                     oauthClient:self.account.oauthClient
                                                          sendingProgressHandler:nil
                                                                 responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                                                                     NSLog(@"Done creating :) %@", error);
                                                                     
                                                                     [Demo getDataFromClient:self.account inManagedObjectContent:self.managedObjectContext refresh: nil completionHandler:NULL];
                                                                     self.save.enabled = true;
                                                                     
                                                                     if (error)
                                                                     {
                                                                         // Might do something here?
                                                                         NSLog(@"ERR");
                                                                     }
                                                                     
                                                                     [self.navigationController popViewControllerAnimated:YES];
                                                                 }];
    connection.delegate = self;
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
