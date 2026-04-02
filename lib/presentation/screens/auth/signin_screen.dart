import 'package:flutter/material.dart';
import '../../widgets/header.dart';
import '../../../routes/app_routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(
              title: 'Grampanchayat Portal',
              subtitle: 'Official Governance Gateway',
              icon: Icons.how_to_reg,
            ),
            _buildSignInCard(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInCard() {
    return Container(
      transform: Matrix4.translationValues(0, -40, 0),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF410008).withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          )
        ],
      ),
      child: Column(
        children: [
          _buildTitle('Sign In'),
          _buildLabel('EMAIL ADDRESS'),
          _buildTextField('Enter your email', Icons.alternate_email_outlined),
          const SizedBox(height: 20),
          _buildLabel('PASSWORD'),
          _buildPasswordField('Enter your password'),
          const SizedBox(height: 32),
          _buildSignInButton(),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Color(0xFF775A19),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account?",
                style: TextStyle(color: Color(0xFF564241), fontSize: 14),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signup);
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color(0xFF49000A),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF49000A),
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFF775A19),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Color(0xFF564241),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5EDDE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF8A7171), size: 20),
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF8A7171), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hint) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5EDDE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF8A7171), size: 20),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: const Color(0xFF8A7171),
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF8A7171), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, AppRoutes.news);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF775A19),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign In',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          const Text(
            'SECURE ACCESS FOR CITIZENS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Color(0xFF49000A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '© 2024 Digital Custodian Governance.\nOfficial Restricted Access.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: const Color(0xFF564241).withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterLink('Privacy Policy'),
              const SizedBox(width: 20),
              _buildFooterLink('Terms of Service'),
              const SizedBox(width: 20),
              _buildFooterLink('Accessibility'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        letterSpacing: 0.5,
      ),
    );
  }
}
