#import "APIClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString * const APIClientDefaultEndpoint = @"http://localhost:4567";

@implementation APIClient

+ (instancetype)sharedClient
{
    static APIClient *apiClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiClient = [APIClient new];
    });
    return apiClient;
}

- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:APIClientDefaultEndpoint]];
    if (self) {
        AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
        [self registerHTTPOperationClass:AFJSONRequestOperation.class];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

- (RACSignal *)createAccountForEmail:(NSString *)email
                           firstName:(NSString *)firstName
                            lastName:(NSString *)lastName
{
    RACSubject *subject = [RACSubject subject];

    [self postPath:@"/accounts"
        parameters:@{ @"first_name": firstName, @"last_name": lastName, @"email": email, }
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               [subject sendNext:responseObject];
               [subject sendCompleted];
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               id responseJSON = nil;
               if ([operation respondsToSelector:@selector(responseJSON)]) {
                   responseJSON = [(id)operation responseJSON];
               }
               [subject sendError:[NSError errorWithDomain:@"com.example"
                                                code:error.code
                                            userInfo:@{
                                                NSLocalizedFailureReasonErrorKey: [responseJSON valueForKey:@"error"]
                                                                                  ?: @"Failed to create account"
                                            }]];
           }];

    return subject;
}

@end
