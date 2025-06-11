import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gopeduli/screens/user_authentication/login_screen.dart';
import 'package:gopeduli/screens/user_authentication/verify_email_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: SignUpScreen()));
}

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController(); 
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? _selectedGender; 
  final List<String> _genders = ['Male', 'Female']; 

  bool isPasswordVisible = false;
  bool agreeToTerms = false;
  bool isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate() || !agreeToTerms) return;
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select your gender')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Register user with email + password
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user!;

      // Send email verification
      await user.sendEmailVerification();

      // Save additional info to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'Email': emailController.text.trim(),
        'Name': nameController.text.trim(),
        'Gender': _selectedGender, // Save gender
        'Phone': phoneController.text.trim(),
        'Address': addressController.text.trim(), // Save address
        'CreatedAt': FieldValue.serverTimestamp(),
        'UpdatedAt': null,
        'ProfilePicture': '',
        'Role': 'member',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email sent. Please check your inbox.')),
      );

      // Redirect to email verification screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VerifyEmailScreen()),
      );

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    bool isObscured = false,
    void Function()? toggleVisibility,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
                onPressed: toggleVisibility,
              )
            : null,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text("Sign Up", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 60),
                  _buildTextField(
                    hint: 'Enter your email',
                    controller: emailController,
                    icon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email is required';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 24),
                  _buildTextField(
                    hint: 'Enter your name',
                    controller: nameController,
                    icon: Icons.person,
                    validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
                  ),
                  SizedBox(height: 24),
                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.wc),
                      hintText: 'Select your gender',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    value: _selectedGender,
                    items: _genders.map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'Gender is required' : null,
                  ),
                  SizedBox(height: 24),
                  _buildTextField(
                    hint: 'Enter your phone number',
                    controller: phoneController,
                    icon: Icons.phone,
                    validator: (value) => value == null || value.isEmpty ? 'Phone number is required' : null,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 24),
                  // Address Text Field
                  _buildTextField(
                    hint: 'Enter your address (Optional)',
                    controller: addressController,
                    icon: Icons.home,
                    validator: (value) => null,
                  ),
                  SizedBox(height: 24),
                  _buildTextField(
                    hint: 'Enter your password',
                    controller: passwordController,
                    icon: Icons.lock,
                    isPassword: true,
                    isObscured: !isPasswordVisible,
                    toggleVisibility: () => setState(() => isPasswordVisible = !isPasswordVisible),
                    validator: (value) {
                      if (value == null || value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  _buildTextField(
                    hint: 'Confirm your password',
                    controller: confirmPasswordController,
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isObscured: !isPasswordVisible,
                    toggleVisibility: () => setState(() => isPasswordVisible = !isPasswordVisible),
                    validator: (value) {
                      if (value != passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: agreeToTerms,
                        onChanged: (value) => setState(() => agreeToTerms = value ?? false),
                      ),
                      Expanded(
                        child: Wrap(
                          children: [
                            Text("I agree to GoPeduli "),
                            GestureDetector(
                              onTap: () {},
                              child: Text("Terms of Service", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),),
                            ),
                            Text(" and "),
                            GestureDetector(
                              onTap: () {},
                              child: Text("Privacy Policy", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _register,
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Sign Up", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.teal,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ", style: TextStyle(color: Colors.black)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text("Login", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),),
                      ),
                    ],
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