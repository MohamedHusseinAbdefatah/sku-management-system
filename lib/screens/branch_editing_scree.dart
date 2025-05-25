import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_31/models/brach_model.dart';
import 'package:flutter_application_31/providers/branch_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_application_31/models/brach_model.dart';
// import 'package:flutter_application_31/providers/branch_provider.dart';
// // lib/screens/branch_edit_screen.dart

// class BranchEditScreen extends StatefulWidget {
//   final InventoryBranch branch;
//   const BranchEditScreen({super.key, required this.branch});

//   @override
//   _BranchEditScreenState createState() => _BranchEditScreenState();
// }

// class _BranchEditScreenState extends State<BranchEditScreen> {
//   final _formKey = GlobalKey<FormState>(); // Add form key
//   late final TextEditingController _nameController;
//   late final TextEditingController _locationController;
//   late final TextEditingController _contactController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.branch.name);
//     _locationController = TextEditingController(text: widget.branch.location);
//     _contactController = TextEditingController(text: widget.branch.contact);
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _locationController.dispose();
//     _contactController.dispose();
//     super.dispose();
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       final updatedBranch = InventoryBranch(
//         id: widget.branch.id,
//         name: _nameController.text,
//         location: _locationController.text,
//         contact: _contactController.text,
//       );

//       Provider.of<BranchProvider>(
//         context,
//         listen: false,
//       ).updateBranch(updatedBranch);

//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Edit Branch')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Branch Name'),
//                 validator: (value) => value!.isEmpty ? 'Required' : null,
//               ),
//               TextFormField(
//                 controller: _locationController,
//                 decoration: const InputDecoration(labelText: 'Location'),
//                 validator: (value) => value!.isEmpty ? 'Required' : null,
//               ),
//               TextFormField(
//                 controller: _contactController,
//                 decoration: const InputDecoration(labelText: 'Contact Details'),
//                 validator: (value) => value!.isEmpty ? 'Required' : null,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: const Text('Save Changes'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class BranchEditScreen extends StatefulWidget {
  final InventoryBranch branch;
  const BranchEditScreen({super.key, required this.branch});

  @override
  _BranchEditScreenState createState() => _BranchEditScreenState();
}

class _BranchEditScreenState extends State<BranchEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.branch.name);
    _locationController = TextEditingController(text: widget.branch.location);
    _contactController = TextEditingController(text: widget.branch.contact);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedBranch = InventoryBranch(
        id: widget.branch.id,
        name: _nameController.text,
        location: _locationController.text,
        contact: _contactController.text,
      );

      Provider.of<BranchProvider>(
        context,
        listen: false,
      ).updateBranch(updatedBranch);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Branch'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Branch Name',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant,
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant,
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(
                  labelText: 'Contact Details',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant,
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
