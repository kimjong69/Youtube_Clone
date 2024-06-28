import 'package:flutter/material.dart';
import 'package:youtube_clone/common/widgets/avatar.dart';
import 'package:youtube_clone/common/widgets/custom_button.dart';
import 'package:youtube_clone/common/widgets/custom_textfield.dart';
import 'package:youtube_clone/main.dart';
import 'package:youtube_clone/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool editUsername = false;
  bool editFullname = false;
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

  // Future<void> _editField(String field) async {
  //   String newValue = "";
  //   await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text(
  //         'Edit $field',
  //         style: const TextStyle(color: Colors.white),
  //       ),
  //       content: TextField(
  //         autofocus: true,
  //         style: const TextStyle(color: Colors.white),
  //         decoration: InputDecoration(
  //           hintText: 'Enter new $field',
  //           hintStyle: const TextStyle(color: Colors.grey),
  //         ),
  //         onChanged: (value) {
  //           newValue = value;
  //         },
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text(
  //             'Cancel',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(newValue),
  //           child: const Text(
  //             'Save',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  //   if (newValue.trim().isNotEmpty) {
  //     final userId = supabase.auth.currentUser!.id;
  //     await supabase.from('profiles').update({
  //       field: newValue,
  //     }).eq('id', userId);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 120,
                child: Image.asset(
                  'assets/images/mainLogo.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.cast,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Avatar(
                buttonText: 'Update',
                circular: true,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      editUsername
                          ? Card(
                              child: Column(
                                children: [
                                  CustomTextfield(
                                    controller: _usernameController,
                                    hintText: 'Username',
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            final userName =
                                                _usernameController.text.trim();
                                            final userId =
                                                supabase.auth.currentUser!.id;
                                            await supabase
                                                .from('profiles')
                                                .update({
                                              'username': userName,
                                            }).eq('id', userId);
                                            setState(() {
                                              editUsername = false;
                                            });
                                          },
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Card(
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(_usernameController.text),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          editUsername = !editUsername;
                                        });
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Full Name',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      editFullname
                          ? Card(
                              child: Column(
                                children: [
                                  CustomTextfield(
                                    controller: _fullNameController,
                                    hintText: 'Full Name',
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            final fullName =
                                                _fullNameController.text.trim();

                                            final userId =
                                                supabase.auth.currentUser!.id;
                                            await supabase
                                                .from('profiles')
                                                .update({
                                              'full_name': fullName,
                                            }).eq('id', userId);
                                            setState(() {
                                              editFullname = false;
                                            });
                                          },
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Card(
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(_fullNameController.text),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          editFullname = !editFullname;
                                        });
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: CustomButton(
                          width: 100,
                          text: 'Logout',
                          onTap: () async {
                            await supabase.auth.signOut();
                            setState(() {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  LoginPage.routeName,
                                  (Route<dynamic> route) => false);
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
