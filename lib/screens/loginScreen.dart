import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/buttons/bottomButton.dart';
import '../widgets/text_field.dart';
import 'package:note_ily/services/google_signIn.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool isLoading = false;

  final _auth = FirebaseAuth.instance;

  void loginUser() async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    String email = emailController.text.trim();
    String password = passwordController.text;

    // Basic validation
    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)) {
      setState(() => emailError = "Invalid email address");
      return;
    }
    if (password.isEmpty) {
      setState(() => passwordError = "Password cannot be empty");
      return;
    }

    try {
      setState(() => isLoading = true);
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Navigate to home screen or next page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found' || e.code == 'invalid-email') {
          emailError = "Invalid email address";
        } else if (e.code == 'wrong-password') {
          passwordError = "Invalid password. Please try again";
        } else {
          emailError = e.message;
        }
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final errorBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(8),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 100),
              const Text(
                "Ready to get productive? Login",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 40),

              // Email Field
              // Email Field
              MyTextField(
                controller: emailController,
                label: 'Email',
                hintText: 'user@email.com',
                errorText: emailError,
                obscureText: false,
                onChanged: (val) {
                  // optionally reset error when typing
                },
              ),

              const SizedBox(height: 20),

// Password Field
              MyTextField(
                controller: passwordController,
                label: 'Password',
                hintText: '••••••••',
                errorText: passwordError,
                obscureText: true,
                onChanged: (val) {
                  // optionally reset error when typing
                },
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/forget_pswd'),
                  child: const Text("Forgot Password?", style: TextStyle(color: Colors.white70)),
                ),
              ),
              const SizedBox(height: 10),

              // Login Button
              Stack(
                alignment: Alignment.center,
                children: [
                  BottomButton(
                    text: "Login",
                    onPressed: isLoading ? () {} : loginUser,
                  ),
                  if (isLoading)
                    const Positioned(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),

            const SizedBox(height: 20,),
            // or continue with -- using divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                        thickness: 0.8,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('or Continue with'),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.8,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              // const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    GestureDetector(
                      onTap: ()async{
                        try{
                    final userCredential= await signInWithGoogle();
                    if (userCredential.user != null) {
                      // Navigate to home after successful login
                       Navigator.pushReplacementNamed(context, '/home');
                    }}
                    catch (e) {
                     ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text("Google sign-in failed: $e")),
                        );
                    }
                    },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.black12
                        ),
                        child: Image.asset('assets/google.png',
                          height: 40,

                        ),
                      ),
                    )
                ],
              ),

              const SizedBox(height: 50,),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text("Don’t have an account? Sign Up", style: TextStyle(color: Colors.blue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
