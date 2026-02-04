import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_printer_app/services/password_service.dart';
import 'package:my_printer_app/screens/statistics_screen.dart';
import 'package:my_printer_app/screens/home_screen.dart';

class PasswordScreen extends StatefulWidget {
  final bool isForReset;

  const PasswordScreen({super.key, this.isForReset = false});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _passwordController = TextEditingController();
  final _masterPasswordController = TextEditingController();
  final _passwordService = PasswordService.instance;
  bool _isLoading = false;
  final bool _isChangingPassword = false;
  String? _errorMessage;
  bool _showDefaultPasswordHint = true;

  @override
  void initState() {
    super.initState();
    _passwordService.initialize();
  }

  Future<void> _verifyPassword() async {
    if (_passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter a password');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final isValid = await _passwordService.verifyPassword(
        _passwordController.text,
      );
      if (isValid) {
        if (_isChangingPassword) {
          Get.back(); // Return to statistics screen
        } else if (widget.isForReset) {
          Get.back(result: true); // Return true for reset verification
        } else {
          Get.off(() => StatisticsScreen());
        }
      } else {
        setState(() => _errorMessage = 'Incorrect password');
      }
    } catch (e) {
      setState(() => _errorMessage = 'An error occurred');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showMasterPasswordDialog() async {
    _masterPasswordController.clear();
    String? errorMessage;

    await Get.dialog(
      AlertDialog(
        title: Text('Enter Master Password'),
        content: StatefulBuilder(
          builder:
              (context, setState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _masterPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Master Password',
                      border: OutlineInputBorder(),
                      errorText: errorMessage,
                    ),
                  ),
                ],
              ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (_masterPasswordController.text.isEmpty) {
                setState(() => errorMessage = 'Please enter master password');
                return;
              }
              if (_masterPasswordController.text == 'Password.printoo.2006') {
                Get.back();
                Get.off(() => StatisticsScreen());
              } else {
                setState(() => errorMessage = 'Incorrect master password');
              }
            },
            child: Text('Verify'),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyDefaultPassword() async {
    final defaultPasswordController = TextEditingController();
    String? errorMessage;

    await Get.dialog(
      AlertDialog(
        title: Text('Verify Default Password'),
        content: StatefulBuilder(
          builder:
              (context, setState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: defaultPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Enter Default Password',
                      border: OutlineInputBorder(),
                      errorText: errorMessage,
                    ),
                  ),
                ],
              ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (defaultPasswordController.text.isEmpty) {
                setState(() => errorMessage = 'Please enter default password');
                return;
              }
              if (defaultPasswordController.text == '123') {
                Get.back();
                _showChangePasswordDialog();
              } else {
                setState(() => errorMessage = 'Incorrect default password');
              }
            },
            child: Text('Verify'),
          ),
        ],
      ),
    );
  }

  Future<void> _showChangePasswordDialog() async {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    String? errorMessage;

    await Get.dialog(
      AlertDialog(
        title: Text('Change Password'),
        content: StatefulBuilder(
          builder:
              (context, setState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                      errorText: errorMessage,
                    ),
                  ),
                ],
              ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (newPasswordController.text.isEmpty) {
                setState(() => errorMessage = 'Please enter a new password');
                return;
              }
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                setState(() => errorMessage = 'Passwords do not match');
                return;
              }
              await _passwordService.changePassword(newPasswordController.text);
              setState(() => _showDefaultPasswordHint = false);
              Get.back();
              Get.snackbar(
                'Success',
                'Password changed successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Change'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isForReset
              ? 'Verify Password for Reset'
              : _isChangingPassword
              ? 'Change Password'
              : 'Enter Password',
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.off(() => HomeScreen()),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_showDefaultPasswordHint)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Default password is: 123',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                errorText: _errorMessage,
              ),
              onSubmitted: (_) => _verifyPassword(),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyPassword,
                  child:
                      _isLoading ? CircularProgressIndicator() : Text('Enter'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _showMasterPasswordDialog,
                  child: Text('Master Password'),
                ),
                TextButton(
                  onPressed: _isLoading ? null : _verifyDefaultPassword,
                  child: Text('Forgot Password?'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _masterPasswordController.dispose();
    super.dispose();
  }
}
