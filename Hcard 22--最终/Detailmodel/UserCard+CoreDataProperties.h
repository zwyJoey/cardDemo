//
//  UserCard+CoreDataProperties.h
//  Hcard
//
//  Created by 黄传家 on 16/5/26.
//  Copyright © 2016年 黄传家. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCard (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cardID;
@property (nullable, nonatomic, retain) id card;

@end

NS_ASSUME_NONNULL_END
