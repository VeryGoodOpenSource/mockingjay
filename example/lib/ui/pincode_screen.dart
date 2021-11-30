import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';

class PincodeScreen extends StatefulWidget {
  const PincodeScreen({Key? key}) : super(key: key);

  static Route<String?> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/pincode_screen'),
      fullscreenDialog: true,
      builder: (context) {
        return const PincodeScreen();
      },
    );
  }

  @override
  State<PincodeScreen> createState() => _PincodeScreenState();
}

class _PincodeScreenState extends State<PincodeScreen> {
  var _pincode = '';
  String? _errorText;

  void _onPincodeChanged(BuildContext context, String pincode) {
    if (!mounted) {
      return;
    }

    setState(() {
      _pincode = pincode;
      _errorText = null;
    });

    if (_pincode.length >= 6) {
      Navigator.of(context).pop(_pincode);
    }
  }

  void _onSubmitted() {
    if (_pincode.length == 6) {
      Navigator.of(context).pop(_pincode);
    } else {
      setState(() {
        _errorText = 'Pincode must be 6 digits long';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final monospaceFontFamily = Platform.isIOS ? 'Courier' : 'monospace';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pincode Screen'),
      ),
      body: Center(
        child: DefaultTextStyle.merge(
          textAlign: TextAlign.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Enter a pincode to continue.'),
                  const SizedBox(height: 32),
                  TextField(
                    autofocus: true,
                    minLines: 1,
                    maxLength: 6,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    obscureText: true,
                    style: TextStyle(
                      fontFamily: monospaceFontFamily,
                      fontSize: 48,
                    ),
                    decoration: InputDecoration(
                      errorText: _errorText,
                      hintText: '200798',
                      hintStyle: TextStyle(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    onChanged: (value) => _onPincodeChanged(context, value),
                    onSubmitted: (value) => _onSubmitted(),
                    onEditingComplete: _onSubmitted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
