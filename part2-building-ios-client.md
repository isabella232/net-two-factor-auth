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

## Asking for the users number
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







