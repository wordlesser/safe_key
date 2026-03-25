import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../shared/constants/app_theme.dart';
import '../../../shared/models/password_entry.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../auth/controller/auth_controller.dart';
import '../../settings/pages/settings_page.dart';
import '../controller/passwords_controller.dart';
import '../widgets/password_list_item.dart';
import 'add_edit_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final auth = context.read<AuthController>();
    final pwd = context.read<PasswordsController>();
    if (auth.masterKey != null) {
      await pwd.loadEntries(auth.masterKey!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: _buildAppBar(l10n),
      body: Column(
        children: [
          if (_showSearch) _buildSearchBar(l10n),
          _buildCategoryTabs(l10n),
          const Divider(height: 1),
          Expanded(child: _buildList(l10n)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAdd(context),
        tooltip: l10n.addPasswordTooltip,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      title: const Text('SafeKey'),
      leading: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Icon(Icons.key_rounded, color: AppColors.primary, size: 24),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _showSearch ? Icons.search_off_rounded : Icons.search_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () {
            setState(() {
              _showSearch = !_showSearch;
              if (!_showSearch) {
                _searchController.clear();
                context.read<PasswordsController>().setSearchQuery('');
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.settings_outlined,
            color: AppColors.textPrimary,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: l10n.searchHint,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textHint,
            size: 20,
          ),
        ),
        onChanged: (v) =>
            context.read<PasswordsController>().setSearchQuery(v),
      ),
    );
  }

  Widget _buildCategoryTabs(AppLocalizations l10n) {
    return Consumer<PasswordsController>(
      builder: (context, pwd, _) {
        final categories = [null, ...PasswordCategory.values];
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = pwd.selectedCategory == cat;
              final label = cat?.displayName(context) ?? l10n.allCategories;
              final color = cat?.color ?? AppColors.primary;

              return GestureDetector(
                onTap: () => pwd.setCategory(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? color.withValues(alpha: 0.5)
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? color : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildList(AppLocalizations l10n) {
    return Consumer<PasswordsController>(
      builder: (context, pwd, _) {
        if (pwd.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final entries = pwd.filteredEntries;

        if (entries.isEmpty) {
          return _EmptyState(
            isSearch: pwd.searchQuery.isNotEmpty,
            onAdd: () => _navigateToAdd(context),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return PasswordListItem(
                entry: entry,
                onTap: () => _navigateToDetail(context, entry),
                onLongPress: () => _showQuickActions(context, entry),
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToAdd(BuildContext context) {
    final selected = context.read<PasswordsController>().selectedCategory;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddEditPage(initialCategory: selected),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, PasswordEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailPage(entry: entry)),
    );
  }

  void _showQuickActions(BuildContext context, PasswordEntry entry) {
    final l10n = AppLocalizations.of(context);
    final auth = context.read<AuthController>();
    final pwd = context.read<PasswordsController>();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceVariant,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.content_copy_rounded,
                color: AppColors.textPrimary,
              ),
              title: Text(
                l10n.copyUsername,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(ctx);
                pwd.copyToClipboard(
                  entry.username,
                  label: l10n.copiedLabel(l10n.usernameFieldLabel),
                  onCopied: (msg) =>
                      AppSnackbar.show(context, msg, isSuccess: true),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.key_rounded,
                color: AppColors.primary,
              ),
              title: Text(
                l10n.copyPassword,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(ctx);
                pwd.copyToClipboard(
                  entry.password,
                  label: l10n.copiedLabel(l10n.passwordFieldLabel),
                  onCopied: (msg) =>
                      AppSnackbar.show(context, msg, isSuccess: true),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.edit_outlined,
                color: AppColors.textPrimary,
              ),
              title: Text(
                l10n.edit,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddEditPage(entry: entry),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error),
              title: Text(
                l10n.delete,
                style: const TextStyle(color: AppColors.error),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, entry, pwd, auth);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    PasswordEntry entry,
    PasswordsController pwd,
    AuthController auth,
  ) {
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
          l10n.deleteConfirmContent(entry.name),
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
              pwd.deleteEntry(entry.id);
              AppSnackbar.show(context, l10n.deletedEntry(entry.name));
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
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isSearch, required this.onAdd});

  final bool isSearch;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearch
                  ? Icons.search_off_rounded
                  : Icons.lock_open_rounded,
              color: AppColors.textHint,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              isSearch ? l10n.noMatchingPasswords : l10n.noPasswordsYet,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearch ? l10n.tryOtherKeywords : l10n.tapPlusToAdd,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            if (!isSearch) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(l10n.addPassword),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(160, 44),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
