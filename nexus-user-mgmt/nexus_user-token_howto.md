# User Tokens

This topic describes how to use user tokens to authenticate users in Sonatype Nexus Repository. Users with administrator access can create, list, get metadata and delete user tokens by using the API.

****

## Generating a User Token

Sonatype Nexus Repository generates user tokens the first time that a user accesses the token. Users need the `nx-usertoken-current` privilege to access their user tokens. For details on granting privileges, see our [Privileges help topic](privileges.html).

Sonatype Nexus Repository generates user tokens the first time that a user accesses the token. To access the *User Tokens* menu, follow these steps:

1. Select your username on the top right area of the main toolbar to manage your account.
2. In the left-hand navigation panel, select the *User Token* tab.
3. Select the *Access User Token* button.
4. In the resulting dialog, re-enter your credentials and select *Authenticate*.

Another dialog will appear containing your user token information; note that the dialog closes automatically after 1 minute.

Your user token dialog contains the following information:

- **User token name and pass codes** - Your user token name and pass codes display in separate fields. You can use these as replacements for username and password in the login dialog; you can also still use your original username and password to log into the user interface.
- **Server section for Maven settings.xml** - We also provide information for the server section of your Maven settings.xml. Note that you will need to replace ${server} with the repository id that references your Sonatype Nexus Repository instance against which you want to authenticate with your user token.
- **base64 representation** - Another field provides a base64 representation of "user:password." (for use with npm and other solutions with a username limitation of [a-z0-9] characters)

## Using a User Token for Authentication

To use your user tokens for repository authentication, you must access Nexus Repository with the user token from the command line. You would do this with a username and password by using a command like the following:
```
curl -v --user {username}:{password} http://localhost:2468/repository/bower-all/
```

To use your user token, replace username and password with your user token name and passcode separated by a colon in the curl command line:
```
curl -v --user {token name code}:{token pass code} http://localhost:2468/repository/bower-all/
```

## Reset a User Token

Resetting your user token will invalidate your previous one. If you need a new user token, you will then need to generate a new one as detailed in *[Accessing and Generating Your User Token](user-tokens.html#generating-a-user-token-162134)*. To reset your user token, take the following steps:
1. Select your username on top right area of the main toolbar.
2. In the left-hand navigation panel, select the *User Token* tab.
3. Select the *Reset user token* button.
4. In the resulting dialog, re-enter your credentials and select *Authenticate*.

## User Token Expiration

User tokens are _currently_ set to expire after 30 days. You can view the time remaining until your user token expires:
1. Select your username on the top right area of the main toolbar to manage your account.
2. In the left-hand navigation panel, select the *User Token* tab.
3. Locate the *User Token Status* section, which provides the date and time when your user token is set to expire.
4. If your token has already expired, you will see that the status is set to "Expired," and a warning box will appear letting you know that you must select the *Generate User Token* button to generate a new user token.
