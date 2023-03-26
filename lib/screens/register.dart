import 'package:blog_app/models/user.dart';

import 'package:blog_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../models/api_response.dart';
import 'home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirmation = TextEditingController();

  bool isLoading = false;

  void registerUser() async {
    ApiResponse response = await register(name.text, email.text, password.text);
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
      (route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            TextFormField(
              keyboardType: TextInputType.name,
              controller: name,
              validator: (value) => value == '' ? 'Wajib di isi ya...' : null,
              decoration: inputDecoration(
                  hint: "Fill your Name",
                  label: "Name",
                  icon: const Icon(Icons.person)),
            ),
            const SizedBox(
              height: 15,
            ),
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
                obscureText: true,
                controller: password,
                validator: (value) => value == '' ? 'Wajib di isi ya...' : null,
                decoration: inputDecoration(
                    hint: "Fill your password",
                    label: "Password",
                    icon: const Icon(Icons.lock))),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              obscureText: true,
              controller: passwordConfirmation,
              validator: (value) => value != password.text
                  ? 'Harus sama seperti pasword yang kamu isi...'
                  : null,
              decoration: inputDecoration(
                  hint: "Fill your password confirmation",
                  label: "Password Confirmation",
                  icon: const Icon(Icons.lock)),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  registerUser();
                }
              },
              style: buttonStyle(),
              child: const Text(
                "Register",
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
                const Text("Already have account?"),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
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
