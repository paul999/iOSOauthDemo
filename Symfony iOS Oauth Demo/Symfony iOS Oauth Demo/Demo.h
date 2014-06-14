//
//  Demo.h
//  Symfony iOS Oauth Demo
//
//  Created by Paul Sohier on 08-06-14.
//  Copyright (c) 2014 Paul Sohier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Demo : NSManagedObject

@property (nonatomic, retain) NSNumber * serverId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;

@end
