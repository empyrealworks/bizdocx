import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../services/firebase_service.dart';

class AssetManagerSheet extends ConsumerStatefulWidget {
  const AssetManagerSheet({super.key, required this.portfolioId});
  final String portfolioId;

  @override
  ConsumerState<AssetManagerSheet> createState() =>
      _AssetManagerSheetState();
}

class _AssetManagerSheetState extends ConsumerState<AssetManagerSheet> {
  bool _uploading = false;
  String? _logoUrl;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCurrentLogo();
  }

  Future<void> _loadCurrentLogo() async {
    try {
      final ctx =
      await FirebaseService.instance.fetchContext(widget.portfolioId);
      if (mounted) setState(() => _logoUrl = ctx.logoStorageUrl);
    } catch (_) {}
  }

  Future<void> _pickAndUpload() async {
    setState(() => _error = null);
    final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 85, maxWidth: 800);
    if (picked == null) return;

    setState(() => _uploading = true);
    try {
      final ext = picked.path.split('.').last.toLowerCase();
      final url = await FirebaseService.instance.uploadLogo(
        file: File(picked.path),
        portfolioId: widget.portfolioId,
        contentType: ext == 'png' ? 'image/png' : 'image/jpeg',
      );
      if (mounted) {
        setState(() => _logoUrl = url);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Logo uploaded. New documents will include it automatically.'),
        ));
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _deleteLogo() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove logo?'),
        content: const Text(
          'The logo will be removed from future documents. Existing documents are unaffected.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Remove',
                  style: const TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _uploading = true);
    try {
      await FirebaseService.instance.deleteLogo(widget.portfolioId);
      if (mounted) setState(() => _logoUrl = null);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottom),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Text('Portfolio Assets',
              style: Theme.of(context).textTheme.headlineMedium),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.close, color: c.iconSecondary),
            onPressed: () => Navigator.pop(context),
          ),
        ]),
        const SizedBox(height: 4),
        Text(
          'Assets here are automatically included in relevant generated documents.',
          style: TextStyle(color: c.textMuted, fontSize: 13),
        ),
        const SizedBox(height: 24),

        // Logo section
        Align(
          alignment: Alignment.centerLeft,
          child: Text('COMPANY LOGO',
              style: TextStyle(
                  color: c.textMuted, fontSize: 10,
                  letterSpacing: 0.8, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 4),
        Text(
          'Appears in invoices, proposals, letterheads, and business cards.',
          style: TextStyle(color: c.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 12),
        _LogoCard(
          logoUrl: _logoUrl,
          isLoading: _uploading,
          onUpload: _pickAndUpload,
          onDelete: _logoUrl != null ? _deleteLogo : null,
        ),

        if (_error != null) ...[
          const SizedBox(height: 10),
          Text(_error!,
              style: const TextStyle(color: AppColors.error, fontSize: 12)),
        ],

        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: c.chipFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.border),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.lightbulb_outline, size: 16, color: c.iconSecondary),
            const SizedBox(width: 10),
            Expanded(child: Text(
              'More business detail = better documents. '
                  'Edit your mission, description, and brand colors via the ✏️ button.',
              style: TextStyle(
                  color: c.textBody, fontSize: 12, height: 1.5),
            )),
          ]),
        ),
        const SizedBox(height: 8),
      ]),
    );
  }
}

// ── Logo Card ─────────────────────────────────────────────────────────────────

class _LogoCard extends StatelessWidget {
  const _LogoCard({
    required this.logoUrl,
    required this.isLoading,
    required this.onUpload,
    required this.onDelete,
  });

  final String? logoUrl;
  final bool isLoading;
  final VoidCallback onUpload;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: c.chipFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: logoUrl != null
              ? c.borderStrong.withValues(alpha: 0.5)
              : c.border,
          width: logoUrl != null ? 1.5 : 1,
        ),
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
          : Row(children: [
        Expanded(
          child: GestureDetector(
            onTap: logoUrl == null ? onUpload : null,
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(11)),
              child: logoUrl != null
                  ? CachedNetworkImage(
                      imageUrl: logoUrl!,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (context, url, error) =>
                          const _Placeholder(hasError: true),
                    )
                  : const _Placeholder(hasError: false),
            ),
          ),
        ),
        Container(
          width: 100,
          decoration: BoxDecoration(
              border: Border(left: BorderSide(color: c.border))),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Btn(
                  icon: logoUrl != null
                      ? Icons.swap_horiz_rounded
                      : Icons.upload_rounded,
                  label: logoUrl != null ? 'Replace' : 'Upload',
                  onTap: onUpload,
                  color: c.iconSecondary,
                ),
                if (onDelete != null) ...[
                  const SizedBox(height: 10),
                  _Btn(
                      icon: Icons.delete_outline_rounded,
                      label: 'Remove',
                      onTap: onDelete!,
                      color: AppColors.error),
                ],
              ]),
        ),
      ]),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.hasError});
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          hasError
              ? Icons.broken_image_outlined
              : Icons.add_photo_alternate_outlined,
          size: 32, color: c.textMuted,
        ),
        const SizedBox(height: 6),
        Text(hasError ? 'Failed to load' : 'Tap to add logo',
            style: TextStyle(color: c.textMuted, fontSize: 11)),
      ]),
    );
  }
}

class _Btn extends StatelessWidget {
  const _Btn(
      {required this.icon, required this.label,
        required this.onTap, required this.color});
  final IconData icon; final String label;
  final VoidCallback onTap; final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ]),
    );
  }
}
