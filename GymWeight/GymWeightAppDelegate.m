//
//  GymWeightAppDelegate.m
//  GymWeight
//
//  Created by 박 성완 on 13. 6. 17..
//  Copyright (c) 2013년 박 성완. All rights reserved.
//

#import "GymWeightAppDelegate.h"
#import "GymWeightViewController.h"
#import "Outfit.h"

@implementation GymWeightAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // initiate GymWeightViewController
    
    // 바뀌어랑
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if ([userDefault valueForKey:@"init"]) {
        [self logPopulatedData];
    } else {
        [self populateDefault];
    }
    

    GymWeightViewController *rootViewController = [[GymWeightViewController alloc] initWithStyle:UITableViewStylePlain];
    rootViewController.managedObjectContext = self.managedObjectContext;
    
    // initiate and set up UINavigationController
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    navigationController.navigationBar.tintColor = [[UIColor alloc] initWithRed:0 green:.607843137 blue:.776470588 alpha:1.0];
    navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

-(void)populateDefault
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"암꺼두 없다 데이터 셋업을 하겠다.");
    
    // 일단 엔티티 셋업
    NSArray *nameArray = @[@"체스트 프레스", @"버터플라이", @"케이블 크로스 오버", @"벤치 프레스", @"랫 풀 다운", @"하이폴리", @"업도미널", @"숄더 프레스", @"케이블 크로스 오버", @"레그 익스텐션" ];
    
    for (NSString *name in nameArray) {
        
        // 모델 하나 생성
        Outfit *outfit = (Outfit *)[NSEntityDescription insertNewObjectForEntityForName:@"Outfit"
                                                                 inManagedObjectContext:self.managedObjectContext];
        // 모델 셋업
        [outfit setWeight:@(0)];
        [outfit setName:name];
    }
    
    // 이제 context 에 저장.
    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        // handle error
        NSLog(@"먼가 잘못됨..");
    } else {
        NSLog(@"모델들 성공적으로 추가");
    }
    
    
    [userDefault setInteger:(NSInteger)1 forKey:@"init"];
    [userDefault synchronize];
}

-(void)logPopulatedData
{
    NSLog(@"먼가 있다");
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Outfit"];
    NSError *error = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest: request error:&error];
    
    if (resultArray == nil) {
        // handle error
    }
    
    for (Outfit *outfit in resultArray) {
        NSLog(@"이 운동기구의 이름은 %@ 이고, 무게는 현재 %@이다.", outfit.name, outfit.weight );
        
    }

}
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GymWeight" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GymWeight.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
