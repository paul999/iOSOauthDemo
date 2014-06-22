//
//  DemoTableViewController.m
//  Symfony iOS Oauth Demo
//
//  Created by Paul Sohier on 09-06-14.
//  Copyright (c) 2014 Paul Sohier. All rights reserved.
//

#import "DemoTableViewController.h"
#import "DatabaseRadio.h"
#import "Demo.h"
#import "CreateDemoViewController.h"
#import "Demo+Create.h"


#import "NXOauth2.h"
@interface DemoTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

@implementation DemoTableViewController


- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:DatabaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = note.userInfo[DatabaseAvailabilityContext];
                                                  }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (NXOAuth2Account *acc in [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"oauthDemoService"]) {
        self.account = acc;
        NSLog(@"Found a account");
        //[[NXOAuth2AccountStore sharedStore] removeAccount:acc];
        break;
    };

    if (!self.account)
    {
        [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"oauthDemoService"];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                          object:[NXOAuth2AccountStore sharedStore]
                                                           queue:nil
                                                      usingBlock:^(NSNotification *aNotification){
                                                          NSLog(@"Received OK.");
                                                          
                                                          id acc = [aNotification.userInfo objectForKey:@"NXOAuth2AccountStoreNewAccountUserInfoKey"];
                                                          if ([acc isKindOfClass:[NXOAuth2Account class]])
                                                          {
                                                              self.account = (NXOAuth2Account *) acc;
                                                              NSLog(@"Name: %@", self.account.accountType);
                                                          }
                                                          else
                                                          {
                                                              NSLog(@"Weird item");
                                                          }
                                                      }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                          object:[NXOAuth2AccountStore sharedStore]
                                                           queue:nil
                                                      usingBlock:^(NSNotification *aNotification){
                                                          NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                                                          // Do something with the error
                                                          NSLog(@"Received ERR: %@", error.localizedDescription);
                                                      }];
    }
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    
    _managedObjectContext = managedObjectContext;
    
    [self updateUI];
}
- (void)setAccount:(NXOAuth2Account *)account
{
    _account = account;
    
    [self updateUI];
}

- (void)updateUI
{
    if (self.managedObjectContext && self.account)
    {
        self.debug = YES;
        
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Demo"];
        request.predicate = nil;
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                  ascending:YES
                                                                   selector:@selector(localizedStandardCompare:)]];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        
        self.addButton.enabled = YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"demo-cell"];
    
    Demo *demo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = demo.title;
    cell.detailTextLabel.text = demo.desc;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"create-new-demo"])
    {
        CreateDemoViewController *vw = (CreateDemoViewController *) segue.destinationViewController;
        vw.managedObjectContext = self.managedObjectContext;
        vw.account = self.account;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Delete");
    Demo *demo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSNumber *serverId = demo.serverId;
    [Demo deleteDemo:serverId inManagedObjectContext: self.managedObjectContext];
}

@end
