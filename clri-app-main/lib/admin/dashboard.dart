import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List with Toggle',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final String apiUrl = "https://ck4us6dr3f.execute-api.ap-south-1.amazonaws.com/GetAPIList?key1=ap-south-1_42bjYYcRU"; // Replace with your API endpoint

  List<dynamic> users = [];

  // Fetch the users from the API
  Future<void> fetchUsers() async {
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
  
        print("parse data: $data");
        

        setState(() {
          users = data['users']; // Parse users from API response
        });
      } else {
        print('Failed to load users: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Users Access')),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
  
                final user = users[index];

                // Extract email and custom:isVarified
                final email = user['Attributes'].firstWhere((attr) => attr['Name'] == 'email')['Value'];

                  
                final    isVarified = user['Attributes'].firstWhere((attr) => attr['Name'] == 'custom:isVarified')['Value'];
           

                // Convert isVarified to a boolean
                bool isToggled = isVarified == "1";

                return ListTile(
                  title: Text(email),
                  subtitle: Text('User ID: ${user['Username']}'),
                  trailing: Switch(
                    value: isToggled,
                    onChanged: (newValue) {
                      setState(() {
                        isToggled = newValue;
                        user['Attributes']
                            .firstWhere((attr) => attr['Name'] == 'custom:isVarified')['Value'] =
                            newValue ? "1" : "0";
                      });

                      // Call a function to update the value in Cognito
                      updateCustomAttribute(user['Username'], newValue ? "1" : "0");
                    },
                  ),
                );
              },
            ),
    );
  }

  // Function to update the custom attribute in Cognito
  Future<void> updateCustomAttribute(String username, String isVarified) async {
    try {

    String URL = "https://77nrm84skb.execute-api.ap-south-1.amazonaws.com/test?userPoolId=ap-south-1_42bjYYcRU";

    URL = URL + "&" + "username=" + username + "&" + "attrivalue=" + isVarified;

 
      final response = await http.post(
        Uri.parse(URL), // Replace with your update API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username,
          "customAttributes": {"custom:isVarified": isVarified}
        }),
      );

      if (response.statusCode == 200) {
        print('User attribute updated successfully.');
      } else {
        print('Failed to update attribute: ${response.body}');
      }
    } catch (e) {
      print('Error updating attribute: $e');
    }
  }
}
