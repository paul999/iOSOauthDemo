//
//  Demo+Create.m
//  Symfony iOS Oauth Demo
//
//  Created by Paul Sohier on 20-06-14.
//  Copyright (c) 2014 Paul Sohier. All rights reserved.
//

#import "Demo+Create.h"

@implementation Demo (Create)


+ (Demo *)createDemo:(NSString *)title
                desc:(NSString *)desc
            serverId:(NSNumber *)serverId
inManagedObjectContext:(NSManagedObjectContext *)context
{
    Demo *demo = nil;
    if ([title length] && [desc length])
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Demo"];
        request.predicate = [NSPredicate predicateWithFormat:@"serverId = %@", serverId];
        
        NSError *erro;
        NSArray *matches = [context executeFetchRequest:request error:&erro];
        
        if (!matches || [matches count] == 0)
        {
            demo = [NSEntityDescription insertNewObjectForEntityForName:@"Demo" inManagedObjectContext:context];
        }
        else
        {
            demo = [matches firstObject];
        }
        demo.title = title;
        demo.desc = desc;
        demo.serverId = serverId;
    }
    else
    {
        NSLog((@"Missing title or desc."));
    }
    return demo;
}

@end
