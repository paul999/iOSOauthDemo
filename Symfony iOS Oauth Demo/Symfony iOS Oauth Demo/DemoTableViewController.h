//
//  DemoTableViewController.h
//  Symfony iOS Oauth Demo
//
//  Created by Paul Sohier on 09-06-14.
//  Copyright (c) 2014 Paul Sohier. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "NXOauth2.h"

@interface DemoTableViewController : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NXOAuth2Account *account;
@end
