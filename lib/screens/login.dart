import 'package:blog_app/constant.dart';
import 'package:blog_app/models/api_response.dart';
import 'package:blog_app/screens/home.dart';
import 'package:blog_app/screens/register.dart';
import 'package:blog_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

  void login() async {
    ApiResponse response = await loginController(email.text, password.text);
    if (response.error == null) {
      saveAndRedirect(response.data as User);
    } else {
      showAlert("${response.error}");
    }
    setState(() {
      isLoading = false;
    });
  }

  void showAlert(String text) {
    alert(context, text);
  }

  void saveAndRedirect(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token!);
    await pref.setInt('userId', user.id!);
    navigateToHome();
  }

  void navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: email,
              validator: (value) => value == '' ? 'Wajib di isi ya...' : null,
              decoration: inputDecoration(
                  hint: "Fill your Email",
                  label: "Email",
                  icon: const Icon(Icons.email)),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: password,
                validator: (value) => value == '' ? 'Wajib di isi ya...' : null,
                decoration: inputDecoration(
                    hint: "Fill your password",
                    label: "Password",
                    icon: const Icon(Icons.lock))),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        login();
                      }
                    },
              style: buttonStyle(),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Dont have account yet ?"),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Register(),
                      ),
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
