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

@interface DemoTableViewController ()

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

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self.debug = YES;
    
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Demo"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
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
