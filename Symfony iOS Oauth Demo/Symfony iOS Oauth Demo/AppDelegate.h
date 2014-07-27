//
//  AppDelegate.h
//  Symfony iOS Oauth Demo
//
//  Created by Paul Sohier on 08-06-14.
//  Copyright (c) 2014 Paul Sohier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NXOAuth2.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NXOAuth2Account *account;

@end

