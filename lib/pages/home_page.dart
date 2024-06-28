import 'package:flutter/material.dart';
import 'package:youtube_clone/common/widgets/posts.dart';
import 'package:youtube_clone/main.dart';
import 'package:youtube_clone/pages/video_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future getData() async {
    // final userId = supabase.auth.currentUser!.id;
    final data = await supabase.from('profiles').select();
    print(data[0]['id']);
    return data.toString();
  }

  final _dataStream = supabase.from('videos').stream(primaryKey: ['id']);

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
      body: StreamBuilder(
          stream: _dataStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = snapshot.data!;
            print(items);
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pushNamed(context, VideoPage.routeName,
                            arguments: items[index]['video_url']);
                      });
                    },
                    child: Posts(
                        thumnailUrl: items[index]['thumbnail_url'],
                        title: items[index]['title']),
                  );
                });
          }),
    );
  }
}
