import 'package:calling_in_game/screens/signup_screen.dart';
import 'package:calling_in_game/server/firebase_auth.dart';
import 'package:calling_in_game/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../responsives/responsive.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isloading = false;
  final TextEditingController _accountTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  late FocusNode _accountFocusNode;
  final FocusNode _passwordFocusNode = FocusNode();

  int _isStateAccount = IS_DEFAULT;
  int _isStatePassword = IS_DEFAULT;

  @override
  void initState() {
    super.initState();
    _accountFocusNode = FocusNode();
    _accountFocusNode.addListener(() {
      if (!_accountFocusNode.hasFocus && _accountTextController.text != '') {
        checkAlreadyAccount();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _accountTextController.dispose();
    _passwordTextController.dispose();

    _accountFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  void logIn() async {
    setState(() {
      _isloading = true;
      _passwordFocusNode.unfocus();
    });

    String res = "";
    String email = _accountTextController.text;
    if (!isValidEmail(_accountTextController.text)) {
      var snapUser = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: _accountTextController.text)
          .get();
      email = snapUser.docs.first.data()['email'];
    }
    res = await Auth()
        .login(email: email, password: _passwordTextController.text);

    setState(() {
      _isloading = false;
    });

    if (res != "success") {
      setState(() {
        _isStatePassword = IS_ERROR;
      });
    } else {
      setState(() {
        _isStatePassword = IS_DEFAULT;
      });
      showSnackBar(context, "Đăng nhập thành công!", false);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ResponsiveScreen()));
    }
  }

  void checkAlreadyAccount() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapUser;
      // check account login is email or account
      if (isValidEmail(_accountTextController.text)) {
        snapUser = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: _accountTextController.text)
            .get();
      } else {
        snapUser = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: _accountTextController.text)
            .get();
      }

      if (snapUser.docs.isNotEmpty) {
        setState(() {
          _isStateAccount = IS_CORRECT;
        });
      } else {
        setState(() {
          _isStateAccount = IS_ERROR;
        });
      }
    } catch (e) {
      showSnackBar(context, e.toString(), true);
    }
  }

  void navigateToSignup() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Container(),
              ),
              const Text(
                'Voice Chat',
                style: TextStyle(
                  fontFamily: 'MoonTime',
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                ),
              ),
              const SizedBox(
                height: 64,
              ),
              //Text field for account
              TextFormField(
                focusNode: _accountFocusNode,
                controller: _accountTextController,
                decoration: InputDecoration(
                  labelText: 'Tài khoản hoặc email',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: (_isStateAccount == IS_DEFAULT)
                        ? greyColor
                        : (_isStateAccount == IS_CORRECT)
                            ? greenColor
                            : redColor,
                  )),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                    color: blueColor,
                  )),
                ),
                autofocus: true,
                keyboardType: TextInputType.text,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),

              //notificate account
              (_isStateAccount == IS_DEFAULT)
                  ? const Text(' ')
                  : (_isStateAccount == IS_CORRECT)
                      ? const Text(
                          'Tài khoản có tồn tại!',
                          style: TextStyle(color: greenColor),
                        )
                      : const Text(
                          'Không tìm thấy tài khoản!',
                          style: TextStyle(color: redColor),
                        ),

              const SizedBox(
                height: 24,
              ),

              //Text field for password
              TextFormField(
                focusNode: _passwordFocusNode,
                controller: _passwordTextController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color:
                        (_isStatePassword == IS_DEFAULT) ? greyColor : redColor,
                  )),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                    color: blueColor,
                  )),
                ),
                obscureText: true,
                keyboardType: TextInputType.text,
                onEditingComplete: logIn,
              ),
              //notificate account
              (_isStatePassword == IS_DEFAULT)
                  ? const Text(' ')
                  : const Text(
                      'Mật khẩu không chính xác!',
                      style: TextStyle(color: redColor),
                    ),

              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: logIn,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    color: blueColor,
                  ),
                  child: _isloading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: whiteColor,
                          ),
                        )
                      : const Text(
                          'Đăng nhập',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text('Không có tài khoản?'),
                  ),
                  GestureDetector(
                    onTap: navigateToSignup,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Đăng ký.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      ),
    );
  }
}
