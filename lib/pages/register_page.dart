import 'dart:io';

import 'package:chatpack/widgets/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../services/media_service.dart';
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';

import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';
import '../widgets/rounded_image.dart';

import '../providers/authentication_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late DatabaseService db;
  late CloudStorageService cloudStorageService;

  String? email;
  String? password;
  String? name;

  PlatformFile? profileImage;
  final registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthenticationProvider>(context);
    db = GetIt.instance<DatabaseService>();
    cloudStorageService = GetIt.instance<CloudStorageService>();

    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.03, vertical: deviceHeight * 0.02),
        // horizontal: deviceWidth * 0.3,
        // vertical: deviceHeight * 20),
        height: deviceHeight * 0.98,
        width: deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileImageField(),
            SizedBox(height: deviceHeight * 0.05),
            registerForm(),
            SizedBox(height: deviceHeight * 0.05),
            registerButton(),
            SizedBox(height: deviceHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget profileImageField() {
    return GestureDetector(
      onTap: () async {
        PlatformFile? selectedImage =
            await GetIt.instance<MediaService>().pickImageFromLibrary();
        if (selectedImage != null) {
          setState(() {
            profileImage = selectedImage;
          });
        }
      },
      child: profileImage != null
          ? RoundedImageFile(
              key: UniqueKey(),
              image: File(profileImage!.path!), // Pass the File object
              size: deviceHeight * 0.15,
            )
          : RoundedImageNetwork(
              key: UniqueKey(),
              imagePath: "https://i.pravatar.cc/1000?img=65",
              size: deviceHeight * 0.15,
            ),
    );
  }

  Widget registerForm() {
    return Container(
        height: deviceHeight * 0.35,
        child: Form(
          key: registerFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextFormField(
                  onSaved: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  regEx: r'.{6,}',
                  hintText: "Name",
                  obscureText: false),
              CustomTextFormField(
                  onSaved: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  regEx:
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  hintText: "Email",
                  obscureText: false),
              CustomTextFormField(
                  onSaved: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  regEx: r".{6,}",
                  hintText: "Password",
                  obscureText: true),
            ],
          ),
        ));
  }

  Widget registerButton() {
    return RoundedButton(
      name: "Register",
      height: deviceHeight * 0.065,
      width: deviceWidth * 0.65,
      onPressed: () async {
        if (registerFormKey.currentState!.validate() && profileImage != null) {

          registerFormKey.currentState!.save();
          String? uid =
              await auth.registerUserUsingEmailAndPassword(email!, password!);
          String? imageURL = await cloudStorageService.saveUserImageToStorage(
              uid!, profileImage!);
              await db.createUser(uid, name!, email!, imageURL!);
              await auth.logOut();
              await auth.loginUsingEmailAndPassword(email!, password!);
        }
      },
    );
  }

  



}
