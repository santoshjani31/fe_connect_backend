import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import 'package:fe_connect_backend/views/activity_details.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  Future<List<Activity>> getActivities() async {
    final repository = ActivityRepository();
    return await repository.fetchActivities("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Explore")),
      body: FutureBuilder<List<Activity>>(
        future: getActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No activities found.'),
            );
          }
          final activities = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ActivityDetailPage(activity: activity),
                    ),
                  );
                },
                child: Card(
                  color: Color.fromARGB(255, 229, 229, 255),
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: activity.imageURL != null
                            ? Image.network(activity.imageURL!,
                                fit: BoxFit.cover, height: 135)
                            : Image.network(
                                'https://via.placeholder.com/400x200?text=No+Image+Available',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 110,
                              ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(2),
                          child: Text(
                            activity.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
