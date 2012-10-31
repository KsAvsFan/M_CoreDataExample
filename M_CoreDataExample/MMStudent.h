//
//  MMStudent.h
//  M_CoreDataExample
//
//  Created by Jamie Thomason on 10/29/12.
//  Copyright (c) 2012 Jamie Thomason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MMStudent : NSManagedObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * age;

@end
