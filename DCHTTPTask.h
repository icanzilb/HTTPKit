////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCHTTPTask.h
//
//  Created by Dalton Cherry on 5/5/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCTask.h"
#import "DCHTTPRequestSerializer.h"
#import "DCHTTPResponseSerializer.h"

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
@property(nonatomic,strong)id<DCHTTPResponseSerializerDelegate> responseSerializer;

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
 Factory method to create a request with HTTPMethod of GET.
 @param: url is the full url you want to load (e.g. http://apple.com)
 @return A newly initialized DCHTTPTask.
 */
+(DCHTTPTask*)GET:(NSString*)url;

/**
 Factory method to create a request with HTTPMethod of GET.
 @param: url is the full url you want to load (e.g. http://apple.com)
 @param: parameters to send along with the request.
 @return A newly initialized DCHTTPTask.
 */
+(DCHTTPTask*)GET:(NSString*)url parameters:(NSDictionary*)parameters;

/**
 Factory method to create a request with HTTPMethod of HEAD.
 @param: url is the full url you want to load (e.g. http://apple.com)
 @return A newly initialized DCHTTPTask.
 */
+(DCHTTPTask*)HEAD:(NSString*)url;

/**
 Factory method to create a request with HTTPMethod of HEAD.
 @param: url is the full url you want to load (e.g. http://apple.com)
 @param: parameters to send along with the request.
 @return A newly initialized DCHTTPTask.
 */
+(DCHTTPTask*)HEAD:(NSString*)url parameters:(NSDictionary*)parameters;

/**
 Factory method to create a request with HTTPMethod of DELETE.
 @param: url is the full url you want to load (e.g. http://apple.com)
 @param: parameters to send along with the request.
 @return A newly initialized DCHTTPTask.
 */
+(DCHTTPTask*)DELETE:(NSString*)url parameters:(NSDictionary*)parameters;

/**
 Factory method to create a request with HTTPMethod of POST.
 @param: url is the full url you want to load (e.g. http://apple.com)
 @param: parameters to send along with the request.
 @return A newly initialized DCHTTPTask.
 */
+(DCHTTPTask*)POST:(NSString*)url parameters:(NSDictionary*)parameters;

/**
 Factory method to create a request with HTTPMethod of PUT.
 @param: url is the full url you want to load (e.g. http://apple.com)
 @param: parameters to send along with the request.
 @return A newly initialized DCHTTPTask.
 */
+(DCHTTPTask*)PUT:(NSString*)url parameters:(NSDictionary*)parameters;

@end
