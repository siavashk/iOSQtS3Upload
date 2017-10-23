#import "s3.h"
#import "utilities.h"
#import <QString>

int main(int argc, const char * argv[])
{
    S3Info s3Info(QString("YOUR_X_AMZ_DATE"),
      QString("YOUR_X_AMZ_CREDENTIAL"),
      QString("YOUR_X_AMZ_ALGORITHM"),
      QString("YOUR_SIGNATURE"),
      QString("YOUR_KEY"),
      QString("YOUR_POLICY"));

    QString boundary("------WebKitFormBoundary7MA4YWxkTrZu0gW");
    QString binaryFilePath = QString::fromUtf8([[[NSBundle mainBundle] pathForResource:@"test" ofType:@"bin"] UTF8String]);
    QString resultFilePath = QString::fromUtf8([[[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"test_processed.bin"] UTF8String]);

    makeBody(resultFilePath, binaryFilePath, boundary, s3Info);

    NSString* filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test_processed.bin"];

    dispatch_group_t group = dispatch_group_create();
    void (^completionHandler)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error)
        {
            NSLog(@"error = %@", error);
            return;
        }

        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result = %@", result);
        dispatch_group_leave(group);
    };

    S3* s3 = [[S3 alloc] init];

    dispatch_group_enter(group);
    [s3 uploadFile:filePath completionHandler:completionHandler];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}
