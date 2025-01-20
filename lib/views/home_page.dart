import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/activity_model.dart';
import 'package:fe_connect_backend/views/moods_page.dart';
import 'package:provider/provider.dart';
import 'package:fe_connect_backend/views/activity_details.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Future<String> fetchQuote() async {
    try {
      final response =
          await http.get(Uri.parse('https://zenquotes.io/api/today'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data[0]['q'];
      } else {
        return "Error: Unable to fetch quote. (${response.statusCode})";
      }
    } catch (error) {
      return "An error occurred: $error";
    }
  }

  Future<List<Activity>> getActivities(String selectedMood) async {
    final repository = ActivityRepository();
    return await repository.fetchActivities(selectedMood);
  }

  @override
  Widget build(BuildContext context) {
    final selectedMood = Provider.of<MoodProvider>(context).selectedMood;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
      ),
      body: Column(
        children: [
          FutureBuilder<String>(
            future: fetchQuote(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    snapshot.data ?? "No quote available",
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            },
          ),
          Expanded(
            child: FutureBuilder<List<Activity>>(
              future: getActivities(selectedMood),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No activities available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                } else {
                  final activities = snapshot.data!;
                  return ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return ListTile(
                        title: Text(activity.title),
                        subtitle: Text(activity.description),
                        trailing: Text(activity.category),
                        onTap: () {
                          Navigator.push(
                            context,
                          MaterialPageRoute(
                          builder: (context) => ActivityDetailPage(activity: activity),
                            ),
                          );
                          },
                        );

                      
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
