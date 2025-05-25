import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_31/models/sku_model.dart';
import 'package:flutter_application_31/providers/sku_provider.dart';
import 'package:flutter_application_31/screens/barcode_screen.dart';

class SKUSearchScreen extends StatefulWidget {
  const SKUSearchScreen({super.key});

  @override
  _SKUSearchScreenState createState() => _SKUSearchScreenState();
}

class _SKUSearchScreenState extends State<SKUSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SKU> _searchResults = [];

  void _runSearch(String query) {
    final results = Provider.of<SKUProvider>(
      context,
      listen: false,
    ).searchSKUs(query);
    setState(() => _searchResults = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add a scan button to the AppBar
      appBar: AppBar(
        title: const Text('Search SKUs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () async {
              final scannedCode = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BarcodeScannerScreen(),
                ),
              );
              if (scannedCode != null) {
                _searchController.text = scannedCode;
                _runSearch(scannedCode);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by SKU, name, or category',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _runSearch,
            ),
            const SizedBox(height: 20),
            // Search Results
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final sku = _searchResults[index];
                  return ListTile(
                    title: Text(sku.itemName),
                    subtitle: Text(
                      'SKU: ${sku.code} | Category: ${sku.category}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
