HTTPKit
==========

Task based, RESTful, HTTP library for iOS and OS X. Built off ConcurrentKit and NSURLSession. Tasked based is much simpler to explain in example, so check that out below. This library was mainly a learning experience of combining parts of [PromiseKit](https://github.com/mxcl/PromiseKit) and [AFNetworking](https://github.com/AFNetworking/AFNetworking) to learn more about promises and NSURLSession. That being said, it uses portions of AFNetworking code for serialization and the within ConcurrentKit, the design pattern of promiseKit. You can see that library here:

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) 
- [PromiseKit](https://github.com/mxcl/PromiseKit) 

## Examples

## GET

```objc
DCHTTPTask *task = [DCHTTPTask GET:@"http://www.vluxe.io"];
task.thenMain(^(DCHTTPResponse *response){
    NSString *str = [[NSString alloc] initWithData:response.responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"web request finished: %@",str);
}).catch(^(NSError *error){
    NSLog(@"failed to load Request: %@",[error localizedDescription]);
});
[task start];
```
The power here isn't simply the fact we preformed an HTTP request, that can be accomplished very easily from standard NSURLSession. The power here is the chainable, tasked-based approach. More information on the power of task can be found in [ConcurrentKit](https://github.com/daltoniam/ConcurrentKit). Here is another example to better drive home the power.

```objc
DCHTTPTask *task = [DCHTTPTask GET:@"http://www.vluxe.io"];
task.then(^(DCHTTPResponse *response) {
    //this is a on a background thread
    NSString *str = [[NSString alloc] initWithData:response.responseObject encoding:NSUTF8StringEncoding];
	//let's say we got a personal issue against h2 tags, but h3 tags are cool.
    str = [str stringByReplacingOccurrencesOfString:@"</h2>" withString:@"</h3>"];
    str = [str stringByReplacingOccurrencesOfString:@"<h2>" withString:@"<h3>"];
    return str;
}).thenMain(^(NSString *str) {
    //this is the main thread
    //load modified webpage into webview...
}).catch(^(NSError *error){
    NSLog(@"got an error: %@",[error localizedDescription]);
});
[task start];
```
Boom. We just made a request, did some possibly long running operation (like parsing and modifying a webpage in this example), then switch to the UI thread to update the UI. We don't suffer from rightward driving blocks and our code stays simple, clean, and totally async. You're welcome.
 
## POST

```objc
DCHTTPTask *task = [DCHTTPTask POST:@"http://domain.com/resource"
                         parameters:@{@"key": @"value",
                                      @"auth_token": @"someToken"}];
[task.requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", API_TOKEN] forHTTPHeaderField:@"Authorization"];
task.responseSerializer = [DCJSONResponseSerializer new];
task.thenMain(^(DCHTTPResponse *response){
    NSLog(@"payload: %@",response.responseObject);
    NSLog(@"finished POST task");
}).catch(^(NSError *error){
    NSLog(@"failed to upload file: %@",[error localizedDescription]);
});
[task start];
```
POST is fairly straight forward, just like GET.

## Multipart/File Upload

```objc
NSURL *fileURL = [NSURL fileURLWithPath:@"/Users/dalton/Desktop/somefile"];
DCHTTPTask *task = [DCHTTPTask POST:@"http://domain.com/upload"
                         parameters:@{@"file": [DCHTTPUpload uploadWithFile:fileURL],
                                      @"auth_token": @"someToken"}];
[task.requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", API_TOKEN] forHTTPHeaderField:@"Authorization"];
task.responseSerializer = [DCJSONResponseSerializer new];
task.thenMain(^(DCHTTPResponse *response){
    NSLog(@"payload: %@",response.responseObject);
    NSLog(@"finished upload task");
    return nil;
}).catch(^(NSError *error){
    NSLog(@"failed to upload file: %@",[error localizedDescription]);
});
[task start];
```
Multi form for file upload is very simple. Simple create a provide DCHTTPUpload object.

## Background File Download Task

```objc
DCHTTPTask *task = [DCHTTPTask GET:@"https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/ObjC_classic/FoundationObjC.pdf" parameters:nil];
task.download = YES;
[task setProgress:^(CGFloat progress) {
    NSLog(@"download task progress: %f",progress);
}];
task.then(^(DCHTTPResponse *response){
    NSURL *downloadURL = response.responseObject;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [URLs objectAtIndex:0];
    NSURL *destinationURL = [documentsDirectory URLByAppendingPathComponent:@"FoundationObjC.pdf"];
    [fileManager removeItemAtURL:destinationURL error:NULL];
    [fileManager copyItemAtURL:downloadURL toURL:destinationURL error:NULL];
    return destinationURL;
}).thenMain(^(NSURL *destinationURL) {
    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:destinationURL];
    [self.documentInteractionController setDelegate:self];
    [self.documentInteractionController presentPreviewAnimated:YES];
    return nil;
}).catch(^(NSError *error) {
        NSLog("We got an error!?!?: %@",[error localizedDescription]);
});
[task start];
```
With just a few lines we scheduled a background based task and we get notified when it finished. We leveraged background downloading from NSURLSession and then while still on the background, we copied our file to it's new permanent location, then jump back to the main thread to view the file. We even got progress notifications we could have hooked up to a progressView.

## Background Upload Task

```objc
NSURL *fileURL = [NSURL fileURLWithPath:@"/Users/dalton/Desktop/somefile"];
DCHTTPTask *task = [DCHTTPTask POST:@"http://domain.com/upload"
                         parameters:@{@"file": [DCHTTPUpload uploadWithFile:fileURL]}];
[task setProgress:^(CGFloat progress) {
    NSLog(@"upload task progress: %f",progress);
}];
[task.requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", API_TOKEN] forHTTPHeaderField:@"Authorization"];
task.responseSerializer = [DCJSONResponseSerializer new];
task.thenMain(^(DCHTTPResponse *response){
    NSLog(@"payload: %@",response.responseObject);
    NSLog(@"finished upload task");
    return nil;
}).catch(^(NSError *error){
    NSLog(@"failed to upload file: %@",[error localizedDescription]);
});
[task start];
```

This will upload a file in the background. It is important to note NSURLSession limits the **background** (only the background) upload to be a single fileURL and will ignore all parameters other than the file uploaded. This is way less than ideal, but we play with the cards we are dealt. (This limitation only exist when doing a background upload, normal uploads are fine.)

## HTTP Manager

API interaction is a very common need on mobile. HTTPKit has got you covered.
```objc
DCHTTPTaskManager *manager = [DCHTTPTaskManager new];
manager.baseURL = @"http://domain.com/1/";
[manager.requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", API_TOKEN] forHTTPHeaderField:@"Authorization"];
[manager addParameter:@"someToken" forKey:@"auth_token"];

DCHTTPTask *task = [manager GET:@"users" parameters:@{@"id": @1}];
task.thenMain(^(DCHTTPResponse *response){
    // do something with the JSON.
    return nil;
}).catch(^(NSError *error){
    NSLog(@"failed to load user request: %@",[error localizedDescription]);
});
[task start];

DCHTTPTask *otherTask = [manager POST:@"users" parameters:@{@"id": @1, @"name": @"Dalton"}];
otherTask.thenMain(^(DCHTTPResponse *response){
    // do something with the JSON.
    return nil;
}).catch(^(NSError *error){
    NSLog(@"failed to load user request: %@",[error localizedDescription]);
});
[otherTask start];
```

The tasks will be created and contain the shared data (baseURL,header value, auth_token parameter,etc). The DCHTTPTaskManager has the JSON serializer as its default serializer.

## Serializer

Each request can have a request and response serializer. These basically serialize or encode/decode the request parameters and responses. They are very simple to use. By default the HTTPRequestSerializer is used for the requestSerializer and No responseSerializer is set by default (meaning an NSData object will be returned).

```objc
DCHTTPTask *task = [manager POST:@"users" parameters:@{@"id": @1}];
//set both to be JSON serializer
task.requestSerializer = [DCJSONRequestSerializer new];
task.responseSerializer = [DCJSONResponseSerializer new];
```

You can set multiple response serializer for each different content Types as well.

```objc
[task setResponseSerializer:[DCJSONResponseSerializer new] forContentType:@"application/json"];
```
The JSONResponse serializer will only be used for that contentType and the `responseSerializer` will be used for all the rest.

## Other

There are built in methods for HEAD, DELETE, GET, POST, PUT. You aren't limited to just these HTTPMethods (verbs), but those are the most common. You can simple swap on the HTTP method like so:

```objc
DCHTTPTask *task = [DCHTTPTask GET:@"http://www.vluxe.io"];
task.HTTPMethod = @"OTHERMETHOD";
task.thenMain(^(DCHTTPResponse *response){
    NSString *str = [[NSString alloc] initWithData:response.responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"web request finished: %@",str);
    return nil;
}).catch(^(NSError *error){
    NSLog(@"failed to load Request: %@",[error localizedDescription]);
});
[task start];
```

## Install ##

The recommended approach for installing HTTPKit is via the CocoaPods package manager, as it provides flexible dependency management and dead simple installation.

via CocoaPods

Install CocoaPods if not already available:

	$ [sudo] gem install cocoapods
	$ pod setup
Change to the directory of your Xcode project, and Create and Edit your Podfile and add HTTPKit:

	$ cd /path/to/MyProject
	$ touch Podfile
	$ edit Podfile
	platform :ios, '7.0'
	#or platform :osx, '10.9'
	pod 'HTTPKit'

Install into your project:

	$ pod install

Open your project in Xcode from the .xcworkspace file (not the usual project file)

## Requirements ##

HTTPKit requires at least iOS 7/OSX 10.9 or above.


## License ##

HTTPKit is license under the Apache License.

## Contact ##

### Dalton Cherry ###
* https://github.com/daltoniam
* http://twitter.com/daltoniam
* http://daltoniam.com
