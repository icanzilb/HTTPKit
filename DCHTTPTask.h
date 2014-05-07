////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCHTTPTask.h
//
//  Created by Dalton Cherry on 5/5/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCTask.h"
#import "DCHTTPRequestSerializer.h"

@interface DCHTTPResponse : NSObject

/**
 The response headers when the request finishes.
 */
@property(nonatomic,strong)NSDictionary *headers;

/**
 The response object that is returned after the responseSerializer is returned.
 */
@property(nonatomic,strong)id response;

@end

@interface DCHTTPTask : DCTask

/**
 The url you want to load.
 */
@property(nonatomic,copy)NSString *url;

/**
 The parameters you want to send with the request.
 */
@property(nonatomic,strong)NSDictionary *parameters;

/**
 The serializer you want to encode the parameters with. Default is to use the standard DCHTTPRequestSerializer.
 */
@property(nonatomic,strong)id<DCHTTPRequestSerializerDelegate> requestSerializer;

/**
 The serializer you want to encode the response with (JSON,XML,etc). Default is nil, which means a NSData object will be returned.
 */
@property(nonatomic,strong)id responseSerializer;

/**
 The HTTP method for this request. The default is GET.
 @see NSMutableURLRequest -setHTTPMethod:
 */
@property (nonatomic, copy) NSString *HTTPMethod;

/**
 This sets that the url request needs to be downloaded to disk.
 */
@property(nonatomic,assign,getter = isDownload)BOOL download;

/**
 Factory method to create a request.
 */
+(DCHTTPTask*)GET:(NSString*)url;

@end
