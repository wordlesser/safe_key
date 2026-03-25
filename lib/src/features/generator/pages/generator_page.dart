import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../shared/constants/app_theme.dart';
import '../../../shared/utils/password_generator.dart';
import '../../../shared/widgets/app_snackbar.dart';

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key, this.isModal = false});

  final bool isModal;

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  int _length = 16;
  bool _uppercase = true;
  bool _lowercase = true;
  bool _digits = true;
  bool _symbols = false;
  String _generated = '';

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    setState(() {
      _generated = PasswordGenerator.generate(
        length: _length,
        includeLowercase: _lowercase,
        includeUppercase: _uppercase,
        includeDigits: _digits,
        includeSymbols: _symbols,
      );
    });
  }

  Widget _buildContent(AppLocalizations l10n) {
    final strength = PasswordGenerator.evaluateStrength(_generated);
    final strengthColor = _strengthColor(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              SelectableText(
                _generated,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: SizedBox(
                      width: 120,
                      child: LinearProgressIndicator(
                        value: strength,
                        backgroundColor: AppColors.border,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(strengthColor),
                        minHeight: 4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    PasswordGenerator.strengthLabel(strength, l10n),
                    style: TextStyle(
                      color: strengthColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              l10n.length,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              width: 40,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '$_length',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: _length.toDouble(),
          min: 8,
          max: 32,
          divisions: 24,
          onChanged: (v) {
            setState(() => _length = v.round());
            _generate();
          },
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        _buildToggleTile(
          label: l10n.uppercase,
          subtitle: 'A-Z',
          value: _uppercase,
          onChanged: (v) {
            setState(() => _uppercase = v);
            _generate();
          },
        ),
        _buildToggleTile(
          label: l10n.lowercase,
          subtitle: 'a-z',
          value: _lowercase,
          onChanged: (v) {
            setState(() => _lowercase = v);
            _generate();
          },
        ),
        _buildToggleTile(
          label: l10n.digits,
          subtitle: '0-9',
          value: _digits,
          onChanged: (v) {
            setState(() => _digits = v);
            _generate();
          },
        ),
        _buildToggleTile(
          label: l10n.specialChars,
          subtitle: r'!@#$%^&*',
          value: _symbols,
          onChanged: (v) {
            setState(() => _symbols = v);
            _generate();
          },
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _generate,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(l10n.regenerate),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: widget.isModal
                    ? () => Navigator.of(context).pop(_generated)
                    : _copyToClipboard,
                icon: Icon(
                  widget.isModal
                      ? Icons.check_rounded
                      : Icons.content_copy_rounded,
                  size: 18,
                ),
                label: Text(widget.isModal ? l10n.useThisPassword : l10n.copy),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _copyToClipboard() {
    final l10n = AppLocalizations.of(context);
    AppSnackbar.show(context, l10n.passwordCopied, isSuccess: true);
  }

  Widget _buildToggleTile({
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Color _strengthColor(double strength) {
    if (strength < 0.3) return AppColors.error;
    if (strength < 0.6) return AppColors.warning;
    if (strength < 0.8) return AppColors.secondary;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (widget.isModal) {
      return Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text(
                    l10n.passwordGenerator,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textHint,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: _buildContent(l10n),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.passwordGenerator)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _buildContent(l10n),
        ),
      ),
    );
  }
}
