// ignore_for_file: avoid_print

import 'package:fingerprint_auth/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth_device_credentials/local_auth.dart';

class AuthPath extends StatefulWidget {
  const AuthPath({super.key});

  @override
  State<AuthPath> createState() => _AuthPathState();
}

class _AuthPathState extends State<AuthPath> {
  bool? _hasBioSensor;

  LocalAuthentication authentication = LocalAuthentication();

  Future<void> _checkBio() async {
    try {
      _hasBioSensor = await authentication.canCheckBiometrics;
      print(_hasBioSensor);
      if (_hasBioSensor!) {
        _getAuth();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAuth() async {
    bool isAuth = false;

    try {
      isAuth = await authentication.authenticateWithBiometrics(
          localizedReason: 'Scan your finger print to access the app',
          useErrorDialogs: true,
          stickyAuth: true);
      print(isAuth);

      if (isAuth) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => const Home()));
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkBio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Flutter local fingerprint auth',
            style: TextStyle(fontSize: 28),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: 70,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                _checkBio();
              },
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(), backgroundColor: Colors.green),
              child: const Text('Check Auth'),
            ),
          )
        ],
      ),
    );
  }
}
