import 'package:flutter/material.dart';
import 'package:lifexlane/landing.dart';
import 'dart:math' as math;
import 'SuccessAnimation.dart';
import 'bluetooth_connection.dart';

class FormSubmissionPage extends StatefulWidget {
  const FormSubmissionPage({Key? key}) : super(key: key);

  @override
  _FormSubmissionPageState createState() => _FormSubmissionPageState();
}

class _FormSubmissionPageState extends State<FormSubmissionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<bool>(
          // Simulate form submission by delaying for 2 seconds
          future: Future.delayed(const Duration(seconds: 2), () => true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  margin: EdgeInsets.symmetric(vertical: 24.0),
                  child: SuccessAnimation());
            } else if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 64.0),
                      child: SuccessAnimation()),
                  const SizedBox(height: 20),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
                    child: const Text(
                      'Please Check Your Entered Email Id for Login Details',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // const SizedBox(height: 24),
                  Container(
                    margin: EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BluetoothPage(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 230, 81, 0))),
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              );
            } else {
              return const Text('Error occurred while submitting the form.');
            }
          },
        ),
      ),
    );
  }
}
