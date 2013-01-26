//
//  VacationHelper.h
//  FlickrViewer
//
//  Created by nemo1 on 1/24/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DEFAULT_VACATION_NAME @"My Vacation"

@interface VacationHelper : NSObject
+ (UIManagedDocument *)sharedManagedDocumentForVacation:(NSString *)vacationName;
+ (UIManagedDocument *)currentDocument;
+ (NSManagedObjectContext *)currentContext;
+ (void)setCurrentContext:(NSManagedObjectContext *)context;
@end
