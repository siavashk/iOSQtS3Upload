#import "s3.h"

@implementation S3

- (void)uploadFile:(NSString*)filePath completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];

    NSURL* url = [NSURL URLWithString:@"https://s3.ca-central-1.amazonaws.com/stage-ca"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW"];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"1.0" forHTTPHeaderField: @"MIME-Version"];

    NSURLSessionUploadTask* task = [session uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:filePath] completionHandler:completionHandler];
    [task resume];
}

- (void)printFile:(NSString*)filePath
{
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];

    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);

    NSLog(@"contents: %@", fileContents);

    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    NSLog(@"items = %luld", (unsigned long)[listArray count]);
}

@end
