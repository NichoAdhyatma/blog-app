import 'package:blog_app/models/api_response.dart';
import 'package:blog_app/screens/home.dart';
import 'package:blog_app/screens/login.dart';
import 'package:blog_app/services/user_service.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String token = '';
  late ApiResponse response;

  void checkToken() async {
    token = await getToken();
    setState(() {});
  }

  @override
  void initState() {
    checkToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return token.isEmpty ? const Login() : const Home();
  }
}
