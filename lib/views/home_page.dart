import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/activity_controller.dart';

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
