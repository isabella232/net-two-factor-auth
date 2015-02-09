# Part 2 - building a ios client to for number for verificaiton.

In part 1 of this tutorial we created serverside code to generate codes that are sent by sms to a phone number. In this second part we are going to implement the number verification part for a mobile device. And in the third part we are going to add the two factor part to the ios client and a website. This tutorial will take about 30 mins to complete. 

## Prerequisites
1. Finish part one of this tutorial, or download the repo [https://github.com/sinch/net-two-factor-auth]()
2. Versed in iOS development
3. Xcode 6

## iOS cocoa touch frameworks 

I wanted to have a framework that I could reuse in many of my apps that would be super easy to implement with a few lines of code. So I wanted to be able to drop the framework in to my project and just call a method to start validating my number. In this tutorial I am using the new template in xcode 6 to create cocoa touch frameworks.

So the vision for this framework is that you would just drop in an app and call a method to get the party started. The framework will display an View asking for the phonenumber and when you click next show a view to enter the code. Finally validate the code and  dismiss the view. 

## Setup
1. Create a workspace name it NumberValidator
2. Create a new Cocoa Touch Framework ![](images/part2/createproject.png)
3. Add it to the workspace ![](images/part2/addtoworkspace.png)

Repeat step 1 -3 but add a Single Page application and call it NumberValidatorSampleApp

When you are finished your workspace should look like this.
![](images/part2/workspace_finished.png)

## Setting the scene
Create a storyboard in NumberValidator and name it **NumberValidatorStoryBoard** and add a one **NavigationController** and two view controllers so it looks like this.
![](images/part2/storyboard.png)
It doesnt show that good on the image, but add a label just below the next and done buttons. Also add a UIActivity and center it in the views.

## Collecting user number
Create a controller called **EnterPhoneNumberViewController** 
Set it as the class for the EnterPhoneNumber view. 
Connect outlets for the Enter Phonenumber textfield, the label and Activityindicator

```objectivec
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

```
Next add actions for the cancel button and nextbuttons 

```
- (IBAction)next:(id)sender {
}

- (IBAction)cancel:(id)sender {
}
```

Having set up that we are not ready to implement some code. Lets start with the cancel action first. When the user presses cancel we want to dismiss the view

```objectivec
- (IBAction)cancel:(id)sender {
    [[self parentViewController] dismissViewControllerAnimated:YES completion:^{
    /// notify that user canceled
    }];
}
```

## Requesting the OTP
in the next action we want to request an OTP code form the server and continue to the entercode scene

```objectivec
- (IBAction)next:(id)sender {
    NSURLSession* sessionManager = [NSURLSession sharedSession];
    [self.spinner startAnimating]; //Show progress
    errorLabel.text = @"";
    NSString* url = [@"http://server/api/otp?phoneNumber=" stringByAppendingString:phoneNumber.text];
    [[sessionManager downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
          [self.spinner stopAnimating];
            [phoneNumber resignFirstResponder];
            if (error == nil)
            {
                [self performSegueWithIdentifier:@"enterCode" sender:nil];
            }
            else
            {
                errorLabel.text = @"Something went wrong";
                //show some error message
            }
    }] resume];
}
```

Before we go to the next scene we have to pass the phoneNumber to the ViewController of EnterCode scene.

1. Add a ViewController to your project name it **EnterCode** and set it to be the viewController of the EnterCode scene.
2. create a string property phoneNumber in **EnterCodeViewController.h** `@property NSString* phoneNumber;`
3. Change the prepareForSegue to look like below.

```
 if ([segue.identifier isEqualToString:@"enterCode"])
    {
        EnterCodeViewController* vc = [segue destinationViewController];
        vc.phoneNumber = self.phoneNumber.text; 
    }
```


##Verifying the code
Open up the storyboard and connect the textfield, label and spinner to outlets.

```objectivec
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UITextField *code;
``` 
Create and action for the Done buttons, here we are calling our server and if there is no error all is good

```objectivec
- (IBAction)done:(id)sender {
    [spinner startAnimating]
    errorLabel.text = @"";
    NSURLSession* sessionManager = [NSURLSession sharedSession];
    NSString* url = [NSString stringWithFormat:@"http://server/api/otp?phoneNumber=%@&code=%@", phoneNumber, code.text];
    [[sessionManager downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        [spinner stopAnimating]
        if (!error)
            [self dismissViewControllerAnimated:YES completion:nil];
        else
            errorLabel.text = @"Invalid code";
    }] resume];
}
```

This is all the UI done for this part. Next we need create a mechanism so its easy for me use the framework, and also the communicate back to the consuming app that the code was validated. Create a class and call it **ValidationHelper** 

## Validation Helper
This helper class is going to help us start a new number validation and also notify the consumer when we have a canceled or successful notification. For this helper I am going to user the static design pattern.
In **ValidationHelper.m** add the following code
```objectivec
__strong static ValidationHelper* currentValidationHelperInstance = nil;
+(ValidationHelper *)sharedValidationHelper
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentValidationHelperInstance = [[self alloc] init];
        currentValidationHelperInstance.sessionManager = [NSURLSession sharedSession];

    });
    return currentValidationHelperInstance;
}

```
and in ValidationHelper.h add the method to the interface, also add a startValidation method

```objectivec
+(ValidationHelper *)sharedValidationHelper;
-(void)startValidation
```

Now we have a way to access one and only one instance of the validation helper. Next lets a add a method that will start the validation process 

```objectivec
-(void)startValidation
{
	//Get a reference to the current window
    UIWindow* window  = [[[UIApplication sharedApplication] delegate] window];
    //You need to fetch the bundle for the framework, if you leave this as null it will load the apps bundle instead. 
    NSBundle* bundle = [NSBundle bundleWithIdentifier:@"com.sinch.NumberValidator"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ValidationStoryBoard" bundle:bundle];
    UINavigationController *vc = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"start"];
    
    [[window rootViewController] presentViewController:vc animated:true completion:^{
    }];
}

```

## Broadcasting success or cancel of verification
Since we care if the validation is successful, we need a way to tell the consumer that it is success full. There is a couple different paths to accomplish this in iOS, one is with blocks, one is with a delegate or NSNotification center events. 
Since this is a process that might take a little while and there is UI involved I felt a NSNoticication center approach is best suited (you can read more about [NSNotificationCenter](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSNotificationCenter_Class/)), So lets define  two strings with events name in a file called **NSNotificationEvents.h**

```objectivec
UIKIT_EXTERN NSString* const VALIDATION_COMPLETE;
UIKIT_EXTERN NSString* const VALIDATION_CANCELED;
UIKIT_EXTERN NSString* const PhoneNumberKey;
```
Open up EnterCodeViewController.m and add an import to NSNotificationEvents.h 
next find `done:` method and modify it so it sends notification on completion.

```
- (IBAction)done:(id)sender {
    [spinner startAnimating]
    errorLabel.text = @"";
    NSURLSession* sessionManager = [NSURLSession sharedSession];
    NSString* url = [NSString stringWithFormat:@"http://server/api/otp?phoneNumber=%@&code=%@", phoneNumber, code.text];
    [[sessionManager downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        [spinner stopAnimating]
        if (!error)
        {
			[[NSNotificationCenter defaultCenter] 
			    postNotificationName:NumberValidationDidCompleteNotification 
			    object:self 
			    userInfo:@{PhoneNumberKey: self.phoneNumber}]; 
			[self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            errorLabel.text = @"Invalid code";
        }
        
    }] resume];
}

```
And add the cancel event to the **EnterPhoneNumber.m**  find cancel action and change it to

```
- (IBAction)cancel:(id)sender {
    [[NSNotificationCenter defaultCenter] 
        postNotificationName:NumberValidationDidCancelNotification 
        object:nil];
    [[self parentViewController] 
    dismissViewControllerAnimated:YES completion:^{
    }];
}
```

## Finishing up the framework
In a framework app you need to decide which headers that should be visible, select your **NumberValidator** project, and go in to *build phases*. Drag the the header files so they look like this.
![Images/part2/publicheaders.png]()
You also want to open up the NumberValidator.h and add the following imports to make them visible with only one import in the consumer. 
```objectivec
#import "ValidationHelper.h"
#import "NSNotificationEvents.h"
```


## Creating a test client
Selet the **NumberValidatorSampleApp** and go to *build phases*, drag the Add the NumberValidator.framework to Link Binary With Libraries. Open the story **Main.Storyboard** and add a button and connect it with an action called validate.
![Images/part2/sampleappview.png]()
In ViewController.m add an import to our NumberValidator framework. 

```objectivec
#import <NumberValidator/NumberValidator.h>
```
And in the action validate add a call to star the validation

```objectivec
- (IBAction)validate:(id)sender {
    [[ValidationHelper sharedValidationHelper] startValidation];
}
```
Thats all that is needed to validate the phone. But we also want to listen if on completed and canceled events. In ViewDidLoad add the following lines of code to set up a notification on our events

```objectivec
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] 
        addObserver:self 
        selector:@selector(verificationComplete:)
        name:NumberValidationDidCompleteNotification 
        object:nil];
}
```
Notice that we have a warning now, add the method to verificationComplete
```
-(void)verificationComplete:(NSNotification*)notification
{
    NSLog(@"number validated %@", notification.object);
}
```
Last in dealoc, unregister for the notifications

```objectiveC
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] 
        removeObserver:self 
        name:NumberValidationDidCompleteNotification 
        object:nil];
}
```

Done!

## Conclusion
In this tutorial we learned both about how to build a Cocoa Frameworks reusable library, and I must say; "Finally" and easy way to make your stuff modularized in iOS. We also learned how to consume our service we created in part 1 of this series. In part 3 we will build a small website and do two factor authentication.




 





