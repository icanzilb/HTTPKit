////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCHTTPTaskManager.h
//
//  Created by Dalton Cherry on 5/9/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCHTTPTask.h"

/**
 This class is very useful to use as an API manager. 
 You can configure a base URL, default requestSerializer, responseSerializer, and shared parameters to send with every request to elimiate boilerplate.
 */

@interface DCHTTPTaskManager : NSObject

/**
 This is baseURL to use for all request (e.g. http://<api.domain.com>/1/).
 */
@property(nonatomic,copy)NSString *baseURL;

/**
 This is common requestSerializer to use for every created task.
 
 @see requestSerializer in DCHTTPTask.
 */
@property(nonatomic,strong)DCHTTPRequestSerializer *requestSerializer;

/**
 This is common responseSerializer to use for every created task. Default is DCJSONResponseSerializer.
 @see responseSerializer in DCHTTPTask.
 */
@property(nonatomic,strong)id<DCHTTPResponseSerializerDelegate> responseSerializer;

/**
 This adds a global parameter to pass with every request (e.g. auth_token would be a great example for OAuth based apps).
 @param: value is the value to add as the parameter value.
 @param: key is the key to add as the parameter key.
 */
-(void)addParameter:(id)value forKey:(NSString*)key;

/**
 This removes a previously added global parameter.
 @param: key is the parameter key to remove.
 */
-(void)removeParameter:(NSString*)key;

/**
 This is common responseSerializers to use for every created task.
 
 @see setResponseSerializer:forContentType: in DCHTTPTask.
 */
-(void)setResponseSerializer:(id<DCHTTPResponseSerializerDelegate>)responseSerializer forContentType:(NSString*)contentType;

/**
 These are the method to create new tasks from the manager. 
 These all create a new DCHTTPTask with the baseURL and resource to form the overall url.
 These also does the same merge with the global and the local parameters passed in.
 The each set the HTTPMethod to the respective method name.
 @param: resource is the resource you want to load (e.g. index.html of http://<domain>/index.html)
 @param: parameters to send along with the request.
 @return A newly initialized DCHTTPTask.
 */
-(DCHTTPTask*)GET:(NSString*)resource;
-(DCHTTPTask*)GET:(NSString*)url parameters:(NSDictionary*)parameters;
-(DCHTTPTask*)HEAD:(NSString*)url;
-(DCHTTPTask*)HEAD:(NSString*)url parameters:(NSDictionary*)parameters;
-(DCHTTPTask*)DELETE:(NSString*)url parameters:(NSDictionary*)parameters;
-(DCHTTPTask*)POST:(NSString*)url parameters:(NSDictionary*)parameters;
-(DCHTTPTask*)PUT:(NSString*)url parameters:(NSDictionary*)parameters;

@end
