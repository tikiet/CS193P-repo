//
//  Tag.h
//  FlickrViewer
//
//  Created by nemo1 on 1/26/13.
//  Copyright (c) 2013 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *belongsTo;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addBelongsToObject:(Photo *)value;
- (void)removeBelongsToObject:(Photo *)value;
- (void)addBelongsTo:(NSSet *)values;
- (void)removeBelongsTo:(NSSet *)values;

@end
