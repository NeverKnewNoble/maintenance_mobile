// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:ex_maintenance/components/app_colors.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   LoginPageState createState() => LoginPageState();
// }

// class LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   static const _emailRegExp = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _onLogin() {
//     if (_formKey.currentState!.validate()) {
//       if (kDebugMode) {
//         print('Login with: ${_emailController.text}');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             if (constraints.maxWidth > 600) {
//               return _buildWideLayout(context);
//             } else {
//               return _buildNarrowLayout(context);
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildWideLayout(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           flex: 1,
//           child: Container(
//             color: AppColors.coolGreen,
//             child: Center(
//               child: Text(
//                 'Ex Maintenance',
//                 style: Theme.of(context).textTheme.displaySmall?.copyWith(
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           flex: 1,
//           child: Center(
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 400),
//               child: _buildLoginForm(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildNarrowLayout(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const SizedBox(height: 48),
//             Text(
//               'Login',
//               style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                 color: AppColors.coolGreen,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.left,
//             ),
//             const SizedBox(height: 5),
//             const Image(
//               image: AssetImage('images/Maintenance.gif'),
//               width: 200, // adjust as needed
//               height: 400, // adjust as needed
//             ),
//             const SizedBox(height: 10),
//             _buildLoginForm(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoginForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           _buildTextField(
//             controller: _emailController,
//             label: 'Email',
//             validator: _validateEmail,
//             keyboardType: TextInputType.emailAddress,
//           ),
//           const SizedBox(height: 16),
//           _buildTextField(
//             controller: _passwordController,
//             label: 'Password',
//             validator: _validatePassword,
//             obscureText: _obscurePassword,
//             suffixIcon: IconButton(
//               icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
//               onPressed: () {
//                 setState(() {
//                   _obscurePassword = !_obscurePassword;
//                 });
//               },
//             ),
//           ),
//           const SizedBox(height: 8),
//           Align(
//             alignment: Alignment.centerRight,
//             child: TextButton(
//               onPressed: () {
                
//               },
//               child: const Text(
//                 'Forgot Password?',
//                 style: TextStyle(color: AppColors.lightGreen),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _onLogin,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.coolGreen,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: const Text('Login',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),),
//           ),
 
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String? Function(String?) validator,
//     bool obscureText = false,
//     TextInputType? keyboardType,
//     Widget? suffixIcon,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: AppColors.grey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: AppColors.grey, width: 2),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         suffixIcon: suffixIcon,
//       ),
//       validator: validator,
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//     );
//   }

//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Email is required';
//     }
//     final emailRegExp = RegExp(_emailRegExp);
//     if (!emailRegExp.hasMatch(value)) {
//       return 'Enter a valid email address';
//     }
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Password is required';
//     }
//     if (value.length < 8) {
//       return 'Password must be at least 8 characters long';
//     }
//     return null;
//   }
// }







import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ex_maintenance/components/app_colors.dart';
import 'package:ex_maintenance/frappe_call/login_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  static const _emailRegExp = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Call the verifyLogin function from login_api.dart
        final response = await verifyLogin(_emailController.text, _passwordController.text);

        if (mounted) {  // Check if the widget is still mounted
          if (response['status'] == 'success') {
            // Login successful, navigate to the HomePage
            if (kDebugMode) {
              print(response['message']);
            }
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            // Show error message from the API response
            _showErrorMessage(response['message']);
          }
        }
      } catch (e) {
        // Handle any exceptions or errors during the API call
        if (mounted) {
          _showErrorMessage('Failed to log in. Please try again.');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildWideLayout(context);
            } else {
              return _buildNarrowLayout(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: AppColors.coolGreen,
            child: Center(
              child: Text(
                'Ex Maintenance',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _buildLoginForm(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 48),
            Text(
              'Login',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.coolGreen,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 5),
            const Image(
              image: AssetImage('images/Maintenance.gif'),
              width: 200,
              height: 400,
            ),
            const SizedBox(height: 10),
            _buildLoginForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            validator: _validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            validator: _validatePassword,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          const SizedBox(height: 30),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coolGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grey, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(_emailRegExp);
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }
}
