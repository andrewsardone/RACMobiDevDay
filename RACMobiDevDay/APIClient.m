#import "APIClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString * const APIClientDefaultEndpoint = @"http://localhost:4567";

@implementation APIClient {
	AFHTTPRequestOperationManager *requestManager;
}

+ (instancetype)sharedClient
{
    static APIClient *apiClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiClient = [[APIClient alloc] init];
    });
    return apiClient;
}

- (id)init
{
    self = [super init];
    if (self) {
		requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:APIClientDefaultEndpoint]];
		
    }
    return self;
}

- (RACSignal *)createAccountForEmail:(NSString *)email
                           firstName:(NSString *)firstName
                            lastName:(NSString *)lastName
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		AFHTTPRequestOperation *operation = [requestManager
						POST:@"/accounts"
				  parameters:@{ @"first_name": firstName, @"last_name": lastName, @"email": email, }
					 success:^(AFHTTPRequestOperation *operation, id responseObject) {
						 [subscriber sendNext:responseObject];
						 [subscriber sendCompleted];
					 }
					 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
						 [subscriber sendError:[NSError errorWithDomain:@"com.example"
																   code:error.code
															   userInfo:@{NSLocalizedFailureReasonErrorKey : error.localizedFailureReason ?: @"Failed to create account" }]];
					 }];
		return [RACDisposable disposableWithBlock:^{
			[operation cancel];
		}];
	}];
}

@end
