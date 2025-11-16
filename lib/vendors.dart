import 'package:flutter/material.dart';
import 'add_item.dart';
import 'data_base/database.dart';
import 'dart:io';
import 'dart:convert';


class VendorsPage extends StatefulWidget {
  final String username;
  const VendorsPage({super.key, required this.username});

  @override
  _VendorsPageState createState() => _VendorsPageState();
}

class _VendorsPageState extends State<VendorsPage> {
  bool isOpenForBusiness = false;
  bool exchangeRights = false;
  bool donations = false;
  final TextEditingController _locationController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> vendorItems = [];
  String? _selectedImageUrl;

  @override
  void initState() {
    super.initState();
    _loadVendorSettings();
    _loadVendorItems();
  }

  Future<void> _loadVendorSettings() async {
    final settings = await _dbHelper.getVendorSettings(widget.username);
    if (settings != null) {
      setState(() {
        _locationController.text = settings['location'] ?? "";
        isOpenForBusiness = settings['is_open'] == 1;
        exchangeRights = settings['exchange_rights'] == 1;
        donations = settings['donations'] == 1;
      });
    }
  }

  Future<void> _loadVendorItems() async {
    final items = await _dbHelper.getVendorItems(widget.username);
    setState(() {
      vendorItems = items ?? [];
    });
  }

  Future<void> _updateVendorSettings() async {
    await _dbHelper.updateVendorSettings(
      widget.username,
      _locationController.text,
      isOpenForBusiness,
      exchangeRights,
      donations,
    );
  }

  Future<void> _deleteVendorItem(int id) async {
    await _dbHelper.deleteVendorItem(id);
    _loadVendorItems();
  }

  void _showImageOverlay(String imageUrl) {
    setState(() {
      _selectedImageUrl = imageUrl;
    });
  }

  void _closeImageOverlay() {
    setState(() {
      _selectedImageUrl = null;
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8D8DA),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/vendors_bg.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0, bottom: 30.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildVendorHeader(),
                const SizedBox(height: 20),
                _buildTableHeader(),
                const SizedBox(height: 10),
                Expanded(
                  child: vendorItems.isEmpty
                      ? const Center(
                    child: Text(
                      "No items added yet",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: vendorItems.length,
                    itemBuilder: (context, index) {
                      final item = vendorItems[index];
                      String imageUrl = item['image_path'];


                      return _buildTableRow(
                        item['id'],
                        item['item_name'],
                        "\$${item['price'].toString()}",
                        item['description'],
                        imageUrl,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _buildSettingsToggles(),
              ],
            ),
          ),
          if (_selectedImageUrl != null)
            GestureDetector(
              onTap: _closeImageOverlay,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                alignment: Alignment.center,
                child: Image.memory(
                  base64Decode(_selectedImageUrl!),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Text(
                    "Image not found",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),

              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemPage(vendorUsername: widget.username)),
          );
          _loadVendorItems();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildVendorHeader() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(2, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildUsernameDisplay("Vendor:", widget.username),
          _buildToggle("Open", isOpenForBusiness, (value) {
            setState(() {
              isOpenForBusiness = value;
            });
            _updateVendorSettings();
          }),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Text("Item", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Dancingscript')),
          Text("Price", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Dancingscript')),
          Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Dancingscript')),
          Text(" ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Dancingscript')),
        ],
      ),
    );
  }

  Widget _buildTableRow(int id, String item, String price, String description, String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child: Text(item, overflow: TextOverflow.ellipsis)),
          Expanded(child: Text(price, overflow: TextOverflow.ellipsis)),
          Expanded(
            child: Text(
              description,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.blue, size: 20),
                onPressed: () => _showImageOverlay(imageUrl),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteVendorItem(id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsToggles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildToggle("Exchange Rights", exchangeRights, (value) {
          setState(() {
            exchangeRights = value;
          });
          _updateVendorSettings();
        }),
        _buildToggle("Donations", donations, (value) {
          setState(() {
            donations = value;
          });
          _updateVendorSettings();
        }),
      ],
    );
  }

  Widget _buildUsernameDisplay(String label, String username) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Dancingscript')),
        const SizedBox(width: 5),
        Text(username, style: const TextStyle(fontSize: 16,fontFamily: 'Dancingscript')),
      ],
    );
  }

  Widget _buildToggle(String label, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: 'Dancingscript')),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
