//
//  PinLun+CoreDataProperties.h
//  Hcard
//
//  Created by 黄传家 on 16/5/29.
//  Copyright © 2016年 黄传家. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PinLun.h"

NS_ASSUME_NONNULL_BEGIN

@interface PinLun (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cont;
@property (nullable, nonatomic, retain) NSNumber *plID;
@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Dynamic *dy;
@property (nullable, nonatomic, retain) User *use;

@end

NS_ASSUME_NONNULL_END
