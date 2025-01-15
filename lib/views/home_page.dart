import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/activity_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ActivityController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                FutureBuilder<String>(
                    future: fetchQuote(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Error: ${snapshot.error}"),
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
                    }),
                ElevatedButton(
                  onPressed: controller.getActivities,
                  child: const Text('Get Activities'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.activities.length,
                    itemBuilder: (context, index) {
                      final activity = controller.activities[index];
                      return ListTile(
                        title: Text(activity.title),
                        subtitle: Text(activity.description),
                        trailing: Text(activity.category),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

Future<String> fetchQuote() async {
  try {
    final response =
        await http.get(Uri.parse('https://zenquotes.io/api/random'));
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
