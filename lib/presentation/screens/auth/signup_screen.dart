import 'package:flutter/material.dart';
import '../../widgets/header.dart';
import '../../../routes/app_routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 1;
  final SignupData _data = SignupData();
  bool _obscurePassword = true;

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.news);
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context); // Go back to Sign In screen
    }
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

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        children: List.generate(4, (index) {
          int stepNum = index + 1;
          bool isCompleted = _currentStep > stepNum;
          bool isActive = _currentStep == stepNum;

          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted || isActive ? const Color(0xFF775A19) : const Color(0xFFF5EDDE),
                    border: isActive ? Border.all(color: const Color(0xFF49000A), width: 2) : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text(
                            '$stepNum',
                            style: TextStyle(
                              fontSize: 12, 
                              fontWeight: FontWeight.bold,
                              color: isActive ? Colors.white : const Color(0xFF8A7171),
                            ),
                          ),
                  ),
                ),
                if (index < 3)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isCompleted ? const Color(0xFF775A19) : const Color(0xFFF5EDDE),
                    ),
                  ),
              ],
            ),
          );
        }),
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
          _buildStepper(),
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
        _buildStepTitle('Citizen Signup'),
        _buildLabel('FULL NAME'),
        _buildTextField('Enter your full name', Icons.person_outline, (val) => _data.name = val),
        const SizedBox(height: 20),
        _buildLabel('EMAIL ADDRESS'),
        _buildTextField('Enter your email', Icons.alternate_email_outlined, (val) => _data.email = val),
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
        _buildSecondaryButton('Verify OTP', Icons.verified_outlined, () {}),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {},
          child: const Text('Resend OTP', style: TextStyle(color: Color(0xFF775A19), fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 24),
        _buildNextStepButton(_nextStep),
        TextButton(
          onPressed: _prevStep,
          child: const Text('Back to Sign In', style: TextStyle(color: Color(0xFF775A19))),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        _buildStepTitle('Set Your Password'),
        _buildLabel('CREATE PASSWORD'),
        _buildPasswordField('Enter new password', (val) => _data.password = val),
        const SizedBox(height: 20),
        _buildLabel('CONFIRM PASSWORD'),
        _buildPasswordField('Confirm your password', (val) {}),
        const SizedBox(height: 8),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Password must be at least 8 characters', style: TextStyle(color: Color(0xFF775A19), fontSize: 12)),
        ),
        const SizedBox(height: 40),
        _buildNextStepButton(_nextStep, label: 'Save Password'),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _prevStep,
          child: const Text('Back to Profile Info', style: TextStyle(color: Color(0xFF775A19))),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        _buildStepTitle('Select Location'),
        _buildLabel('DISTRICT'),
        _buildDropdown('Select District', Icons.location_on_outlined, (val) => _data.district = val ?? ''),
        const SizedBox(height: 20),
        _buildLabel('TALUKA'),
        _buildDropdown('Select Taluka', Icons.explore_outlined, (val) => _data.taluka = val ?? ''),
        const SizedBox(height: 20),
        _buildLabel('GRAM PANCHAYAT'),
        _buildDropdown('Select Grampanchayat', Icons.holiday_village_outlined, (val) => _data.gramPanchayat = val ?? ''),
        const SizedBox(height: 40),
        _buildNextStepButton(_nextStep),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _prevStep,
          child: const Text('Back to Password', style: TextStyle(color: Color(0xFF775A19))),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: _buildStepTitle('Confirm Details')),
        _buildConfirmItem('NAME', _data.name.isEmpty ? 'Manjunath Rao' : _data.name),
        _buildConfirmItem('EMAIL', _data.email.isEmpty ? 'manjunath@example.com' : _data.email),
        Row(
          children: [
            Expanded(child: _buildConfirmItem('DISTRICT', _data.district.isEmpty ? 'Pune' : _data.district)),
            Expanded(child: _buildConfirmItem('TALUKA', _data.taluka.isEmpty ? 'Haveli' : _data.taluka)),
          ],
        ),
        _buildConfirmItem('GRAM PANCHAYAT', _data.gramPanchayat.isEmpty ? 'Wagholi' : _data.gramPanchayat),
        const SizedBox(height: 40),
        _buildNextStepButton(_nextStep, label: 'Confirm & Submit'),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: _prevStep,
            child: const Text(
              'Back to Location',
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
          textAlign: TextAlign.center,
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

  Widget _buildTextField(String hint, IconData icon, Function(String) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5EDDE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: onChanged,
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

  Widget _buildPasswordField(String hint, Function(String) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5EDDE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: _obscurePassword,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF8A7171), size: 20),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: const Color(0xFF8A7171),
              size: 20,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
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
          Icon(icon, color: const Color(0xFF8A7171), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(hint, style: const TextStyle(color: Color(0xFF8A7171), fontSize: 14)),
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
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Color(0xFF8A7171))),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1B13))),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          const Text('SECURE ACCESS FOR CITIZENS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Color(0xFF49000A))),
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
