import 'package:flutter/material.dart';

const baseURL = "http://192.168.45.59:8000/api";
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const postURL = '$baseURL/post';
const commentURL = '$baseURL/comments';

const serverError = "server error";
const unauthorized = "unauthorized";
const somethingWentWrong = "Someting went wrong, try again";

InputDecoration inputDecoration(
        {required String hint, required String label, required Icon icon}) =>
    InputDecoration(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 20.0,
      ),
      prefixIcon: icon,
      hintText: hint,
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );

ButtonStyle buttonStyle() => ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(15),
      shape: const StadiumBorder(),
    );

void alert(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}