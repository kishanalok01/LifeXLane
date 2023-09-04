import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.orange[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 60.0),
              child: Text(
                'Please Choose Mode of Operation',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 0.6 * screenWidth,
              height: 0.12 * screenHeight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/transmitter_page');
                },
                child: const Text(
                  'Transmitter',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 0.6 * screenWidth,
              height: 0.12 * screenHeight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/receiver_page');
                },
                child: const Text(
                  'Receiver',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
