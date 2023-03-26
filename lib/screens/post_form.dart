import 'dart:io';

import 'package:blog_app/constant.dart';
import 'package:blog_app/models/api_response.dart';
import 'package:blog_app/screens/login.dart';
import 'package:blog_app/services/post_service.dart';
import 'package:blog_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostForm extends StatefulWidget {
  const PostForm({super.key});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final _imagePicker = ImagePicker();
  File? _imageFile;

  Future<void> getImage() async {
    final imagePickFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (imagePickFile != null) {
      setState(() {
        _imageFile = File(imagePickFile.path);
      });
    }
  }

  Future<ApiResponse> addPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createPost(_textEditingController.text, image);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Post"),
      ),
      body: ListView(
        children: [
          Container(
            width: size.width,
            height: 200,
            decoration: BoxDecoration(
              image: _imageFile == null
                  ? null
                  : DecorationImage(
                      image: FileImage(
                        _imageFile ?? File(''),
                      ),
                      fit: BoxFit.cover),
            ),
            child: Center(
              child: IconButton(
                onPressed: () {
                  getImage();
                },
                icon: const Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.black38,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _textEditingController,
                validator: (value) =>
                    value!.isEmpty ? "Post body is required" : null,
                keyboardType: TextInputType.multiline,
                maxLines: 9,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.black38,
                      ),
                    ),
                    hintText: "Type your post here..."),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        addPost().then((response) {
                          if (response.error == null) {
                            Navigator.of(context).pop();
                          } else if (response.error == unauthorized) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                                (route) => false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${response.error}"),
                              ),
                            );
                            setState(
                              () {
                                isLoading = !isLoading;
                              },
                            );
                          }
                        });
                        setState(
                          () {
                            isLoading = !isLoading;
                          },
                        );
                      }
                    },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Add Post"),
            ),
          ),
        ],
      ),
    );
  }
}
