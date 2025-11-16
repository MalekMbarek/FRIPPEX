import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'data_base/database.dart';
import 'vendors.dart';


class AddItemPage extends StatefulWidget {
  final String vendorUsername;

  const AddItemPage({super.key, required this.vendorUsername});

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String? _imageBase64;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      List<int> imageBytes = await File(image.path).readAsBytes();
      String base64Image = base64Encode(imageBytes);

      setState(() {
        _imageBase64 = base64Image;
      });
    }
  }

  Future<void> _addItem() async {
    String name = _nameController.text.trim();
    String priceText = _priceController.text.trim();
    String description = _descriptionController.text.trim();

    if (name.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item name and price are required."),
          backgroundColor: Colors.pinkAccent,
        ),
      );
      return;
    }

    double? price = double.tryParse(priceText);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid price format."),
          backgroundColor: Colors.pinkAccent,
        ),
      );
      return;
    }

    description = description.isNotEmpty ? description : "No description";
    String imageBase64 = _imageBase64 ?? "";

    await _dbHelper.addVendorItem(widget.vendorUsername, name, price, description, imageBase64);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item added successfully!🛒"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VendorsPage(username: widget.vendorUsername)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8D8DA),
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  "assets/vendors_bg.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInputSquare("Item Name", _nameController),
                      const SizedBox(height: 16),
                      _buildInputSquare("Price", _priceController, isNumeric: true),
                      const SizedBox(height: 16),
                      _buildInputSquare("Description (Optional)", _descriptionController, maxLines: 3),
                      const SizedBox(height: 16),
                      _buildImageUploadButton(),
                      if (_imageBase64 != null)
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.memory(
                            base64Decode(_imageBase64!),
                            height: 100,
                          ),
                        ),
                      const SizedBox(height: 20),
                      _buildAddButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSquare(String label, TextEditingController controller, {bool isNumeric = false, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF2AEBB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Dancingscript',
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Enter $label',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              maxLines: maxLines,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF2AEBB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: _pickImage,
      child: const Text(
        "Upload Image (Optional)",
        style: TextStyle(fontSize: 16, fontFamily: 'Dancingscript', fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: _addItem,
      child: const Text(
        "Add Item",
        style: TextStyle(fontSize: 18, fontFamily: 'Dancingscript', fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
