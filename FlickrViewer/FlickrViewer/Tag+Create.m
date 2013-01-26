//
//  Tag+Create.m
//  FlickrViewer
//
//  Created by nemo1 on 1/26/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)

+ (Tag *)tagWithName:(NSString *)name
    inManagedContext:(NSManagedObjectContext *)context
{
    Tag *tag = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSArray *matches = [context executeFetchRequest:request error:nil];
    
    if (!matches || ([matches count] > 1)){
        // error
    } else if ([matches count] == 0){
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                            inManagedObjectContext:context];
        tag.name = name;
    } else {
        tag = [matches lastObject];
    }
    
    return tag;
}
@end
