//
//  VacationHelper.m
//  FlickrViewer
//
//  Created by nemo1 on 1/24/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "VacationHelper.h"

@interface VacationHelper()
@end

static UIManagedDocument *_document;
static NSString *_vacationName;
static NSManagedObjectContext *_context;

@implementation VacationHelper

+ (void)setCurrentContext:(NSManagedObjectContext *)context
{
    _context = context;
}

+ (NSManagedObjectContext *)currentContext
{
    return _context;
}

+ (UIManagedDocument *)currentDocument
{
    return _document;
}

+ (UIManagedDocument *)sharedManagedDocumentForVacation:(NSString *)vacationName
{
    if ([vacationName isEqualToString:_vacationName])
        return _document;
    else{
        _vacationName = vacationName;
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                             inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:vacationName];
        _document = [[UIManagedDocument alloc] initWithFileURL:url];
        return _document;
    }
}
@end