import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/utils.dart';
import '../resources/auth_methods.dart';
import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final String assetName = 'assets/ic_instagram.svg';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget svg = SvgPicture.asset(
      assetName,
      color: primaryColor,
      height: 64,
      semanticsLabel: 'Acme Logo',
    );
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 1, child: Container()),
              svg,
              const SizedBox(height: 50),
              // Circular widget to accept and show our selected File.
              Stack(
                children: <Widget>[
                  _image != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://i.stack.imgur.com/l60Hf.png'),
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              TextFieldInput(
                textEditingController: _usernameController,
                hintText: 'Enter your Username.',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 18),
              TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter your Email Address.',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Enter your Password.',
                textInputType: TextInputType.visiblePassword,
                isPass: true,
              ),
              const SizedBox(height: 18),
              TextFieldInput(
                textEditingController: _bioController,
                hintText: 'Enter your Bio.',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 18),
              InkWell(
                onTap: () async {
                  String res = await AuthMethods().signUpUser(
                    email: _emailController.text,
                    password: _passwordController.text,
                    username: _usernameController.text,
                    bio: _bioController.text,
                    file: _image!,
                  );
                  print(res);
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor,
                  ),
                  child: const Text('Log In'),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(flex: 1, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text('Dont have an account?'),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Sign up.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Transition to signup
            ],
          ),
        ),
      ),
    );
  }
}
