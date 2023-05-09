import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _smsCodeController = TextEditingController();
  bool _isVerifying = false;
  String _errorMessage = '';

  Future<void> _verifyCode() async {
    setState(() {
      _isVerifying = true;
      _errorMessage = '';
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _smsCodeController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isVerifying = false;
        _errorMessage = e.message ?? 'Something went wrong';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Code'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Please enter the code sent to your phone number',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: _smsCodeController,
              decoration: const InputDecoration(
                labelText: 'OTP',
                hintText: 'Enter the 6-digit code',
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the OTP';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _errorMessage,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isVerifying ? null : _verifyCode,
                child: _isVerifying
                    ? const CircularProgressIndicator()
                    : const Text('Verify'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _smsCodeController.dispose();
    super.dispose();
  }
}
