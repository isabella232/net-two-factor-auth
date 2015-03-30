#Number Verification, ASP.NET Identity and Two-Factor Authentication - Part 3
In Part 3 of this tutorial series, we will create an SMS provider for Microsoft Identity that comes shipped with in the .NET framework. It will take about 15 minutes.

##Prerequisites 
1. Working knowledge of C# and REST APIs
2. Visual Studio 2013 or later
3. A [Sinch account](http://sinch.com/signup)

##Setup
1. Create a new a project and name it **LoginSample**
2. Select MVC project with basic authentication

![](Images/part3/greateproject.png)

##Enable SMS for two-factor authentication with Sinch
1. In the package manager console, enter: `Install-Package Sinch.SMS`
2. Open **IdentityConfig.cs** in the **App_Start** folder and find the **SMSService** class. Add the Sinch implementation to it like this:

```csharp
public Task SendAsync(IdentityMessage message)
{
    Sinch.SMS.Client client = new Client("key", "secret");
    return client.SendSMS(message.Destination, message.Body);
}
```

Remember to replace the **key** and **secret** with your own info from the [dashboard](http://sinch.com/dashboard).

##Update the profile page to show number
In a production scenario, you would likely ask for a phone number during the registration process. In this case, we will just add it to the profile page. 

1. Open **Views\Manage\Index.cshtml** and find the **PhoneNumber** section. Uncomment it:

```html
  <dt>Phone Number:</dt>
    <dd>
        @(Model.PhoneNumber ?? "None") [
        @if (Model.PhoneNumber != null)
        {
            @Html.ActionLink("Change", "AddPhoneNumber")
            @: &nbsp;|&nbsp;
            @Html.ActionLink("Remove", "RemovePhoneNumber")
        }
        else
        {
            @Html.ActionLink("Add", "AddPhoneNumber")
        }
        ]
    </dd>
``` 
2. Also uncomment the two-factor authentication part:

```csharp
 @if (Model.TwoFactor)
{
    using (Html.BeginForm("DisableTwoFactorAuthentication", "Manage", FormMethod.Post, new { @class = "form-horizontal", role = "form" }))
    {
        @Html.AntiForgeryToken()
        <text>Enabled
        <input type="submit" value="Disable" class="btn btn-link" />
        </text>
    }
}
else
{
    using (Html.BeginForm("EnableTwoFactorAuthentication", "Manage", FormMethod.Post, new { @class = "form-horizontal", role = "form" }))
    {
        @Html.AntiForgeryToken()
        <text>Disabled
        <input type="submit" value="Enable" class="btn btn-link" />
        </text>
    }
}
```

#Testing the app
Hit **F5** and run the app. If you haven't already registered an account, click on the username in the top right corner. This will take you to the page where you can manage your profile.

![](Images/part3/profilepage.png)

1. Click Add Phone Number; remember to enter it in the international format (i.e **1**5612600684)
2. Enter the code you received in an SMS
3. Click enable two-factor authentication
4. Log off and log back in; you should now see it below:<br>
![enter code](Images/part3/entercode.png)
5. Click Next and enter the code in the following window.

![verify code](Images/part3/verifycode.png)

Now you see how easy it is to enable two-factor authentication on an ASP.NET Identity application using Sinch. 
