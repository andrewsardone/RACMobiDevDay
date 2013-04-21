#import "SignUpViewController.h"
#import "APIClient.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *confirmEmailField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

// possibly inferred state
@property (strong, nonatomic) UIColor *enabledButtonColor;
@property (strong, nonatomic) UIColor *disabledButtonColor;

@property (strong, nonatomic) UIColor *defaultTextColor;
@property (strong, nonatomic) UIColor *loadingTextColor;
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

    // initial button setup
    self.enabledButtonColor = self.createButton.titleLabel.textColor;
    self.disabledButtonColor = UIColor.lightGrayColor;
    [self.createButton setTitleColor:self.disabledButtonColor forState:UIControlStateNormal];
    self.createButton.titleLabel.textColor = UIColor.lightGrayColor;
    self.createButton.enabled = NO;
    [self.createButton addTarget:self action:@selector(createButtonTouched:) forControlEvents:UIControlEventTouchUpInside];

    // initial text field setup
    self.defaultTextColor = self.firstNameField.textColor;
    self.loadingTextColor = UIColor.lightGrayColor;

    // listen on text editing changes
    [self.firstNameField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.lastNameField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.emailField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.confirmEmailField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark UIControl events

- (void)textFieldChanged:(UITextField *)textField
{
    self.createButton.enabled = self.isFormValid;
    [self.createButton setTitleColor:(self.createButton.isEnabled ? self.enabledButtonColor : self.disabledButtonColor)
                            forState:UIControlStateNormal];
}

- (void)createButtonTouched:(UIButton *)createButton
{
    [self updateUIForNetworkActivity:YES];

    self.statusLabel.textColor = UIColor.lightGrayColor;

    [APIClient.sharedClient createAccountForEmail:self.emailField.text
                                        firstName:self.firstNameField.text
                                         lastName:self.lastNameField.text
                                          success:^(id account) {
                                              self.statusLabel.textColor = [UIColor colorWithRed:0.033 green:0.640 blue:0.051 alpha:1.000];
                                              self.statusLabel.text = NSLocalizedString(@"Thanks for signing up!", nil);

                                              [self updateUIForNetworkActivity:NO];
                                          }
                                          failure:^(NSError *error) {
                                              self.statusLabel.textColor = [UIColor colorWithRed:0.727 green:0.000 blue:0.008 alpha:1.000];
                                              self.statusLabel.text = error.localizedFailureReason;

                                              [self updateUIForNetworkActivity:NO];
                                          }];
}

#pragma mark Validation

- (BOOL)isFormValid
{
    NSString *firstName = self.firstNameField.text;
    NSString *lastName = self.lastNameField.text;
    NSString *email = self.emailField.text;
    NSString *confirmEmail = self.confirmEmailField.text;

    return firstName.length > 0
            && lastName.length > 0
            && email.length > 0
            && confirmEmail.length > 0
            && [email isEqualToString:confirmEmail];
}

#pragma mark UI Updates

- (void)updateUIForNetworkActivity:(BOOL)isNetworkActivity
{
    self.createButton.enabled = !isNetworkActivity;
    [self.createButton setTitleColor:(isNetworkActivity ? self.disabledButtonColor : self.enabledButtonColor)
                            forState:UIControlStateNormal];

    self.firstNameField.enabled
        = self.lastNameField.enabled
        = self.emailField.enabled
        = self.confirmEmailField.enabled = !isNetworkActivity;

    self.firstNameField.textColor
        = self.lastNameField.textColor
        = self.emailField.textColor
        = self.confirmEmailField.textColor
        = (isNetworkActivity ? self.loadingTextColor : self.defaultTextColor);

    isNetworkActivity ? [self.loadingIndicator startAnimating] : [self.loadingIndicator stopAnimating];
}

@end
