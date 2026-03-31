import 'package:flutter/material.dart';
import '../../widgets/header.dart';
import '../news/news_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 1;
  final SignupData _data = SignupData();

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NewsScreen()),
      );
    }
  }

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

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
            _buildStepContent(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
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
          if (_currentStep == 1) _buildStep1(),
          if (_currentStep == 2) _buildStep2(),
          if (_currentStep == 3) _buildStep3(),
          if (_currentStep == 4) _buildStep4(),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        _buildStepTitle('Citizen Login'),
        _buildLabel('FULL NAME'),
        _buildTextField('Enter your full name', Icons.person, (val) => _data.name = val),
        const SizedBox(height: 20),
        _buildLabel('EMAIL ADDRESS'),
        _buildTextField('Enter your email', Icons.alternate_email, (val) => _data.email = val),
        const SizedBox(height: 24),
        _buildPrimaryButton('Send OTP', Icons.forward_to_inbox, () {}),
        const SizedBox(height: 40),
        const Divider(color: Color(0xFFDDC0BF), thickness: 0.5),
        const SizedBox(height: 32),
        _buildLabel('ENTER OTP'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) => _buildOtpBox()),
        ),
        const SizedBox(height: 24),
        _buildSecondaryButton('Verify OTP', Icons.verified, () {}),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {},
          child: const Text('Resend OTP', style: TextStyle(color: Color(0xFF775A19), fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 24),
        _buildNextStepButton(_nextStep),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        _buildStepTitle('Set Your Password'),
        _buildLabel('CREATE PASSWORD'),
        _buildTextField('Enter new password', Icons.lock, (val) => _data.password = val, obscure: true),
        const SizedBox(height: 20),
        _buildLabel('CONFIRM PASSWORD'),
        _buildTextField('Confirm your password', Icons.lock, (val) {}, obscure: true),
        const SizedBox(height: 8),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Password must be at least 8 characters',
            style: TextStyle(color: Color(0xFF775A19), fontSize: 12),
          ),
        ),
        const SizedBox(height: 40),
        _buildNextStepButton(_nextStep, label: 'Save Password'),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => _goToStep(1),
          child: const Text('Back to Login', style: TextStyle(color: Color(0xFF775A19))),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        _buildStepTitle('Select Location'),
        _buildLabel('DISTRICT'),
        _buildDropdown('Select District', Icons.location_on, (val) => _data.district = val ?? ''),
        const SizedBox(height: 20),
        _buildLabel('TALUKA'),
        _buildDropdown('Select Taluka', Icons.explore, (val) => _data.taluka = val ?? ''),
        const SizedBox(height: 20),
        _buildLabel('GRAM PANCHAYAT'),
        _buildDropdown('Select Grampanchayat', Icons.holiday_village, (val) => _data.gramPanchayat = val ?? ''),
        const SizedBox(height: 40),
        _buildNextStepButton(_nextStep),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => _goToStep(2),
          child: const Text('Back to Password', style: TextStyle(color: Color(0xFF775A19))),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: _buildStepTitle('Confirm Your Details')),
        _buildConfirmItem('NAME', _data.name.isEmpty ? 'Rajesh Kumar Sharma' : _data.name),
        _buildConfirmItem('EMAIL', _data.email.isEmpty ? 'rajesh.sharma@example.in' : _data.email),
        Row(
          children: [
            Expanded(child: _buildConfirmItem('DISTRICT', _data.district.isEmpty ? 'Pune' : _data.district)),
            Expanded(child: _buildConfirmItem('TALUKA', _data.taluka.isEmpty ? 'Haveli' : _data.taluka)),
          ],
        ),
        _buildConfirmItem('GRAM PANCHAYAT', _data.gramPanchayat.isEmpty ? 'Wagholi Gram Panchayat' : _data.gramPanchayat),
        const SizedBox(height: 40),
        _buildNextStepButton(_nextStep, label: 'Confirm & Submit'),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () => _goToStep(1),
            child: const Text(
              'Edit Details',
              style: TextStyle(color: Color(0xFF775A19), fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepTitle(String title) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF49000A), fontFamily: 'serif'),
        ),
        const SizedBox(height: 8),
        Container(width: 48, height: 4, decoration: BoxDecoration(color: const Color(0xFF775A19), borderRadius: BorderRadius.circular(2))),
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
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Color(0xFF564241)),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, Function(String) onChanged, {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5EDDE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: obscure,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF8A7171)),
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF8A7171), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint, IconData icon, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF5EDDE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF8A7171)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hint,
              style: const TextStyle(color: Color(0xFF8A7171), fontSize: 14),
            ),
          ),
          const Icon(Icons.expand_more, color: Color(0xFF8A7171)),
        ],
      ),
    );
  }

  Widget _buildOtpBox() {
    return Container(
      width: 42,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF5EDDE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget _buildPrimaryButton(String label, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        icon: Icon(icon, size: 18),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF49000A),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String label, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: const Color(0xFF775A19)),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF775A19))),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEFE7D9),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildNextStepButton(VoidCallback onPressed, {String label = 'Next Step'}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF775A19),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Color(0xFF8A7171)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1B13)),
          ),
        ],
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
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Color(0xFF49000A)),
          ),
          const SizedBox(height: 4),
          Text(
            '© 2024 Digital Custodian Governance.\nOfficial Restricted Access.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: const Color(0xFF564241).withOpacity(0.6)),
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Privacy Policy', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
              SizedBox(width: 20),
              Text('Terms of Service', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
              SizedBox(width: 20),
              Text('Accessibility', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}

class SignupData {
  String name = '';
  String email = '';
  String password = '';
  String district = '';
  String taluka = '';
  String gramPanchayat = '';
}
