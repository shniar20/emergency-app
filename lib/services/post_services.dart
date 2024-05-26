import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/models/post_model.dart';

class PostServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Post>> getPosts() async {
    List<Post> posts = [];
    QuerySnapshot documents = await _firebaseFirestore
        .collection("posts")
        .orderBy("postedAt", descending: true)
        .get();

    for (var document in documents.docs) {
      Post post = Post.fromMap(document.data() as Map<String, dynamic>);
      post.id = document.id;
      posts.add(post);
    }

    return posts;
  }
}
