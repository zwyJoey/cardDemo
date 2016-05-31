//
//  User+CoreDataProperties.h
//  Hcard
//
//  Created by 黄传家 on 16/5/24.
//  Copyright © 2016年 黄传家. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *age;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *company;
@property (nullable, nonatomic, retain) NSString *companyAddress;
@property (nullable, nonatomic, retain) NSString *companyAll;
@property (nullable, nonatomic, retain) NSString *companyTitle;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *fax;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *insterest;
@property (nullable, nonatomic, retain) NSString *marking;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *nameAll;
@property (nullable, nonatomic, retain) NSString *nameTitle;
@property (nullable, nonatomic, retain) NSString *passWord;
@property (nullable, nonatomic, retain) id pic;
@property (nullable, nonatomic, retain) NSString *post;
@property (nullable, nonatomic, retain) NSString *school;
@property (nullable, nonatomic, retain) NSString *standByTel;
@property (nullable, nonatomic, retain) NSString *tele;

@end

NS_ASSUME_NONNULL_END
