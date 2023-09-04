import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.orange[900],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _vehicleRegistrationController =
      TextEditingController();
  String _selectedIdType = 'idtype1';
  DateTime? _selectedDateOfBirth;

  // Function to show the date picker
  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _idNumberController.dispose();
    _contactNumberController.dispose();
    _vehicleRegistrationController.dispose();
    super.dispose();
  }

  String generateRandomPassword(String firstName, String email) {
    final String firstNameDigits =
        firstName.substring(0, min(3, firstName.length));
    final String emailDigits = email.substring(0, min(3, email.length));
    final String randomNumber = (Random().nextInt(900) + 100).toString();

    return '$firstNameDigits$emailDigits@$randomNumber';
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Navigator.pushNamed(context, '/form_submission',
      //     arguments: {'email': _emailController.text});

      final String email = _emailController.text;
      final String password =
          generateRandomPassword(_firstNameController.text, _emailController.text); // Replace with your own logic to generate a random password

      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = userCredential.user;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'email': email,
            'dateOfBirth': _selectedDateOfBirth,
            'address': _addressController.text,
            'pincode': _pincodeController.text,
            'idType': _selectedIdType,
            'idNumber': _idNumberController.text,
            'contactNumber': _contactNumberController.text,
            'vehicleRegistration': _vehicleRegistrationController.text,
          });

          await user.sendEmailVerification();

          // Show success message or navigate to the next screen
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(
            context,
            '/form_submission'
          );
        }
      } catch (e) {
        // Handle sign-up errors
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sign Up Error'),
              content: Text('An error occurred: $e'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(4.0),
            child: TextFormField(
              controller: _firstNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First Name',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: EdgeInsets.all(2.0),
            child: TextFormField(
              controller: _lastNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Last Name',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: EdgeInsets.all(2.0),
            child: TextFormField(
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return 'Please enter a valid email';
                }

                return null;
              },
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: EdgeInsets.all(2.0),
            child: TextFormField(
              readOnly: true,
              onTap: () {
                _selectDateOfBirth(context);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Date of Birth',
              ),
              controller: TextEditingController(
                text: _selectedDateOfBirth != null
                    ? DateFormat('yyyy-MM-dd').format(_selectedDateOfBirth!)
                    : '',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: EdgeInsets.all(2.0),
            child: TextFormField(
              controller: _addressController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your street address';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Street Address',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: EdgeInsets.all(2.0),
            child: TextFormField(
              controller: _pincodeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your pincode';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Pincode',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: EdgeInsets.all(2.0),
            child: DropdownButtonFormField<String>(
              value: _selectedIdType,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an ID type';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _selectedIdType = value!;
                });
              },
              items: const [
                DropdownMenuItem<String>(
                  value: 'idtype1',
                  child: Text('Aadhar Card'),
                ),
                DropdownMenuItem<String>(
                  value: 'idtype2',
                  child: Text('Drivers License'),
                ),
                DropdownMenuItem<String>(
                  value: 'idtype3',
                  child: Text('Passport'),
                ),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ID Type',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: EdgeInsets.all(2.0),
            child: TextFormField(
              controller: _idNumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your ID number';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ID Number',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: EdgeInsets.all(2.0),
            child: TextFormField(
              controller: _contactNumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your contact number';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contact Number',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: EdgeInsets.all(2.0),
            child: TextFormField(
              controller: _vehicleRegistrationController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your vehicle registration number';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Vehicle Registration Number',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: EdgeInsets.all(2.0),
            child: ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 230, 81, 0))),
            ),
          ),
        ],
      ),
    );
  }
}
