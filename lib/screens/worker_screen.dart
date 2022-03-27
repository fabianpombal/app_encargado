import 'package:flutter/material.dart';

class WorkerScreen extends StatelessWidget {
  const WorkerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Page'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Container(height: 150, width: double.infinity, color: Colors.green),
            const SizedBox(
              height: 20,
              width: double.infinity,
            ),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
