//
//  AppDelegate.m
//  Hcard
//
//  Created by 黄传家 on 16/5/23.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "AppDelegate.h"

//#import "User1.h"
//#import "User.h"
//#import <CoreData/CoreData.h>
//#import "FirstViewController.h"
//#import "LoginViewController.h"
//#import "MyAdvViewController.h"
//#import "AdvertisementViewController.h"
//#import "HomePageViewController.h"
//#import "ViewController.h"
//#import "RootViewController.h"
#import "HelloViewController.h"
#import "User1.h"
#import "User.h"
#import <CoreData/CoreData.h>
#import "FirstViewController.h"
#import "LoginViewController.h"
#import "MyAdvViewController.h"
#import "AdvertisementViewController.h"
#import "HomePageViewController.h"
#import "ViewController.h"
#import <SMS_SDK/SMSSDK.h>//短信包
@interface AppDelegate ()
@property (strong,nonatomic)User *pe;
@property(strong,nonatomic) NSManagedObjectContext * managedObjectContext;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    id appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * str = [userDefaults objectForKey:@"id"];
        User1 *user = [User1 shareUser];
        user.id = str;
        // 首页
    if (str) {
        HomePageViewController *v1 = [[HomePageViewController alloc]init];
        UINavigationController *na1 = [self addController:v1 addTitle:@"third" normalImage:@"b1" selectImage:@"b2"];
        
        FirstViewController *v2 = [[FirstViewController alloc]init];
        UINavigationController *na2 = [self addController:v2 addTitle:@"third" normalImage:@"a1" selectImage:@"a2"];
        AdvertisementViewController *v3 = [[AdvertisementViewController alloc]init];
        UINavigationController *na3 = [self addController:v3 addTitle:@"third" normalImage:@"c1" selectImage:@"c2"];
        v1.title = @"详情页";
        v2.title = @"主页";
        v3.title = @"广告";

        UITabBarController *tab = [[UITabBarController alloc]init];
        tab.viewControllers = @[na2,na1,na3];
        self.window.rootViewController = tab;
        [self.window makeKeyAndVisible];
    }else{
//        LoginViewController *log = [[LoginViewController alloc]init];
//        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:log];
        HelloViewController * helloLog = [[HelloViewController alloc]init];
        self.window.rootViewController = helloLog;
}
    [SMSSDK registerApp:@"122080418bd7c" withSecret:@"05352a3f0d7427ca6b8cbe53843c61fb"];
    return YES;
}


//重写导航栏方法
-(UINavigationController *)addController:(UIViewController *)controller addTitle:(NSString *)title normalImage:(NSString *)normal selectImage:(NSString *)selectImage{
    //创建导航栏
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:controller];
    //导航图片
    [controller.tabBarItem setImage:[UIImage imageNamed:normal]];
    //渲染图片颜色
    UIImage *selectIma = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [controller.tabBarItem setSelectedImage:selectIma];
    //设置tabBar上文字的渲染颜色（控制器底部文字）
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    return na;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "apple.com.Hcard" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Hcard" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Hcard.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
