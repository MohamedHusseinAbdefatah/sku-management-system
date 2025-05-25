import '../models/sku_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_application_31/providers/sku_provider.dart';
import 'package:flutter_application_31/screens/stock_editing_screen.dart';
// import '../models/sku_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:barcode_widget/barcode_widget.dart';
// import 'package:flutter_application_31/providers/sku_provider.dart';
// import 'package:flutter_application_31/screens/stock_editing_screen.dart';

// class SKUListScreen extends StatelessWidget {
//   const SKUListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Colors.blue.shade800;

//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Inventory Management',
//             style: TextStyle(fontWeight: FontWeight.w600),
//           ),
//           bottom: TabBar(
//             indicatorColor: primaryColor,
//             labelColor: primaryColor,
//             unselectedLabelColor: Colors.grey,
//             tabs: const [
//               Tab(icon: Icon(Icons.check_circle), text: 'Active'),
//               Tab(icon: Icon(Icons.remove_circle), text: 'Inactive'),
//             ],
//           ),
//         ),
//         body: Consumer<SKUProvider>(
//           builder: (context, provider, _) {
//             return TabBarView(
//               children: [
//                 _buildSKUList(provider.activeSKUs, context, primaryColor),
//                 _buildSKUList(provider.inactiveSKUs, context, primaryColor),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildSKUList(
//     List<SKU> skus,
//     BuildContext context,
//     Color primaryColor,
//   ) {
//     return skus.isEmpty
//         ? Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.inventory_2, size: 60, color: Colors.grey.shade400),
//                 const SizedBox(height: 16),
//                 Text(
//                   'No items found',
//                   style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
//                 ),
//               ],
//             ),
//           )
//         : ListView.separated(
//             padding: const EdgeInsets.all(16),
//             itemCount: skus.length,
//             separatorBuilder: (_, __) => const SizedBox(height: 12),
//             itemBuilder: (context, index) {
//               final sku = skus[index];
//               return _buildSKUCard(sku, context, primaryColor);
//             },
//           );
//   }

//   Widget _buildSKUCard(SKU sku, BuildContext context, Color primaryColor) {
//     final availableStock = sku.quantity - sku.reservedStock;
//     final isLowStock = availableStock <= sku.reorderThreshold;

//     return Card(
//       elevation: 2,
//       margin: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => StockEditScreen(sku: sku)),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Barcode Section
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade200),
//                 ),
//                 child: BarcodeWidget(
//                   barcode: Barcode.code128(),
//                   data: sku.code,
//                   width: 100,
//                   height: 40,
//                   color: primaryColor,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Item Name and Status
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             sku.itemName,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: sku.isActive ? Colors.black : Colors.grey,
//                               decoration: sku.isActive
//                                   ? null
//                                   : TextDecoration.lineThrough,
//                             ),
//                           ),
//                         ),
//                         Icon(
//                           sku.isActive
//                               ? Icons.check_circle
//                               : Icons.remove_circle,
//                           color: sku.isActive ? primaryColor : Colors.grey,
//                           size: 20,
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     // Category and Code
//                     Text(
//                       '${sku.category} • ${sku.code}',
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 13,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     // Stock Indicator
//                     _buildStockIndicator(
//                       availableStock,
//                       sku,
//                       isLowStock,
//                       context,
//                     ),
//                     // Action Buttons
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           IconButton(
//                             icon: Icon(
//                               Icons.delete_outline,
//                               color: Colors.red.shade400,
//                               size: 24,
//                             ),
//                             onPressed: () => _deleteSKU(sku.code, context),
//                           ),
//                           const SizedBox(width: 12),
//                           IconButton(
//                             icon: Icon(
//                               sku.isActive ? Icons.toggle_on : Icons.toggle_off,
//                               color: sku.isActive
//                                   ? Colors.green
//                                   : Colors.orange,
//                               size: 28,
//                             ),
//                             onPressed: () => _toggleStatus(sku.code, context),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Low Stock Warning
//                     if (isLowStock)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.warning,
//                               color: Colors.orange.shade700,
//                               size: 16,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               'Low Stock Alert!',
//                               style: TextStyle(
//                                 color: Colors.orange.shade700,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _deleteSKU(String code, BuildContext context) {
//     final provider = Provider.of<SKUProvider>(context, listen: false);
//     final deletedSKU = provider.getSKUByCode(code);

//     provider.deleteSKU(code).then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('SKU $code deleted'),
//           backgroundColor: Colors.red.shade800,
//           behavior: SnackBarBehavior.floating,
//           action: SnackBarAction(
//             label: 'Undo',
//             textColor: Colors.white,
//             onPressed: () {
//               if (deletedSKU != null) {
//                 provider.addSKU(deletedSKU);
//               }
//             },
//           ),
//         ),
//       );
//     });
//   }

//   Widget _buildStockIndicator(
//     int availableStock,
//     SKU sku,
//     bool isLowStock,
//     BuildContext context,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Available Stock',
//               style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//             ),
//             Text(
//               '$availableStock/${sku.quantity}',
//               style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//             ),
//           ],
//         ),
//         const SizedBox(height: 4),
//         LinearProgressIndicator(
//           value: sku.reorderThreshold == 0
//               ? 0.0
//               : (availableStock / sku.reorderThreshold).clamp(0.0, 1.0),
//           minHeight: 8,
//           backgroundColor: Colors.grey[300],
//           valueColor: AlwaysStoppedAnimation<Color>(
//             isLowStock
//                 ? Colors.orange.shade700
//                 : Theme.of(context).colorScheme.primary,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           'Reorder at ${sku.reorderThreshold}',
//           style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//         ),
//       ],
//     );
//   }

//   void _toggleStatus(String code, BuildContext context) {
//     final provider = Provider.of<SKUProvider>(context, listen: false);
//     provider.toggleSKUStatus(code);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('SKU $code status updated'),
//         backgroundColor: Colors.blue.shade800,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         action: SnackBarAction(
//           label: 'Undo',
//           textColor: Colors.white,
//           onPressed: () => provider.toggleSKUStatus(code),
//         ),
//       ),
//     );
//   }
// }

class SKUListScreen extends StatelessWidget {
  const SKUListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blue.shade800;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Inventory Management',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          bottom: TabBar(
            indicatorColor: primaryColor,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(icon: Icon(Icons.check_circle), text: 'Active'),
              Tab(icon: Icon(Icons.remove_circle), text: 'Inactive'),
            ],
          ),
        ),
        body: Consumer<SKUProvider>(
          builder: (context, provider, _) {
            return TabBarView(
              children: [
                _buildSKUList(provider.activeSKUs, context, primaryColor),
                _buildSKUList(provider.inactiveSKUs, context, primaryColor),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSKUList(
    List<SKU> skus,
    BuildContext context,
    Color primaryColor,
  ) {
    return skus.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2, size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No items found',
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: skus.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final sku = skus[index];
              return _buildSKUCard(sku, context, primaryColor);
            },
          );
  }

  Widget _buildSKUCard(SKU sku, BuildContext context, Color primaryColor) {
    final availableStock = sku.quantity - sku.reservedStock;
    final isLowStock = availableStock <= sku.reorderThreshold;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StockEditScreen(sku: sku)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barcode Section
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: sku.code,
                  width: 100,
                  height: 40,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Name and Status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            sku.itemName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: sku.isActive ? Colors.black : Colors.grey,
                              decoration: sku.isActive
                                  ? null
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        Icon(
                          sku.isActive
                              ? Icons.check_circle
                              : Icons.remove_circle,
                          color: sku.isActive ? primaryColor : Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Category and Code
                    Text(
                      '${sku.category} • ${sku.code}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Stock Indicator
                    _buildStockIndicator(
                      availableStock,
                      sku,
                      isLowStock,
                      context,
                    ),
                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red.shade400,
                              size: 24,
                            ),
                            onPressed: () => _deleteSKU(sku.code, context),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: Icon(
                              sku.isActive ? Icons.toggle_on : Icons.toggle_off,
                              color: sku.isActive
                                  ? Colors.green
                                  : Colors.orange,
                              size: 28,
                            ),
                            onPressed: () => _toggleStatus(sku.code, context),
                          ),
                        ],
                      ),
                    ),
                    // Low Stock Warning
                    if (isLowStock)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning,
                              color: Colors.orange.shade700,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Low Stock Alert!',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteSKU(String code, BuildContext context) {
    final provider = Provider.of<SKUProvider>(context, listen: false);
    final deletedSKU = provider.getSKUByCode(code);

    provider.deleteSKU(code).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('SKU $code deleted'),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Undo',
            textColor: Colors.white,
            onPressed: () {
              if (deletedSKU != null) {
                provider.addSKU(deletedSKU);
              }
            },
          ),
        ),
      );
    });
  }

  Widget _buildStockIndicator(
    int availableStock,
    SKU sku,
    bool isLowStock,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available Stock',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            Text(
              '$availableStock/${sku.quantity}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: sku.reorderThreshold == 0
              ? 0.0
              : (availableStock / sku.reorderThreshold).clamp(0.0, 1.0),
          minHeight: 8,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            isLowStock
                ? Colors.orange.shade700
                : Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Reorder at ${sku.reorderThreshold}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  void _toggleStatus(String code, BuildContext context) {
    final provider = Provider.of<SKUProvider>(context, listen: false);
    provider.toggleSKUStatus(code);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('SKU $code status updated'),
        backgroundColor: Colors.blue.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () => provider.toggleSKUStatus(code),
        ),
      ),
    );
  }
}
