//
//  Demo+Create.h
//  Symfony iOS Oauth Demo
//
//  Created by Paul Sohier on 20-06-14.
//  Copyright (c) 2014 Paul Sohier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "demo.h"
#import <UIKit/UIKit.h>
#import <NXOAuth2.h>


@interface Demo (Create)

+ (void)getDataFromClient:(NXOAuth2Account *)account
   inManagedObjectContent:(NSManagedObjectContext *)context
                  refresh:(UIRefreshControl *)refresh
        completionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;


+ (Demo *)createDemo:(NSString *)title
                desc:(NSString *)desc
            serverId:(NSNumber *)serverId
inManagedObjectContext:(NSManagedObjectContext *)context;


+ (void)deleteDemo:(NSNumber *)serverId
inManagedObjectContext:(NSManagedObjectContext *)context;
@end
