import 'package:flutter/material.dart';
import 'data_base/database.dart';
import 'dart:convert';


class VendorListingPage extends StatefulWidget {
  @override
  _VendorListingPageState createState() => _VendorListingPageState();
}

class _VendorListingPageState extends State<VendorListingPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _vendorsFuture;

  @override
  void initState() {
    super.initState();
    _vendorsFuture = _fetchVendors();
  }

  Future<List<Map<String, dynamic>>> _fetchVendors() async {
    return await _dbHelper.getAllVendors();
  }

  Future<List<Map<String, dynamic>>> _fetchVendorItems(String username) async {
    return await _dbHelper.getVendorItems(username);
  }

  void _showItemImage(String imageBase64) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: imageBase64.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.memory(
              base64Decode(imageBase64),
              fit: BoxFit.cover,
            ),
          )
              : Text("No image available", style: TextStyle(color: Colors.grey[600])),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", style: TextStyle(color: Colors.pink[800], fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vendors Listing", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.pink[800],
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _vendorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.pink));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading vendors", style: TextStyle(color: Colors.red)));
          }

          List<Map<String, dynamic>> vendors = snapshot.data ?? [];
          Map<String, List<Map<String, dynamic>>> groupedVendors = {};

          for (var vendor in vendors) {
            String location = vendor['location'] ?? "Unknown";
            groupedVendors.putIfAbsent(location, () => []).add(vendor);
          }

          return ListView(
            padding: EdgeInsets.all(10),
            children: groupedVendors.entries.map((entry) {
              return Card(
                color: Colors.white.withOpacity(0.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 5,
                margin: EdgeInsets.only(bottom: 15),
                child: ExpansionTile(
                  iconColor: Colors.pink[400],
                  collapsedIconColor: Colors.pink[400],
                  backgroundColor: Colors.transparent,
                  tilePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  title: Text(entry.key, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink[800])),
                  children: entry.value.map((vendor) {
                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchVendorItems(vendor['username']),
                      builder: (context, itemSnapshot) {
                        if (itemSnapshot.connectionState == ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator(color: Colors.pink)),
                          );
                        } else if (itemSnapshot.hasError) {
                          return Center(child: Text("Error loading items", style: TextStyle(color: Colors.red)));
                        }

                        List<Map<String, dynamic>> items = itemSnapshot.data ?? [];

                        return Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.pink[100]?.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(vendor['username'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink[700])),
                              SizedBox(height: 5),
                              Text("Status: ${vendor['is_open'] == 1 ? "Open ✅" : "Closed ❌"}"),
                              Text("Exchange Rights: ${vendor['exchange_rights'] == 1 ? "Allowed ✅" : "Not Allowed ❌"}"),
                              Text("Donations: ${vendor['donations'] == 1 ? "Allowed ✅" : "Not Allowed ❌"}"),
                              if (items.isNotEmpty) ...[
                                SizedBox(height: 10),
                                Text("Items:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple[700])),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: items.map((item) {
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(top: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 1)],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${item['item_name']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink[900])),
                                                SizedBox(height: 5),
                                                Text("Price: ${item['price'] ?? "N/A"}", style: TextStyle(fontSize: 14, color: Colors.black)),
                                                Text("Description: ${item['description'] ?? "No description"}", style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.image, color: Colors.pink[400]),
                                            onPressed: item['image_path'] != null && item['image_path'].isNotEmpty
                                                ? () => _showItemImage(item['image_path'])
                                                : null,
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ]
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}