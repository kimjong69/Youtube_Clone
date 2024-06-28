import 'package:flutter/material.dart';
import 'package:youtube_clone/common/widgets/avatar.dart';
import 'package:youtube_clone/common/widgets/custom_button.dart';
import 'package:youtube_clone/common/widgets/custom_textfield.dart';
import 'package:youtube_clone/main.dart';
import 'package:youtube_clone/pages/home_page.dart';

class AccountPage extends StatefulWidget {
  static const String routeName = '/account-page';
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _accountFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  String? _imgUrl;

  @override
  void initState() {
    super.initState();
    _getInitianData();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
  }

  createAccount() async {
    final userName = _usernameController.text.trim();
    final fullName = _fullNameController.text.trim();
    final userId = supabase.auth.currentUser!.id;
    await supabase.from('profiles').update({
      'username': userName,
      'full_name': fullName,
    }).eq('id', userId);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
  }

  Future<void> _getInitianData() async {
    final userId = supabase.auth.currentUser!.id;
    final data =
        await supabase.from('profiles').select().eq('id', userId).single();
    setState(() {
      _usernameController.text = data['username'];
      print(data['username']);
      _fullNameController.text = data['full_name'];
      _imgUrl = data['avatar_url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Avatar(
              buttonText: 'Upload',
              circular: false,
              onUpload: (imgUrl) async {
                setState(() {
                  _imgUrl = imgUrl;
                });
                final userId = supabase.auth.currentUser!.id;
                await supabase
                    .from('profiles')
                    .update({'avatar_url': imgUrl}).eq('id', userId);
              },
              imgUrl: _imgUrl,
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _accountFormKey,
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: _usernameController,
                      hintText: 'Username',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextfield(
                      controller: _fullNameController,
                      hintText: 'FullName',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      text: 'Save',
                      onTap: () {
                        createAccount();
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
