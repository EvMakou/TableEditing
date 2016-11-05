//
//  Student.h
//  Trenin2
//
//  Created by supermacho on 23.10.16.
//  Copyright © 2016 supermacho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;



+ (NSString*) randomAlphanumericString;

+ (NSString *) randomStringWithLength: (int) len;


+ (Student*) randStudent;



@end
