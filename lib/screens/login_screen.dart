import 'package:calling_in_game/screens/signup_screen.dart';
import 'package:calling_in_game/utils/utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool is_loading = false;
  final TextEditingController _accountTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  int is_state_account = IS_DEFAULT_ACCOUNT;
  int is_state_password = IS_DEFAULT_ACCOUNT;

  @override
  void dispose() {
    super.dispose();
    _accountTextController.dispose();
    _passwordTextController.dispose();
  }

  void navigateToSignup() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignupScreen()));
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
              height: 64,
            ),
            //Text field for account
            TextFormField(
              controller: _accountTextController,
              decoration: InputDecoration(
                labelText: 'Tài khoản hoặc email',
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
              onEditingComplete: () {},
            ),

            //notificate account
            (is_state_account == IS_DEFAULT_ACCOUNT)
                ? const Text(' ')
                : (is_state_account == IS_CORRECT_ACCOUNT)
                    ? const Text(
                        'tài khoản có tồn tại!',
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
              controller: _passwordTextController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: greyColor,
                )),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: (is_state_password == IS_DEFAULT_ACCOUNT)
                      ? blueColor
                      : redColor,
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
            (is_state_password == IS_DEFAULT_ACCOUNT)
                ? const Text(' ')
                : const Text(
                    'Mật khẩu không chính xác!',
                    style: TextStyle(color: redColor),
                  ),

            const SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: navigateToSignup,
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
                        ),
                      )
                    : const Text(
                        'Đăng nhập',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
                    child: const Text('Đăng ký.', style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12,)
          ],
        ),
      ),
    );
  }
}
