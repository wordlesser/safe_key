import 'package:flutter/material.dart';

import '../../../shared/constants/app_theme.dart';
import '../../../shared/models/password_entry.dart';

class PasswordListItem extends StatelessWidget {
  const PasswordListItem({
    super.key,
    required this.entry,
    required this.onTap,
    this.onLongPress,
  });

  final PasswordEntry entry;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final cat = entry.category;
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // 图标
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cat.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: cat.color.withValues(alpha: 0.2)),
              ),
              child: Center(
                child: Text(
                  _getInitial(entry.name),
                  style: TextStyle(
                    color: cat.color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // 名称 + 账号
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    entry.username,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // 分类标签
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: cat.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                cat.displayName(context),
                style: TextStyle(
                  color: cat.color,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  String _getInitial(String name) {
    if (name.isEmpty) return '?';
    // 如果是中文，取第一个字
    final first = name.characters.first;
    return first.toUpperCase();
  }
}
