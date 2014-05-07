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
    DCHTTPRequestSerializerRequestType type = [self.requestSerializer requestType];
    self.asyncTask = ^(DCAsyncTaskSuccess success, DCAsyncTaskFailure failure) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          if(error) {
                                              failure(error);
                                          } else {
                                              DCHTTPResponse *response = [DCHTTPResponse new];
                                              response.headers = [(NSHTTPURLResponse*)response allHeaderFields];
                                              response.response = data;
                                              success(response);
                                          }
                                      }];
        
        [task resume];
    };
}
////////////////////////////////////////////////////////////////////////////////////////////////////
+(DCHTTPTask*)GET:(NSString*)url
{
    DCHTTPTask *task = [DCHTTPTask new];
    task.url = url;
    return task;
}
////////////////////////////////////////////////////////////////////////////////////////////////////

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DCHTTPResponse

@end
