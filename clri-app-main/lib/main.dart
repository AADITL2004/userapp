import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:project/amplifyconfiguration.dart';

 import 'package:http/http.dart' as http;

import 'package:amplify_api/amplify_api.dart' ;
import 'package:project/homepage.dart';

import 'admin/dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(const MaterialApp( home: Login() ));
  runApp( const MaterialApp(  home:MyApp( )));
 

}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
 


class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    //parsseJson();
    //  fetchUsers();
    _configureAmplify();
  }

  

Future<void> fetchUsers() async {

  final String apiUrl = "https://7z2ico8vbi.execute-api.ap-south-1.amazonaws.com/GetAPIList?key1=ap-south-1_42bjYYcRU"; // Replace with your API endpoint

      List<dynamic> users = [];

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
 
        // Decode the JSON response
       Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        print("Only Body Response: $jsonResponse");

         // Access the body
        String strUser =  jsonResponse['body'];

         print("Only Body Response: $strUser");

         final Map<String, dynamic> data =   json.decode(strUser); 
 
        // Decode JSON string into a List
        List<dynamic> users =  data['users'];

        print(users.toString());
        // Iterate through the list
        for (var user in users) 
        {
          print("ID: ${user['Username']}");
        }
        
  
      }

      
    } catch (e) {
      print('Error: $e');
    }
  }


  void parsseJson()
  {

  String jsonString = '''
        
        
          {
            "users": 
            [     
              {
                "Username": "6193dd6a-a0b1-7027-1bab-97e55e79a07b", 
                "Attributes": 
                [
                  {"Name": "email", "Value": "meeta.litake@gmail.com"},
                  {"Name": "email_verified", "Value": "true"},
                  {"Name": "name", "Value": "meeta"},
                  {"Name":   "custom:isVarified", "Value": "0"},
                  {"Name": "sub", "Value": "6193dd6a-a0b1-7027-1bab-97e55e79a07b"}
                ]
              },
              {
                "Username":"51532d6a-6091-70a1-b6ae-27ee3edb3d67", 
                "Attributes":
                [
                  {"Name": "email", "Value": "shaileshlitake@gmail.com"}, 
                  {"Name": "email_verified","Value": "true"}, 
                  {"Name": "custom:isVarified", "Value": "1"}, 
                  {"Name": "sub", "Value": "51532d6a-6091-70a1-b6ae-27ee3edb3d67"}
                ]
              }
            ]
          }
  ''';

 print(jsonString);

 final Map<String, dynamic> data =   json.decode(jsonString); 
 
  // Decode JSON string into a List
  List<dynamic> users =  data['users'];

  print(users.toString());
   // Iterate through the list
  for (var user in users) {
    print("ID: ${user['Username']}");
  }
  

  }


  void _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
      safePrint('Successfully configured');
    } on Exception catch (e) {
      safePrint('Error configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      // `authenticatorBuilder` is used to customize the UI for one or more steps
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
            return CustomScaffold(
              state: state,
              // A prebuilt Sign In form from amplify_authenticator
              body: SignInForm(),
              // A custom footer with a button to take the user to sign up
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signUp,
                    ),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.signUp:
            return CustomScaffold(
              state: state,
              // A prebuilt Sign Up form from amplify_authenticator
              body: SignUpForm(),
              // A custom footer with a button to take the user to sign in
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signIn,
                    ),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.confirmSignUp:
            return CustomScaffold(
              state: state,
              // A prebuilt Confirm Sign Up form from amplify_authenticator
              body: ConfirmSignUpForm(),
            );
          case AuthenticatorStep.resetPassword:
            return CustomScaffold(
              state: state,
              // A prebuilt Reset Password form from amplify_authenticator
              body: ResetPasswordForm(),
            );
          case AuthenticatorStep.confirmResetPassword:
            return CustomScaffold(
              state: state,
              // A prebuilt Confirm Reset Password form from amplify_authenticator
              body: const ConfirmResetPasswordForm(),
            );
          default:
            // Returning null defaults to the prebuilt authenticator for all other steps
            return null;
        }
      },
      child: MaterialApp(
        builder: Authenticator.builder(),
         home:  Scaffold(
          backgroundColor: Colors.orangeAccent,
          body: Center(
            child: Home(),
          ),
        ),
      ),
    );
  }
}

/// A widget that displays a logo, a body, and an optional footer.
class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.state,
    required this.body,
    this.footer,
  });

  final AuthenticatorState state;
  final Widget body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // App logo
              const Padding(
                padding: EdgeInsets.only(top: 32),
                child: Center(child: CustomImage(
                imagePath: 'images/yourlogo.png', // Replace with your image path
                width: 100,
                height: 100,
              )),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: body,
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: footer != null ? [footer!] : null,
    );
  }
} 


class CustomImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  const CustomImage({super.key, 
    required this.imagePath,
    this.width = 100,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
    );
  }
}
