//
//  Symfony_iOS_Oauth_DemoTests.m
//  Symfony iOS Oauth DemoTests
//
//  Created by Paul Sohier on 08-06-14.
//  Copyright (c) 2014 Paul Sohier. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Demo+Create.h"

@interface Symfony_iOS_Oauth_DemoTests : XCTestCase

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation Symfony_iOS_Oauth_DemoTests

- (void)setUp {
    [super setUp];
    self.context = [self managedObjectContextForTesting];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (NSManagedObjectContext *)managedObjectContextForTesting {
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    [psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    
    [moc setPersistentStoreCoordinator:psc];
    
    return moc;
}

- (Demo *)getDemo:(NSNumber *)serverId
          context:(NSManagedObjectContext *)context
{
    return [self getDemo:serverId testReturn:YES context:context];
}
- (Demo *)getDemo:(NSNumber*)serverId
       testReturn:(BOOL)testReturn
          context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Demo"];
    request.predicate = [NSPredicate predicateWithFormat:@"serverId = %@", serverId];
    
    NSError *erro;
    NSArray *matches = [context executeFetchRequest:request error:&erro];
    
    if (testReturn)
    {
        XCTAssertTrue([matches count] == 1);
    }
    
    return [matches firstObject];
}

- (void)testDemoCreate
{
    NSString *title = @"title";
    NSString *desc = @"desc";
    NSNumber *serverID = [NSNumber numberWithInt:arc4random()];
    
    Demo *demo = [Demo createDemo:title desc:desc serverId:serverID inManagedObjectContext:self.context];
    XCTAssertTrue([title isEqualToString:demo.title]);
    XCTAssertTrue([desc isEqualToString:demo.desc]);
    
    XCTAssertEqual(serverID.intValue, demo.serverId.intValue);
    
    Demo *dm = [self getDemo:serverID context:self.context];
    
    XCTAssertTrue([title isEqualToString:dm.title]);
    XCTAssertTrue([desc isEqualToString:dm.desc]);
    XCTAssertEqual(serverID.intValue, dm.serverId.intValue);
    
    title = @"Title2";
    desc = @"Desc2";
    
    demo.title = title;
    demo.desc = desc;
    
    Demo *dm2 = [self getDemo:serverID context:self.context];
    
    XCTAssertTrue([title isEqualToString:dm2.title]);
    XCTAssertTrue([desc isEqualToString:dm2.desc]);
    XCTAssertEqual(serverID.intValue, dm2.serverId.intValue);
}

- (void)testDemoDelete
{
    NSString *title = @"title";
    NSString *desc = @"desc";
    NSNumber *serverID = [NSNumber numberWithInt:arc4random()];
    
    Demo *demo = [Demo createDemo:title desc:desc serverId:serverID inManagedObjectContext:self.context];
    
    demo = [self getDemo:serverID context:self.context];
    
    [Demo deleteDemo:serverID inManagedObjectContext:self.context];
    
    demo = [self getDemo:serverID testReturn:NO context:self.context];
    
    XCTAssertTrue(demo == nil);
}

/*
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}*/

@end
