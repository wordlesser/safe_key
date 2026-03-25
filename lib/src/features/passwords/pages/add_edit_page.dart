import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../shared/constants/app_theme.dart';
import '../../../shared/models/password_entry.dart';
import '../../../shared/utils/password_generator.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../auth/controller/auth_controller.dart';
import '../../generator/pages/generator_page.dart';
import '../controller/passwords_controller.dart';

class AddEditPage extends StatefulWidget {
  const AddEditPage({super.key, this.entry, this.initialCategory});

  final PasswordEntry? entry;
  final PasswordCategory? initialCategory;

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _passwordCtrl;
  late final TextEditingController _urlCtrl;
  late final TextEditingController _noteCtrl;
  late PasswordCategory _category;
  bool _obscurePassword = true;
  bool _loading = false;

  bool get _isEdit => widget.entry != null;

  @override
  void initState() {
    super.initState();
    final e = widget.entry;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _usernameCtrl = TextEditingController(text: e?.username ?? '');
    _passwordCtrl = TextEditingController(text: e?.password ?? '');
    _urlCtrl = TextEditingController(text: e?.url ?? '');
    _noteCtrl = TextEditingController(text: e?.note ?? '');
    _category = e?.category ?? widget.initialCategory ?? PasswordCategory.other;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _urlCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final l10n = AppLocalizations.of(context);
      final auth = context.read<AuthController>();
      final pwd = context.read<PasswordsController>();
      if (auth.masterKey == null) return;

      final now = DateTime.now();
      final entry = PasswordEntry(
        id: _isEdit ? widget.entry!.id : const Uuid().v4(),
        name: _nameCtrl.text.trim(),
        category: _category,
        username: _usernameCtrl.text.trim(),
        password: _passwordCtrl.text,
        url: _urlCtrl.text.trim(),
        note: _noteCtrl.text.trim(),
        createdAt: _isEdit ? widget.entry!.createdAt : now,
        updatedAt: now,
      );

      if (_isEdit) {
        await pwd.updateEntry(entry, auth.masterKey!);
      } else {
        await pwd.addEntry(entry, auth.masterKey!);
      }

      if (mounted) {
        Navigator.of(context).pop();
        AppSnackbar.show(
          context,
          _isEdit ? l10n.updatedEntry(entry.name) : l10n.savedEntry(entry.name),
          isSuccess: true,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(
          context,
          AppLocalizations.of(context).saveFailed,
          isError: true,
        );
        setState(() => _loading = false);
      }
    }
  }

  double get _strength =>
      PasswordGenerator.evaluateStrength(_passwordCtrl.text);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.editPassword : l10n.addPassword),
        actions: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: Text(
                l10n.save,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildField(
                  label: l10n.nameLabel,
                  controller: _nameCtrl,
                  hint: l10n.nameHint,
                  icon: Icons.label_outline_rounded,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l10n.nameRequired : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: l10n.usernameLabel,
                  controller: _usernameCtrl,
                  hint: l10n.usernameHint,
                  icon: Icons.person_outline_rounded,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l10n.usernameRequired : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                _buildPasswordField(l10n),
                const SizedBox(height: 16),
                _buildField(
                  label: l10n.urlLabel,
                  controller: _urlCtrl,
                  hint: 'https://example.com',
                  icon: Icons.link_rounded,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: l10n.noteLabel,
                  controller: _noteCtrl,
                  hint: l10n.noteHint,
                  icon: Icons.notes_rounded,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                ),
                const SizedBox(height: 20),
                _buildCategorySelector(l10n),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textHint, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.passwordLabel,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordCtrl,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontFamily: 'monospace',
          ),
          decoration: InputDecoration(
            hintText: l10n.passwordHint,
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.auto_fix_high_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  tooltip: l10n.generatorTooltip,
                  onPressed: _openGenerator,
                ),
              ],
            ),
          ),
          validator: (v) =>
              (v == null || v.isEmpty) ? l10n.passwordRequired : null,
        ),
        if (_passwordCtrl.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          _PasswordStrengthBar(strength: _strength),
        ],
      ],
    );
  }

  Future<void> _openGenerator() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const GeneratorPage(isModal: true),
    );
    if (result != null && mounted) {
      _passwordCtrl.text = result;
      setState(() => _obscurePassword = false);
    }
  }

  Widget _buildCategorySelector(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.categoryLabel,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: PasswordCategory.values.map((cat) {
            final isSelected = _category == cat;
            return GestureDetector(
              onTap: () => setState(() => _category = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? cat.color.withValues(alpha: 0.15)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? cat.color.withValues(alpha: 0.5)
                        : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cat.icon,
                      color: isSelected ? cat.color : AppColors.textHint,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cat.displayName(context),
                      style: TextStyle(
                        color: isSelected
                            ? cat.color
                            : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  const _PasswordStrengthBar({required this.strength});

  final double strength;

  Color get _color {
    if (strength < 0.3) return AppColors.error;
    if (strength < 0.6) return AppColors.warning;
    if (strength < 0.8) return AppColors.secondary;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: strength,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(_color),
              minHeight: 4,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          PasswordGenerator.strengthLabel(strength, l10n),
          style: TextStyle(
            color: _color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
