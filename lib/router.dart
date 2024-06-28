import 'package:flutter/material.dart';
import 'package:youtube_clone/common/widgets/bottom_bar.dart';
import 'package:youtube_clone/pages/account_page.dart';
import 'package:youtube_clone/pages/home_page.dart';
import 'package:youtube_clone/pages/login_page.dart';
import 'package:youtube_clone/pages/splash_page.dart';
import 'package:youtube_clone/pages/video_page.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SplashPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SplashPage(),
      );
    case LoginPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginPage(),
      );
    case AccountPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AccountPage(),
      );
    case HomePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomePage(),
      );
    case VideoPage.routeName:
    var videoUrl= routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  VideoPage(
          videoUrl: videoUrl,
        ),
      );
      case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Page does not exist'),
          ),
        ),
      );
  }
}
