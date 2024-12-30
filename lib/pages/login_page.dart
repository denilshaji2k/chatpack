import 'package:chatpack/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';
import '../services/navigation_service.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late NavigationService navigation;
  final _loginFormKey = GlobalKey<FormState>();
  String? email;
  String? password;

  @override
  void initState() {
    super.initState();
    navigation = GetIt.instance.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context, listen: false);
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: deviceHeight * 0.98,
        width: deviceWidth * 0.97,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pageTitle(),
            _loginForm(),
             
            loginButton(),
            const SizedBox(height: 10),
            registerAccountLink(),
          ],
        ),
      ),
    ));
  }

  Widget _pageTitle() {
    return const Text(
      'ChatPack',
      style: TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _loginForm() {
    return SizedBox(
        height:200,
        child: Form(
            key: _loginFormKey,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10,),
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
                      const SizedBox(height: 20),
                      CustomTextFormField(
                      onSaved: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      regEx:
                          r".{6,}",
                      hintText: "Password",
                      obscureText: true),
                ],
                )
                )
                );
  }

  Widget loginButton() {
    return RoundedButton(
      name: "Login",
       onPressed: (){
          if(_loginFormKey.currentState!.validate()){

            _loginFormKey.currentState!.save();
            auth.loginUsingEmailAndPassword(email!, password!);
          }
       },
        height: deviceHeight*0.065 ,
         width: deviceWidth*0.65);
  }

  Widget registerAccountLink() {
    return GestureDetector(
      onTap: () {
       navigation.navigateToRoute('/register');
       
      },
      child: Container(
        child: const Text(
          'Don\'t have an account?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
    
  }
}
