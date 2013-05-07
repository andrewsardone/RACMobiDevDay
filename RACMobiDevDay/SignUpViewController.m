#import "SignUpViewController.h"
#import "APIClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *confirmEmailField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end

@implementation SignUpViewController

- (id)init
{
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    RACSignal *formValid = [RACSignal
        combineLatest:@[
            self.firstNameField.rac_textSignal,
            self.lastNameField.rac_textSignal,
            self.emailField.rac_textSignal,
            self.confirmEmailField.rac_textSignal,
        ]
        reduce:^(NSString *firstName, NSString *lastName, NSString *email, NSString *confirmEmail) {
            return @(firstName.length > 0
                    && lastName.length > 0
                    && email.length > 0
                    && confirmEmail.length > 0
                    && [email isEqualToString:confirmEmail]);
        }];

    RACCommand *createAccountCommand = [RACCommand commandWithCanExecuteSignal:formValid];
    RACSignal *networkResults = [[[createAccountCommand
       addSignalBlock:^RACSignal *(id value) {
           return [[APIClient.sharedClient createAccountForEmail:self.emailField.text
                                                      firstName:self.firstNameField.text
                                                       lastName:self.lastNameField.text]
                   materialize];
       }]
       switchToLatest]
       deliverOn:[RACScheduler mainThreadScheduler]];

    // bind create button's UI state and touch action
    [[self.createButton rac_signalForControlEvents:UIControlEventTouchUpInside] executeCommand:createAccountCommand];

    RACSignal *buttonEnabled = RACAbleWithStart(createAccountCommand, canExecute);
    RAC(self.createButton.enabled) = buttonEnabled;

    UIColor *defaultButtonTitleColor = self.createButton.titleLabel.textColor;
    RACSignal *buttonTextColor = [buttonEnabled map:^id(NSNumber *x) {
        return x.boolValue ? defaultButtonTitleColor : [UIColor lightGrayColor];
    }];

    [self.createButton rac_liftSelector:@selector(setTitleColor:forState:)
                            withObjects:buttonTextColor, @(UIControlStateNormal)];

    // bind button and text field state to create account command executing state

    RACSignal *executing = RACAble(createAccountCommand, executing);

    RACSignal *fieldTextColor = [executing map:^id(NSNumber *x) {
        return x.boolValue ? [UIColor lightGrayColor] : [UIColor blackColor];
    }];

    RAC(self.firstNameField.textColor) = fieldTextColor;
    RAC(self.lastNameField.textColor) = fieldTextColor;
    RAC(self.emailField.textColor) = fieldTextColor;
    RAC(self.confirmEmailField.textColor) = fieldTextColor;

    RACSignal *notExecuting = [executing not];

    RAC(self.firstNameField.enabled) = notExecuting;
    RAC(self.lastNameField.enabled) = notExecuting;
    RAC(self.emailField.enabled) = notExecuting;
    RAC(self.confirmEmailField.enabled) = notExecuting;

    [executing subscribeNext:^(NSNumber *x) {
        x.boolValue ? [self.loadingIndicator startAnimating] : [self.loadingIndicator stopAnimating];
        self.statusLabel.textColor = [UIColor lightGrayColor];
    }];

    // Derive the status label's text and color from our network result
    RAC(self.statusLabel.text) = [networkResults map:^id(RACEvent *x) {
        return x.eventType == RACEventTypeError ? x.error.localizedFailureReason
                                                : NSLocalizedString(@"Thanks for signing up!", nil);
    }];
    RAC(self.statusLabel.textColor) = [networkResults map:^id(RACEvent *x) {
        return x.eventType == RACEventTypeError ? [UIColor redColor]
                                                : [UIColor greenColor];
    }];
}

@end
