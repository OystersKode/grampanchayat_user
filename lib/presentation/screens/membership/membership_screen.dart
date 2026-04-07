import 'package:flutter/material.dart';
import '../../../data/repositories/app_repository.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isSubmitting = false;
  bool _isLoading = true;
  bool _alreadySubmitted = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    try {
      final submitted = await AppRepository.instance.hasSubmittedRequest();
      if (mounted) {
        setState(() {
          _alreadySubmitted = submitted;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String name = _nameController.text.trim();
    final String phone = _phoneController.text.trim();
    final String address = _addressController.text.trim();

    if (name.isEmpty) {
      _showMessage('Please enter your name');
      return;
    }

    if (phone.isEmpty) {
      _showMessage('Please enter your phone number');
      return;
    }

    if (phone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      _showMessage('Please enter a valid 10-digit phone number');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await AppRepository.instance.submitMemberRequest(
        name: name,
        mobileNumber: phone,
        address: address,
      );
      _showMessage('Request submitted successfully');
      setState(() {
        _alreadySubmitted = true;
      });
    } catch (error) {
      _showMessage(error.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E0006),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Become a member',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF5E0006)))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                child: _alreadySubmitted ? _buildAlreadySubmittedUI() : _buildFormUI(),
              ),
            ),
    );
  }

  Widget _buildAlreadySubmittedUI() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.green,
            size: 80,
          ),
          const SizedBox(height: 24),
          const Text(
            'Already Submitted!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF370002),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your membership request has already been received and is currently under review by the Gram Panchayat administration.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF653D1E),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5E0006),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('BACK TO HOME'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormUI() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Membership Form',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF370002),
            ),
          ),
          const SizedBox(height: 40),
          _buildFieldLabel('FULL NAME'),
          _buildTextField(Icons.person_outline, controller: _nameController),
          const SizedBox(height: 32),
          _buildFieldLabel('PHONE NUMBER'),
          _buildTextField(
            Icons.phone_outlined,
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
          ),
          const SizedBox(height: 32),
          _buildFieldLabel('ADDRESS'),
          _buildTextField(
            Icons.location_on_outlined,
            controller: _addressController,
            maxLines: 3,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E0006),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8A7171),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField(
    IconData icon, {
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF57413F), size: 22),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFEFE7D9), width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF5E0006), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        counterText: '',
      ),
    );
  }
}
