import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_31/models/brach_model.dart';
import 'package:flutter_application_31/screens/branch_screen.dart';
import 'package:flutter_application_31/providers/branch_provider.dart';
import 'package:flutter_application_31/screens/branch_editing_scree.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_application_31/models/brach_model.dart';
// import 'package:flutter_application_31/screens/branch_screen.dart';
// import 'package:flutter_application_31/providers/branch_provider.dart';
// import 'package:flutter_application_31/screens/branch_editing_scree.dart';
// // lib/screens/branch_list_screen.dart

// class BranchListScreen extends StatelessWidget {
//   const BranchListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<BranchProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Branches'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const BranchSetupScreen(),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () => provider.loadBranches(),
//         child: ListView.separated(
//           padding: const EdgeInsets.all(16),
//           itemCount: provider.branches.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 12),
//           itemBuilder: (context, index) {
//             final branch = provider.branches[index];
//             return Card(
//               elevation: 2,
//               child: ListTile(
//                 leading: const Icon(Icons.store, color: Colors.blue),
//                 title: Text(
//                   branch.name,
//                   style: const TextStyle(fontWeight: FontWeight.w500),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(branch.location),
//                     const SizedBox(height: 4),
//                     Text(
//                       branch.contact,
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.blue),
//                   onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (c) => BranchEditScreen(branch: branch),
//                     ),
//                   ),
//                 ),
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (c) => BranchEditScreen(branch: branch),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

class BranchListScreen extends StatelessWidget {
  const BranchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = Provider.of<BranchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Branches'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: colorScheme.onPrimary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BranchSetupScreen(),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: colorScheme.surface,
        color: colorScheme.primary,
        onRefresh: () => provider.loadBranches(),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: provider.branches.length,
          separatorBuilder: (_, __) => const Divider(height: 24),
          itemBuilder: (context, index) {
            final branch = provider.branches[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: colorScheme.surface,
              child: ListTile(
                leading: Icon(Icons.store_outlined, color: colorScheme.primary),
                title: Text(
                  branch.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(branch.location, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text(
                      branch.contact,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit_outlined, color: colorScheme.primary),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => BranchEditScreen(branch: branch),
                    ),
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => BranchEditScreen(branch: branch),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
