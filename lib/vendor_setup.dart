import 'package:flutter/material.dart';
import 'data_base/database.dart';
import 'vendors.dart';

class VendorSetupPage extends StatefulWidget {
  final String username;

  const VendorSetupPage({super.key, required this.username});

  @override
  _VendorSetupPageState createState() => _VendorSetupPageState();
}

class _VendorSetupPageState extends State<VendorSetupPage> {
  final TextEditingController _locationController = TextEditingController();
  bool isOpenForBusiness = false;
  bool exchangeRights = false;
  bool donations = false;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _saveVendorSetup() async {
    String location = _locationController.text.trim();

    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your location'),
          backgroundColor: Colors.pinkAccent,
        ),
      );
      return;
    }

    await _dbHelper.updateVendorSettings(
      widget.username,
      location,
      isOpenForBusiness,
      exchangeRights,
      donations,
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VendorsPage(username: widget.username),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8D8DA), // Pastel pink background
      resizeToAvoidBottomInset: true, // Prevent keyboard overflow
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                _buildHeader(),
                const SizedBox(height: 20),
                _buildLocationInput(),
                const SizedBox(height: 20),
                _buildToggles(),
                const SizedBox(height: 40), // Extra spacing before submit button
                Center(child: _buildSubmitButton()), // Center the button
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Text(
          "Vendor Setup",
          style: TextStyle(
            fontFamily: 'Dancingscript',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInput() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _locationController,
        decoration: const InputDecoration(
          hintText: "Your store location...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black54),
        ),
        style: const TextStyle(
          fontFamily: 'Dancingscript',
          fontSize: 22,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildToggles() {
    return Column(
      children: [
        _buildToggle("Open for Business", isOpenForBusiness, (value) {
          setState(() => isOpenForBusiness = value);
        }),
        _buildToggle("Exchange Rights", exchangeRights, (value) {
          setState(() => exchangeRights = value);
        }),
        _buildToggle("Donations", donations, (value) {
          setState(() => donations = value);
        }),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _saveVendorSetup,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: const Text(
        "Submit & Enter Vendor Space",
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Dancingscript',
        ),
      ),
    );
  }

  Widget _buildToggle(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Dancingscript',
              fontWeight: FontWeight.bold,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.pinkAccent,
          ),
        ],
      ),
    );
  }
}
