////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCHTTPResponseSerializer.h
//
//  Created by Dalton Cherry on 5/8/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@protocol DCHTTPResponseSerializerDelegate <NSObject>

-(id)responseObjectFromResponse:(NSURLResponse*)response
                           data:(NSData*)data
                          error:(NSError *__autoreleasing *)error;

@end

@interface DCHTTPResponseSerializer : NSObject

@end
