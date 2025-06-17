import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/buttons/bottomButton.dart';
import 'package:note_ily/widgets/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _error = '';
  String _passwordStrength = '';

  bool _isLoading = false;

  void _checkPasswordStrength(String password) {
    setState(() {
      if (password.length < 6) {
        _passwordStrength = 'Low';
      } else if (password.length < 10) {
        _passwordStrength = 'Weak';
      } else {
        _passwordStrength = 'Strong';
      }
    });
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // You can also store name in Firestore or update displayName
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message ?? 'Something went wrong';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.black12,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Begin your notes taking adventure with us!\nSign Up",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                MyTextField(
                  controller: _nameController,
                  label: 'Name',
                  hintText: 'Enter a username',
                  obscureText: false,
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Name required' : null,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'user@gmail.com',
                  obscureText: false,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Email required';
                    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(val)) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                MyTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hintText: 'Enter your Password',
                    obscureText: true,
                  onChanged: _checkPasswordStrength,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Password required';
                    } else if (val.length < 6) {
                      return 'Password must contain min 6 characters';
                    }
                    return null;
                  },),
                const SizedBox(height: 8),
                Text(
                  'Strength: $_passwordStrength',
                  style: TextStyle(
                    color: _passwordStrength == 'Strong'
                        ? Colors.green
                        : _passwordStrength == 'Weak'
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                if (_error.isNotEmpty)
                  Text(
                    _error,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : BottomButton(
                  text: 'Sign Up',
                  onPressed: _signUp,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
