import 'package:emergency/models/post_model.dart';
import 'package:emergency/pages/component/drawer_content.dart';
import 'package:emergency/services/post_services.dart';
import 'package:flutter/material.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => PostsState();
}

class PostsState extends State<Posts> {
  final PostServices postServices = PostServices();
  List<Post> posts = [];
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    postServices.getPosts().then((value) {
      setState(() {
        posts = value;
        loading = false;
      });
    });
  }

  Future refresh() async {
    setState(() {
      loading = true;
    });
    posts = await postServices.getPosts();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 67, 127),
        centerTitle: true,
        title: const Text(
          'بڵاوکراوەکان',
          style: TextStyle(
            fontFamily: "rabar",
            fontSize: 22.0,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      endDrawer: const DrawerContent(),
      body: loading
          ? const Center(
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await refresh();
              },
              child: posts.isNotEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        late String title;
                        late IconData icon;
                        late Color color;
                        switch (posts[index].department) {
                          case 0:
                            title = "ئەمبوڵانس";
                            icon = Icons.local_hospital;
                            color = Colors.blue;
                            break;
                          case 1:
                            title = "ئاگر کوژێنەوە";
                            icon = Icons.local_fire_department;
                            color = Colors.red;
                            break;
                          case 2:
                            title = "هاتوچۆ";
                            icon = Icons.local_police;
                            color = Colors.green;
                            break;
                        }

                        return _buildCategoryCard(
                            title, icon, color, posts[index].content);
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10.0),
                      itemCount: posts.length,
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) => ListView(
                        children: [
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Center(
                                child: Text(
                                  "هیچ پۆستێک نییە",
                                  style: TextStyle(
                                    fontFamily: 'rabar',
                                    fontSize: 24.0,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
    );
  }

  Widget _buildCategoryCard(
      String title, IconData icon, Color color, String subtitle) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'rabar',
                  color: Color.fromARGB(255, 33, 67, 127)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30.0),
            Text(
              subtitle,
              style: const TextStyle(
                  fontSize: 19.0, color: Color.fromARGB(255, 62, 62, 62)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30.0),
            Icon(
              icon,
              color: color,
              size: 35.0,
            ),
          ],
        ),
      ),
    );
  }
}
