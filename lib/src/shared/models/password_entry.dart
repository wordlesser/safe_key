import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../constants/app_theme.dart';

enum PasswordCategory {
  social,
  finance,
  shopping,
  game,
  other,
}

extension PasswordCategoryX on PasswordCategory {
  String displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case PasswordCategory.social:
        return l10n.categorySocial;
      case PasswordCategory.finance:
        return l10n.categoryFinance;
      case PasswordCategory.shopping:
        return l10n.categoryShopping;
      case PasswordCategory.game:
        return l10n.categoryGame;
      case PasswordCategory.other:
        return l10n.categoryOther;
    }
  }

  IconData get icon {
    switch (this) {
      case PasswordCategory.social:
        return Icons.people_rounded;
      case PasswordCategory.finance:
        return Icons.account_balance_rounded;
      case PasswordCategory.shopping:
        return Icons.shopping_bag_rounded;
      case PasswordCategory.game:
        return Icons.sports_esports_rounded;
      case PasswordCategory.other:
        return Icons.folder_rounded;
    }
  }

  Color get color {
    switch (this) {
      case PasswordCategory.social:
        return AppColors.categorySocial;
      case PasswordCategory.finance:
        return AppColors.categoryFinance;
      case PasswordCategory.shopping:
        return AppColors.categoryShopping;
      case PasswordCategory.game:
        return AppColors.categoryGame;
      case PasswordCategory.other:
        return AppColors.categoryOther;
    }
  }

  static PasswordCategory fromString(String value) {
    return PasswordCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PasswordCategory.other,
    );
  }
}

class PasswordEntry {
  final String id;
  final String name;
  final PasswordCategory category;
  final String username;
  final String password;
  final String url;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PasswordEntry({
    required this.id,
    required this.name,
    required this.category,
    required this.username,
    required this.password,
    this.url = '',
    this.note = '',
    required this.createdAt,
    required this.updatedAt,
  });

  PasswordEntry copyWith({
    String? id,
    String? name,
    PasswordCategory? category,
    String? username,
    String? password,
    String? url,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PasswordEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      username: username ?? this.username,
      password: password ?? this.password,
      url: url ?? this.url,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toDbMap({required String encryptedPassword}) {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'username': username,
      'password': encryptedPassword,
      'url': url,
      'note': note,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  static PasswordEntry fromDbMap(
    Map<String, dynamic> map, {
    required String decryptedPassword,
  }) {
    return PasswordEntry(
      id: map['id'] as String,
      name: map['name'] as String,
      category: PasswordCategoryX.fromString(map['category'] as String),
      username: map['username'] as String,
      password: decryptedPassword,
      url: (map['url'] as String?) ?? '',
      note: (map['note'] as String?) ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  /// 用于备份的完整 map（密码字段保持加密状态）
  Map<String, dynamic> toBackupMap({required String encryptedPassword}) {
    return toDbMap(encryptedPassword: encryptedPassword);
  }
}
