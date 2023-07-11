import 'dart:math';

import 'package:calling_in_game/screens/home_screen.dart';
import 'package:calling_in_game/screens/login_screen.dart';
import 'package:calling_in_game/server/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isloading = false;
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _accountTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  late FocusNode _emailFocusNode;
  late FocusNode _accountFocusNode;
  final FocusNode _passwordFocusNode = FocusNode();

  int _isStateAccount = IS_DEFAULT_ACCOUNT;
  int _isStateEmail = IS_DEFAULT_ACCOUNT;
  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus && _emailTextController.text != '') {
        checkAlreadyEmail();
      }
    });

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
    _emailTextController.dispose();
    _accountTextController.dispose();
    _passwordTextController.dispose();

    _emailFocusNode.dispose();
    _accountFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  void signUp() async {
    setState(() {
      _isloading = true;
      _passwordFocusNode.unfocus();
    });

    String res = await Auth().signUp(
        email: _emailTextController.text,
        username: _accountTextController.text,
        password: _passwordTextController.text,
        avatarIndex: Random().nextInt(10) + 1);

    setState(() {
      _isloading = false;
    });

    if (res != "success") {
      showSnackBar(context, res, true);
    } else {
      showSnackBar(context, "Đăng ký thành công!", false);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  void checkAlreadyAccount() async {
    try {
      if (_accountTextController.text == '') {
        setState(() {
          _isStateAccount = IS_DEFAULT_ACCOUNT;
        });
      } else {
        var snapUser = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: _accountTextController.text)
            .get();

        if (snapUser.docs.isNotEmpty) {
          setState(() {
            _isStateAccount = IS_ERROR_ACCOUNT;
          });
        } else {
          setState(() {
            _isStateAccount = IS_CORRECT_ACCOUNT;
          });
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString(), true);
    }
  }

  void checkAlreadyEmail() async {
    try {
      if (_emailTextController.text == '') {
        setState(() {
          _isStateEmail = IS_DEFAULT_ACCOUNT;
        });
      } else {
        if (!isValidEmail(_emailTextController.text)) {
          showSnackBar(context, "Email sai định dạng!", true);
          setState(() {
            _isStateEmail = IS_ERROR_ACCOUNT;
          });
        } else {
          var snapUser = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: _emailTextController.text)
              .get();

          if (snapUser.docs.isNotEmpty) {
            setState(() {
              _isStateEmail = IS_ERROR_ACCOUNT;
            });
          } else {
            setState(() {
              _isStateEmail = IS_CORRECT_ACCOUNT;
            });
          }
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString(), true);
    }
  }

  void navigateToSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        
        padding: const EdgeInsets.all(8),
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
                  fontSize: 50,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              //Text field for email
              TextFormField(
                focusNode: _emailFocusNode,
                controller: _emailTextController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: (_isStateEmail == IS_DEFAULT_ACCOUNT)
                        ? greyColor
                        : (_isStateEmail == IS_CORRECT_ACCOUNT)
                            ? greenColor
                            : redColor,
                  )),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                    color: blueColor,
                  )),
                ),
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_accountFocusNode);
                },
              ),
      
              (_isStateEmail == IS_DEFAULT_ACCOUNT)
                  ? const Text(' ')
                  : (_isStateEmail == IS_CORRECT_ACCOUNT)
                      ? const Text(
                          'Email chưa đăng ký!',
                          style: TextStyle(color: greenColor),
                        )
                      : const Text(
                          'Email sai hoặc đã đăng ký!',
                          style: TextStyle(color: redColor),
                        ),
      
              const SizedBox(
                height: 24,
              ),
      
              //Text field for account
              TextFormField(
                focusNode: _accountFocusNode,
                controller: _accountTextController,
                decoration: InputDecoration(
                  labelText: 'Tên tài khoản',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: (_isStateAccount == IS_DEFAULT_ACCOUNT)
                        ? greyColor
                        : (_isStateAccount == IS_CORRECT_ACCOUNT)
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
                onFieldSubmitted: (String _) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
      
              //notificate account
              (_isStateAccount == IS_DEFAULT_ACCOUNT)
                  ? const Text(' ')
                  : (_isStateAccount == IS_CORRECT_ACCOUNT)
                      ? const Text(
                          'Tài khoản chưa đăng ký!',
                          style: TextStyle(color: greenColor),
                        )
                      : const Text(
                          'Tài khoản đã tồn tại!',
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
                    color: greyColor,
                  )),
                ),
                obscureText: true,
                autofocus: true,
                keyboardType: TextInputType.text,
                onEditingComplete: signUp,
              ),
              //notificate account
              const Text(''),
      
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signUp,
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
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Đăng ký',
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
                    child: const Text('Đã có tài khoản?'),
                  ),
                  GestureDetector(
                    onTap: navigateToSignup,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Đăng Nhập.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              )
            ],
          ),
        ),
      ),
    );
  }
}
