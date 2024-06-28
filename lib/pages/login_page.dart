import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_clone/common/show_snackbar.dart';
import 'package:youtube_clone/common/widgets/bottom_bar.dart';
import 'package:youtube_clone/common/widgets/custom_button.dart';
import 'package:youtube_clone/common/widgets/custom_textfield.dart';
import 'package:youtube_clone/main.dart';
import 'package:youtube_clone/pages/account_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login-page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = supabase.auth.onAuthStateChange.listen(
      (event) async {
        final session = event.session;
        if (session != null) {
          final userId = supabase.auth.currentUser!.id;
          final user = await supabase
              .from('profiles')
              .select()
              .eq('id', userId)
              .single();
          if (user['username'] != null) {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed(BottomBar.routeName);
            }
          } else {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed(AccountPage.routeName);
            }
          }
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _authSubscription.cancel();
  }

  logInUser() async {
    try {
      final email = _emailController.text.trim();
      await supabase.auth.signInWithOtp(
          email: email,
          emailRedirectTo: 'io.supabase.youtubeclone://login-callback/');
      if (mounted) {
        showSnackBar(context, 'Check your inbox');
        _emailController.clear();
      }
      setState(() {});
    } on AuthException catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          e.message,
        );
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          'An Error Occurred!!',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/mainLogo.png',
              height: 100,
              width: 500,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: _emailController,
                      hintText: 'Email',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      text: 'Log In',
                      onTap: () {
                        logInUser();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
