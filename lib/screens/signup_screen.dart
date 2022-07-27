import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../responsive/responsive_layout_screen.dart';
import '../screens/login_screen.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import '../resources/auth_methods.dart';
import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
  bool _isLoading = false;

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

  void signUpUser() async {
    if (_image == null) {
      showSnackBar('Please pick an Image', context);
      return;
    }
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'Success') {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: ((context) => const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout(),
              )),
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
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
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3,
                  )
                : const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Flexible(flex: 1, child: Container()),
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
                    onTap: signUpUser,
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
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor),
                            )
                          : const Text('Sign Up'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Flexible(flex: 1, child: Container()),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text('Dont have an account?'),
              ),
              GestureDetector(
                onTap: navigateToLogin,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    'Sign in.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        // const SizedBox(height: 12),
      ),
    );
  }
}
