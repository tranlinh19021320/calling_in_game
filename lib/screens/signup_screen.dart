import 'package:calling_in_game/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool is_loading = false;
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _accountTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  final FocusNode _accountFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  int is_state_account = IS_DEFAULT_ACCOUNT;
  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
    _accountTextController.dispose();
    _passwordTextController.dispose();

    _accountFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  void navigateToSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
              height: 36,
            ),
            //Text field for email
            TextFormField(
              controller: _emailTextController,
              decoration: InputDecoration(
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: greyColor,
                )),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: (is_state_account == IS_DEFAULT_ACCOUNT)
                      ? blueColor
                      : (is_state_account == IS_CORRECT_ACCOUNT)
                          ? greenColor
                          : redColor,
                )),
              ),
              keyboardType: TextInputType.emailAddress,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_accountFocusNode);
              },
            ),

            (is_state_account == IS_DEFAULT_ACCOUNT)
                ? const Text(' ')
                : (is_state_account == IS_CORRECT_ACCOUNT)
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
                  color: greyColor,
                )),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: (is_state_account == IS_DEFAULT_ACCOUNT)
                      ? blueColor
                      : (is_state_account == IS_CORRECT_ACCOUNT)
                          ? greenColor
                          : redColor,
                )),
              ),
              keyboardType: TextInputType.text,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
            ),

            //notificate account
            (is_state_account == IS_DEFAULT_ACCOUNT)
                ? const Text(' ')
                : (is_state_account == IS_CORRECT_ACCOUNT)
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
              keyboardType: TextInputType.text,
              onEditingComplete: () {
                setState(() {
                  is_loading = true;
                });
              },
            ),
            //notificate account
            const Text(''),

            const SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  is_loading = true;
                });
              },
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
                child: is_loading
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
            SizedBox(
              height: 4,
            )
          ],
        ),
      ),
    );
  }
}
