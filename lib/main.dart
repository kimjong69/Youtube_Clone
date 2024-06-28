import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_clone/pages/splash_page.dart';
import 'package:youtube_clone/router.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://pqtdftsieqcndhjilbed.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBxdGRmdHNpZXFjbmRoamlsYmVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkyMjQ0MzAsImV4cCI6MjAzNDgwMDQzMH0.sNtsEyBp1BtqhOJUSZ2sHCPEEqgANyuKB0kZE3w7a_Q',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      onGenerateRoute: (settings) => generateRoute(settings),
      initialRoute: SplashPage.routeName,
    );
  }
}
