//
//  Note+CoreDataProperties.h
//  Hcard
//
//  Created by ChenJS on 16/5/30.
//  Copyright © 2016年 黄传家. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *message;
@property (nullable, nonatomic, retain) Person *person;

@end

NS_ASSUME_NONNULL_END
