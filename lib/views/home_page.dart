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

  Future<Map<String, dynamic>?> fetchRelatedArticle(String mood) async {
    try {
      final response = await http.get(
        Uri.parse('https://api-rarz3eo25q-uc.a.run.app/articles?mood=$mood'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('articles') && data['articles'].isNotEmpty) {
          return data['articles'][0];
        }
      }
    } catch (error) {
      debugPrint('Error fetching article: $error');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final selectedMood = Provider.of<MoodProvider>(context).selectedMood;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quote of the Day",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<String>(
              future: fetchQuote(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
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
            Text(
              "Here are some activities that can help with feeling $selectedMood:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<List<Activity>>(
              future: getActivities(selectedMood),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'No activities available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                } else {
                  final activities = snapshot.data!;
                  return Column(
                    children: activities
                        .map(
                          (activity) => ListTile(
                            title: Text(activity.title),
                            subtitle: Text(activity.description),
                            trailing: Text(activity.category),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ActivityDetailPage(activity: activity),
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              "Here is an article that can help with feeling $selectedMood:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<Map<String, dynamic>?>(
              future: fetchRelatedArticle(selectedMood),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "No related articles available.",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                } else {
                  final article = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['title'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article['body'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Author: ${article['author']}",
                        style: const TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
