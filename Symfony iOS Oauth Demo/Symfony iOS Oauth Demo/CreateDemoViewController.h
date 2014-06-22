//
//  CreateDemoViewController.h
//  Symfony iOS Oauth Demo
//
//  Created by Paul Sohier on 21-06-14.
//  Copyright (c) 2014 Paul Sohier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXOauth2.h"

@interface CreateDemoViewController : UIViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NXOAuth2Account *account;
@end
