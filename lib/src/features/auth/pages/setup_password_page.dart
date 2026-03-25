import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../shared/constants/app_theme.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../controller/auth_controller.dart';

class SetupPasswordPage extends StatefulWidget {
  const SetupPasswordPage({super.key});

  @override
  State<SetupPasswordPage> createState() => _SetupPasswordPageState();
}

class _SetupPasswordPageState extends State<SetupPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _pwdController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading = false;

  @override
  void dispose() {
    _pwdController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context
          .read<AuthController>()
          .setupMasterPassword(_pwdController.text.trim());
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(
          context,
          AppLocalizations.of(context).setupFailed,
          isError: true,
        );
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setupMasterPasswordTitle),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.read<AuthController>().backToWelcome(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.masterPasswordIsYourOnly,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.masterPasswordWarning,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.masterPassword,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pwdController,
                  obscureText: _obscure1,
                  autofocus: true,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.atLeast6CharsHint,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure1
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscure1 = !_obscure1),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return l10n.enterMasterPasswordError;
                    if (v.length < 6) return l10n.masterPasswordTooShortError;
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.confirmMasterPassword,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscure2,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.reEnterMasterPasswordHint,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure2
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscure2 = !_obscure2),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return l10n.confirmMasterPasswordError;
                    if (v != _pwdController.text) return l10n.passwordMismatchError;
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.completeSetup),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
