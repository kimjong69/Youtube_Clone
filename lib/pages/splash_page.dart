import 'package:flutter/material.dart';
import 'package:youtube_clone/common/widgets/bottom_bar.dart';
import 'package:youtube_clone/main.dart';
import 'package:youtube_clone/pages/account_page.dart';
import 'package:youtube_clone/pages/login_page.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = '/splash-page';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    final session = supabase.auth.currentSession;
    if (!mounted) return;
    if (session != null) {
      final userId = supabase.auth.currentUser!.id;
      final user =
          await supabase.from('profiles').select().eq('id', userId).single();
      if (user['username'] != null) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(BottomBar.routeName);
        }
      } else {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AccountPage.routeName);
        }
      }
    } else {
      Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
