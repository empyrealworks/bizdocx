import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_colors.dart';
import '../../services/firebase_service.dart';

/// Shows logo upload and context asset management for a portfolio.
///
/// Required in pubspec.yaml:
///   image_picker: ^1.1.0
///
/// Required in ios/Info.plist:
///   NSPhotoLibraryUsageDescription
///   NSCameraUsageDescription
///
/// Required in android/app/src/main/AndroidManifest.xml:
///   (none extra — image_picker handles it)
class AssetManagerSheet extends ConsumerStatefulWidget {
  const AssetManagerSheet({super.key, required this.portfolioId});
  final String portfolioId;

  @override
  ConsumerState<AssetManagerSheet> createState() => _AssetManagerSheetState();
}

class _AssetManagerSheetState extends ConsumerState<AssetManagerSheet> {
  bool _uploadingLogo = false;
  String? _logoUrl; // local optimistic state
  String? _error;

  @override
  void initState() {
    super.initState();
    // Seed from cached UserContext if available
    _loadCurrentLogo();
  }

  Future<void> _loadCurrentLogo() async {
    try {
      final ctx = await FirebaseService.instance
          .fetchContext(widget.portfolioId);
      if (mounted) setState(() => _logoUrl = ctx.logoStorageUrl);
    } catch (_) {}
  }

  Future<void> _pickAndUploadLogo() async {
    setState(() { _error = null; });
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 800,
    );
    if (picked == null) return;

    setState(() => _uploadingLogo = true);
    try {
      final file = File(picked.path);
      final ext = picked.path.split('.').last.toLowerCase();
      final contentType =
      ext == 'png' ? 'image/png' : 'image/jpeg';

      final url = await FirebaseService.instance.uploadLogo(
        file: file,
        portfolioId: widget.portfolioId,
        contentType: contentType,
      );

      if (mounted) setState(() => _logoUrl = url);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Logo uploaded. New documents will include it automatically.'),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _uploadingLogo = false);
    }
  }

  Future<void> _deleteLogo() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Remove logo?'),
        content: const Text(
          'The logo will be removed from future document generation. Existing documents are unaffected.',
          style: TextStyle(color: AppColors.silver, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.silver)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _uploadingLogo = true);
    try {
      await FirebaseService.instance.deleteLogo(widget.portfolioId);
      if (mounted) setState(() => _logoUrl = null);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _uploadingLogo = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Portfolio Assets',
                  style: Theme.of(context).textTheme.headlineMedium),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.silver),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Assets added here are included automatically in relevant generated documents.',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // ── Logo ──────────────────────────────────────────────────────
          _SectionHeader('Company Logo'),
          const SizedBox(height: 4),
          const Text(
            'Appears in invoices, proposals, letterheads, and business cards.',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          _LogoCard(
            logoUrl: _logoUrl,
            isLoading: _uploadingLogo,
            onUpload: _pickAndUploadLogo,
            onDelete: _logoUrl != null ? _deleteLogo : null,
          ),

          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!,
                style: const TextStyle(color: AppColors.error, fontSize: 12)),
          ],

          const SizedBox(height: 28),

          // ── Tip ───────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.graphite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline,
                    size: 16, color: AppColors.silver),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'More business detail = better documents. '
                        'Edit your mission, description, and brand colors via the ✏️ button on the portfolio screen.',
                    style: TextStyle(color: AppColors.silver, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
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
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.graphite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: logoUrl != null ? AppColors.silver.withValues(alpha: 0.3) : AppColors.border,
          width: logoUrl != null ? 1.5 : 1,
        ),
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
          : Row(
        children: [
          // Preview area
          Expanded(
            child: GestureDetector(
              onTap: logoUrl == null ? onUpload : null,
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(11)),
                child: logoUrl != null
                    ? Image.network(
                  logoUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                  const _LogoPlaceholder(hasError: true),
                )
                    : const _LogoPlaceholder(hasError: false),
              ),
            ),
          ),
          // Actions
          Container(
            width: 100,
            decoration: const BoxDecoration(
              border: Border(
                  left: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(
                  icon: logoUrl != null
                      ? Icons.swap_horiz_rounded
                      : Icons.upload_rounded,
                  label: logoUrl != null ? 'Replace' : 'Upload',
                  onTap: onUpload,
                ),
                if (onDelete != null) ...[
                  const SizedBox(height: 8),
                  _ActionButton(
                    icon: Icons.delete_outline_rounded,
                    label: 'Remove',
                    onTap: onDelete!,
                    color: AppColors.error,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoPlaceholder extends StatelessWidget {
  const _LogoPlaceholder({required this.hasError});
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasError
                ? Icons.broken_image_outlined
                : Icons.add_photo_alternate_outlined,
            size: 32,
            color: AppColors.muted,
          ),
          const SizedBox(height: 6),
          Text(
            hasError ? 'Failed to load' : 'Tap to add logo',
            style:
            const TextStyle(color: AppColors.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.silver,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: const TextStyle(
      color: AppColors.muted,
      fontSize: 10,
      letterSpacing: 0.8,
      fontWeight: FontWeight.w500,
    ),
  );
}