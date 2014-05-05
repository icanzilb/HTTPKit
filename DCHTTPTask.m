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
-(void)willStart
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    self.asyncTask = ^(DCAsyncTaskSuccess success, DCAsyncTaskFailure failure) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          if(error) {
                                              failure(error);
                                          } else {
                                              success(data);
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
