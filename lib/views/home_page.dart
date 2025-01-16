import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../controllers/activity_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<String> _quoteFuture;
  bool _hasLoadedActivities = false;

  @override
  void initState() {
    super.initState();
    _quoteFuture = fetchQuote(); 
  }

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

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ActivityController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
      ),
      body: Column(
        children: [
          FutureBuilder<String>(
            future: _quoteFuture,
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
          if (!_hasLoadedActivities)
            ElevatedButton(
              onPressed: () async {
                await controller.getActivities();
                setState(() {
                  _hasLoadedActivities = true;
                });
              },
              child: const Text('Get Activities'),
            ),
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
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

