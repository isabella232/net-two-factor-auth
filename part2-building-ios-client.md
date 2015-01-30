#Part 2 - Building A iOS Client To For Number For VerificationIn part 1 of this tutorial, we created some server side code to generate two factor authentication codes that are sent by SMS to a phone number. 

In this second part of the tutorial, we are going to implement the number verification part for a mobile device. 

And in the third part, we are going to add the two factor authenticaion service to the iOS client and a website. 

This tutorial will take about 30 mins to complete. ## Prerequisites1. Finish part one of this tutorial, or download the repo [https://github.com/sinch/net-two-factor-auth](https://github.com/sinch/net-two-factor-auth)2. A good understanding of iOS development3. Xcode 6## iOS cocoa touch frameworks I wanted to have a framework that I could reuse in many of my apps that would be super easy to implement with a few lines of code. 

So I wanted to be able to drop the framework in to my project and just call a method to start validating my number.

In this tutorial I am using the new template in Xcode 6 to create cocoa touch frameworks.The vision for this framework is that you would just drop in an app and call a method to get started. The framework will display a View asking for the phone number, and when you click next the app will show a view to enter the code. 

Finally, the app will validate the code and dismiss the view. Easy enough.## Setup1. Create a workspace, and name it **NumberValidator**2. Create a new Cocoa Touch Framework ![Cocoa Touch Framework](images/part2/createproject.png)3. Add it to the workspace ![iOS workspace](images/part2/addtoworkspace.png)Repeat step 1 -3 but add a Single Page application and call it **NumberValidatorSampleApp**.When you are finished, your workspace should look something like this:
![finished workspace](images/part2/workspace_finished.png)## Setting the SceneCreate a storyboard in **NumberValidator** and name it **NumberValidatorStoryBoard**. The add a **NavigationController** and two view controllers so it looks like this:
![storyboard](images/part2/storyboard.png)
It doesn’t look that good in this screenshot, but add a label just below the **next** and **done** buttons. Also add a **UIActivity** and center it in the views.## Asking for the users numberCreate a controller called **EnterPhoneNumberViewController**. Then set it as the class for the Cocoa Touch Framework view. 
Connect outlets for the Enter Phone number textfield, the label and **Activityindicator**:```objectivec@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;@property (weak, nonatomic) IBOutlet UILabel *errorLabel;@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;```
Finally, add actions for the cancel button and next buttons:```- (IBAction)next:(id)sender {}- (IBAction)cancel:(id)sender {}```