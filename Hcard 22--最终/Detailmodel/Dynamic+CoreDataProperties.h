//
//  Dynamic+CoreDataProperties.h
//  Hcard
//
//  Created by 黄传家 on 16/5/23.
//  Copyright © 2016年 黄传家. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Dynamic.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dynamic (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) id image;
@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) NSNumber *contentID;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
