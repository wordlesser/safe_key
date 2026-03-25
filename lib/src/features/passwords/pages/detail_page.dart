import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../shared/constants/app_theme.dart';
import '../../../shared/models/password_entry.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../controller/passwords_controller.dart';
import 'add_edit_page.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.entry});

  final PasswordEntry entry;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _passwordVisible = false;

  void _copy(BuildContext context, String text, String label) {
    final pwd = context.read<PasswordsController>();
    pwd.copyToClipboard(
      text,
      label: label,
      onCopied: (msg) => AppSnackbar.show(context, msg, isSuccess: true),
    );
  }

  void _confirmDelete(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceVariant,
        title: Text(
          l10n.deleteConfirmTitle,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          l10n.deleteConfirmContentShort(widget.entry.name),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<PasswordsController>().deleteEntry(widget.entry.id);
              Navigator.of(context).pop();
              AppSnackbar.show(
                context,
                l10n.deletedEntry(widget.entry.name),
              );
            },
            child: Text(
              l10n.delete,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entry = widget.entry;
    final cat = entry.category;

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.editTooltip,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => AddEditPage(entry: entry),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: l10n.deleteTooltip,
            color: AppColors.error,
            onPressed: () => _confirmDelete(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: cat.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: cat.color.withValues(alpha: 0.25),
                  ),
                ),
                child: Center(
                  child: Text(
                    entry.name.isEmpty ? '?' : entry.name.characters.first.toUpperCase(),
                    style: TextStyle(
                      color: cat.color,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                entry.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: cat.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(cat.icon, color: cat.color, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      cat.displayName(context),
                      style: TextStyle(
                        color: cat.color,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _DetailField(
                label: l10n.usernameFieldLabel,
                value: entry.username,
                icon: Icons.person_outline_rounded,
                onCopy: () => _copy(
                  context,
                  entry.username,
                  l10n.copiedLabel(l10n.usernameFieldLabel),
                ),
              ),
              const SizedBox(height: 12),
              _PasswordField(
                label: l10n.passwordFieldLabel,
                password: entry.password,
                visible: _passwordVisible,
                onToggle: () =>
                    setState(() => _passwordVisible = !_passwordVisible),
                onCopy: () => _copy(
                  context,
                  entry.password,
                  l10n.copiedLabel(l10n.passwordFieldLabel),
                ),
              ),
              if (entry.url.isNotEmpty) ...[
                const SizedBox(height: 12),
                _DetailField(
                  label: l10n.urlFieldLabel,
                  value: entry.url,
                  icon: Icons.link_rounded,
                  onCopy: () => _copy(
                    context,
                    entry.url,
                    l10n.copiedLabel(l10n.urlFieldLabel),
                  ),
                ),
              ],
              if (entry.note.isNotEmpty) ...[
                const SizedBox(height: 12),
                _DetailField(
                  label: l10n.noteFieldLabel,
                  value: entry.note,
                  icon: Icons.notes_rounded,
                  onCopy: () => _copy(
                    context,
                    entry.note,
                    l10n.copiedLabel(l10n.noteFieldLabel),
                  ),
                  multiline: true,
                ),
              ],
              const SizedBox(height: 24),
              _TimeInfo(entry: entry),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onCopy,
    this.multiline = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onCopy;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.textHint, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onCopy,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.content_copy_rounded,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.password,
    required this.visible,
    required this.onToggle,
    required this.onCopy,
  });

  final String label;
  final String password;
  final bool visible;
  final VoidCallback onToggle;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.textHint,
            size: 20,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                visible
                    ? Text(
                        password,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontFamily: 'monospace',
                          letterSpacing: 0.5,
                        ),
                      )
                    : Text(
                        '•' * password.length.clamp(8, 20),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 20,
                          letterSpacing: 2,
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                visible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onCopy,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.content_copy_rounded,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeInfo extends StatelessWidget {
  const _TimeInfo({required this.entry});

  final PasswordEntry entry;

  String _format(DateTime dt) {
    return '${dt.year}-${_pad(dt.month)}-${_pad(dt.day)} '
        '${_pad(dt.hour)}:${_pad(dt.minute)}';
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.textHint,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.createdAt,
                style: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Text(
                _format(entry.createdAt),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          Row(
            children: [
              const Icon(
                Icons.update_rounded,
                color: AppColors.textHint,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.updatedAt,
                style: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Text(
                _format(entry.updatedAt),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
