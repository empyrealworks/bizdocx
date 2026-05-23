import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/utils/smart_field_utility.dart';
import '../../models/document_asset.dart';
import '../../services/firebase_service.dart';

class SmartFieldEditorSheet extends ConsumerStatefulWidget {
  const SmartFieldEditorSheet({super.key, required this.asset, this.isNew = false});
  final DocumentAsset asset;
  final bool isNew;

  @override
  ConsumerState<SmartFieldEditorSheet> createState() => _SmartFieldEditorSheetState();
}

class _SmartFieldEditorSheetState extends ConsumerState<SmartFieldEditorSheet> {
  final Map<String, TextEditingController> _controllers = {};
  List<SmartField> _fields = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initFields();
  }

  void _initFields() {
    if (widget.asset.htmlContent == null) return;
    _fields = SmartFieldUtility.parse(widget.asset.htmlContent!);
    for (final field in _fields) {
      _controllers[field.key] = TextEditingController(text: field.value);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final updates = <String, String>{};
      _controllers.forEach((key, controller) {
        updates[key] = controller.text;
      });

      final newHtml = SmartFieldUtility.update(widget.asset.htmlContent!, updates);
      
      // If we extracted a client name, update the model field too
      final clientName = updates['client_name'];

      final updatedAsset = widget.asset.copyWith(
        htmlContent: newHtml,
        clientName: clientName ?? widget.asset.clientName,
      );

      final result = await FirebaseService.instance.updateDocumentAsset(updatedAsset);
      
      if (mounted) {
        Navigator.pop(context, result);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document updated successfully locally.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isNew ? 'New Document Details' : 'Quick Local Edit',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Modify the smart fields below to update the document layout locally.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            
            if (_fields.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No smart fields found in this document.', textAlign: TextAlign.center),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _fields.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final field = _fields[index];
                    return TextField(
                      controller: _controllers[field.key],
                      decoration: InputDecoration(
                        labelText: _formatKey(field.key),
                        hintText: 'Enter ${field.key}',
                      ),
                    );
                  },
                ),
              ),
            
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                : const Text('Save & Preview'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _formatKey(String key) {
    return key.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}
