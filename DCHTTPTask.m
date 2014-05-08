////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCHTTPTask.m
//
//  Created by Dalton Cherry on 5/5/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCHTTPTask.h"

@interface DCHTTPTask ()

@property(nonatomic,strong)DCAsyncTask asyncTask;

@end

@implementation DCHTTPTask

////////////////////////////////////////////////////////////////////////////////////////////////////
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.HTTPMethod = @"GET";
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)willStart
{
    NSError *error = nil;
    if(!self.requestSerializer)
        self.requestSerializer = [DCHTTPRequestSerializer new];
    NSURLRequest *request = [self.requestSerializer requestBySerializingUrl:[NSURL URLWithString:self.url]
                                                                     method:self.HTTPMethod
                                                                 parameters:self.parameters error:&error];
    if(error)
    {
        self.asyncTask = ^(DCAsyncTaskSuccess success, DCAsyncTaskFailure failure) {
            failure(error);
        };
        return;
    }
    //DCHTTPRequestSerializerRequestType type = [self.requestSerializer requestType];
    self.asyncTask = ^(DCAsyncTaskSuccess success, DCAsyncTaskFailure failure) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          if(error) {
                                              failure(error);
                                          } else {
                                              DCHTTPResponse *payload = [DCHTTPResponse new];
                                              payload.headers = [(NSHTTPURLResponse*)response allHeaderFields];
                                              payload.response = data;
                                              success(payload);
                                          }
                                      }];
        
        [task resume];
    };
}
////////////////////////////////////////////////////////////////////////////////////////////////////
+(DCHTTPTask*)GET:(NSString*)url parameters:(NSDictionary*)parameters
{
    DCHTTPTask *task = [[self class] taskWithURL:url parameters:parameters];
    return task;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
+(DCHTTPTask*)GET:(NSString*)url
{
    return [[self class] GET:url parameters:nil];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
+(DCHTTPTask*)HEAD:(NSString*)url parameters:(NSDictionary*)parameters
{
    DCHTTPTask *task = [[self class] taskWithURL:url parameters:parameters];
    task.HTTPMethod = @"HEAD";
    return task;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
+(DCHTTPTask*)HEAD:(NSString*)url
{
    return [[self class] HEAD:url parameters:nil];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
+(DCHTTPTask*)DELETE:(NSString*)url parameters:(NSDictionary*)parameters
{
    DCHTTPTask *task = [[self class] taskWithURL:url parameters:parameters];
    task.HTTPMethod = @"DELETE";
    return task;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
+(DCHTTPTask*)POST:(NSString*)url parameters:(NSDictionary*)parameters
{
    DCHTTPTask *task = [[self class] taskWithURL:url parameters:parameters];
    task.HTTPMethod = @"POST";
    return task;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
+(DCHTTPTask*)PUT:(NSString*)url parameters:(NSDictionary*)parameters
{
    DCHTTPTask *task = [[self class] taskWithURL:url parameters:parameters];
    task.HTTPMethod = @"PUT";
    return task;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
+(DCHTTPTask*)taskWithURL:(NSString*)url parameters:(NSDictionary*)parameters
{
    DCHTTPTask *task = [DCHTTPTask new];
    task.url = url;
    task.parameters = parameters;
    return task;
}
////////////////////////////////////////////////////////////////////////////////////////////////////

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DCHTTPResponse

@end
