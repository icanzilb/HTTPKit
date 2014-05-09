////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCHTTPResponseSerializer.h
//
//  Created by Dalton Cherry on 5/8/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@protocol DCHTTPResponseSerializerDelegate <NSObject>

/**
 This is used to serialize the request response into any format desired.
 This method is called when a request is going to be sent.
 @param: response is the NSURLResponse for the request.
 @param: data is the payload from the request.
 @param: error should be set to a value if an error occurs while parsing and serializing the response.
 @return: This is the new object that the data has been formed into.
 */
-(id)responseObjectFromResponse:(NSURLResponse*)response
                           data:(NSData*)data
                          error:(NSError *__autoreleasing *)error;

@end

/**
 This is a base class for simplicity sake
 */
@interface DCHTTPResponseSerializer : NSObject<DCHTTPResponseSerializerDelegate>

/**
 The string encoding used to serialize and decode the payload with.
 */
@property (nonatomic, assign) NSStringEncoding stringEncoding;

@end

/**
 This is a JSON parser because most HTTP APIs use JSON and Apple has a builtin parser
 */
@interface DCJSONResponseSerializer : DCHTTPResponseSerializer


@end
