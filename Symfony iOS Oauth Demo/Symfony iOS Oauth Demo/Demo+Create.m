//
//  Demo+Create.m
//  Symfony iOS Oauth Demo
//
//  Created by Paul Sohier on 20-06-14.
//  Copyright (c) 2014 Paul Sohier. All rights reserved.
//

#import "Demo+Create.h"
#import <NXOAuth2.h>

@implementation Demo (Create)

+ (void)getDataFromClient:(NXOAuth2Account *)account
   inManagedObjectContent:(NSManagedObjectContext *)context
                  refresh:(UIRefreshControl *)refresh
        completionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [NXOAuth2Request performMethod:@"GET"
                        onResource:[NSURL URLWithString:@"http://api.ip-6.nl/demos"]
                   usingParameters:nil
                       withAccount:account
               sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) { // e.g., update a progress indicator
                   NSLog(@"Send %llu total %llu", bytesSend, bytesTotal);
               }
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                       if (error)
                       {
                           if (completionHandler)
                           {
                               completionHandler(UIBackgroundFetchResultFailed);
                           }
                           return;
                       }
                       
                       NSError* err;
                       NSDictionary* json = [NSJSONSerialization
                                             JSONObjectWithData:responseData
                                             options:kNilOptions
                                             error:&err];
                       
                       NSArray* dataArray = [json objectForKey:@"demos"];
                       
                       NSMutableArray* avail = [[NSMutableArray alloc] init];
                       
                       for (NSDictionary *row in dataArray)
                       {
                           NSString *title = [row objectForKey:@"title"];
                           NSString *desc = [row objectForKey:@"description"];
                           
                           
                           NSNumber *server = [NSNumber numberWithLong:
                                               [[row objectForKey:@"id"] integerValue]];
                           
                           [avail addObject:server];
                           [self createDemo:title desc:desc serverId:server inManagedObjectContext:context];
                       }
                       
                       
                       // Delete old crap
                       NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Demo"];
                       
                       NSError *erro;
                       NSArray *matches = [context executeFetchRequest:request error:&erro];
                       
                       if ([matches count])
                       {
                           for (Demo *dm in matches)
                           {
                               if (![avail containsObject:dm.serverId])
                               {
                                   NSLog(@"Deleting %@", dm.serverId);
                                   [context deleteObject:dm];
                               }
                           }
                       }
                       if (refresh)
                       {
                           [refresh endRefreshing];
                       }
                       
                       if (completionHandler)
                       {
                           completionHandler(UIBackgroundFetchResultNewData);
                       }
                   }];
}

+ (Demo *)findDemo:(NSNumber *)serverId
inManagedObjectContext:(NSManagedObjectContext *)context
{
    Demo *demo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Demo"];
    request.predicate = [NSPredicate predicateWithFormat:@"serverId = %@", serverId];
    
    NSError *erro;
    NSArray *matches = [context executeFetchRequest:request error:&erro];
    
    if (matches)
    {
        demo = [matches firstObject];
    }
    
    return demo;
}

+ (Demo *)createDemo:(NSString *)title
                desc:(NSString *)desc
            serverId:(NSNumber *)serverId
inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSLog(@"Creating a demo with title %@, desc %@ and server %@", title, desc, serverId);
    
    Demo *demo = nil;
    if ([title length] && [desc length])
    {
        demo = [self findDemo:serverId inManagedObjectContext:context];
        
        if (demo == nil)
        {
            demo = [NSEntityDescription insertNewObjectForEntityForName:@"Demo" inManagedObjectContext:context];
        }
        
        demo.title = title;
        demo.desc = desc;
        demo.serverId = serverId;
        
        NSError *err;
        
        [context save:&err];
        
        if (err)
        {
            NSLog(@"Err %@ %@", err.localizedDescription, err.description);
        }
        else{
            NSLog(@"Saved fine");
        }
    }
    else
    {
        NSLog((@"Missing title or desc."));
    }
    return demo;
}

+ (void)deleteDemo:(NSNumber *)serverId
inManagedObjectContext:(NSManagedObjectContext *)context
{
    Demo *demo = [self findDemo:serverId inManagedObjectContext:context];
    
    [context deleteObject:demo];
}

@end
