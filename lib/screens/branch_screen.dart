import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_31/models/brach_model.dart';
import 'package:flutter_application_31/providers/branch_provider.dart';

class BranchSetupScreen extends StatefulWidget {
  const BranchSetupScreen({super.key});

  @override
  _BranchSetupScreenState createState() => _BranchSetupScreenState();
}

class _BranchSetupScreenState extends State<BranchSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create new branch
      final newBranch = InventoryBranch(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        location: _locationController.text,
        contact: _contactController.text,
      );

      Provider.of<BranchProvider>(context, listen: false).addBranch(newBranch);

      // Clear form
      _nameController.clear();
      _locationController.clear();
      _contactController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Branch created successfully!'),
        ), // Fixed syntax
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Inventory Branch')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Branch Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (value.length < 3) return 'Minimum 3 characters';
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact Details'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (!RegExp(
                    r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$',
                  ).hasMatch(value))
                    return 'Invalid contact format';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Branch'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
