import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String title;
  final String description;
  final String category;

  Activity({
    required this.title,
    required this.description,
    required this.category,
  });

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Activity(
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      category: data['category'] ?? 'No Category',
    );
  }
}

class ActivityRepository {
  final CollectionReference activitiesCollection =
      FirebaseFirestore.instance.collection('Activities');

  Future<List<Activity>> fetchActivities() async {
    QuerySnapshot snapshot = await activitiesCollection.get();
    return snapshot.docs.map((doc) => Activity.fromFirestore(doc)).toList();
  }
}
