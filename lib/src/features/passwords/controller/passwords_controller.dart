import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../../core/storage/database_service.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/models/password_entry.dart';

class PasswordsController extends ChangeNotifier {
  List<PasswordEntry> _entries = [];
  String _searchQuery = '';
  PasswordCategory? _selectedCategory; // null = 全部
  bool _loading = false;
  Timer? _clipboardTimer;
  int _clipboardClearSeconds = AppConstants.defaultClipboardClearSeconds;

  List<PasswordEntry> get entries => _entries;
  bool get loading => _loading;
  int get clipboardClearSeconds => _clipboardClearSeconds;

  List<PasswordEntry> get filteredEntries {
    var list = _entries;

    if (_selectedCategory != null) {
      list = list.where((e) => e.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((e) {
        return e.name.toLowerCase().contains(q) ||
            e.username.toLowerCase().contains(q) ||
            e.url.toLowerCase().contains(q) ||
            e.note.toLowerCase().contains(q);
      }).toList();
    }

    return list;
  }

  PasswordCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // ── 加载 ───────────────────────────────────────────────────────

  Future<void> loadEntries(Uint8List keyBytes) async {
    _loading = true;
    notifyListeners();
    try {
      _entries = await DatabaseService.instance.getAll(keyBytes);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── CRUD ────────────────────────────────────────────────────────

  Future<void> addEntry(PasswordEntry entry, Uint8List keyBytes) async {
    await DatabaseService.instance.insert(entry, keyBytes);
    _entries.insert(0, entry);
    notifyListeners();
  }

  Future<void> updateEntry(PasswordEntry entry, Uint8List keyBytes) async {
    await DatabaseService.instance.update(entry, keyBytes);
    final idx = _entries.indexWhere((e) => e.id == entry.id);
    if (idx != -1) {
      _entries[idx] = entry;
      notifyListeners();
    }
  }

  Future<void> deleteEntry(String id) async {
    await DatabaseService.instance.delete(id);
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ── 搜索 / 筛选 ────────────────────────────────────────────────

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(PasswordCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // ── 剪贴板 ─────────────────────────────────────────────────────

  void setClipboardClearSeconds(int seconds) {
    _clipboardClearSeconds = seconds;
  }

  Future<void> copyToClipboard(
    String text, {
    String label = '',
    void Function(String)? onCopied,
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (onCopied != null) {
      onCopied(label);
    }

    _clipboardTimer?.cancel();
    if (_clipboardClearSeconds > 0) {
      _clipboardTimer = Timer(
        Duration(seconds: _clipboardClearSeconds),
        () => Clipboard.setData(const ClipboardData(text: '')),
      );
    }
  }

  // ── 备份 / 恢复 ────────────────────────────────────────────────

  Future<String> exportBackup(Uint8List keyBytes) async {
    return DatabaseService.instance.exportEncrypted(keyBytes);
  }

  Future<int> importBackup(
    String encryptedBackup,
    Uint8List keyBytes, {
    bool replaceAll = false,
  }) async {
    final count = await DatabaseService.instance.importEncrypted(
      encryptedBackup,
      keyBytes,
      replaceAll: replaceAll,
    );
    await loadEntries(keyBytes);
    return count;
  }

  // ── 测试数据 ────────────────────────────────────────────────────

  Future<void> seedTestData(Uint8List keyBytes) async {
    const uuid = Uuid();
    final now = DateTime.now();

    final entries = [
      // 社交
      PasswordEntry(id: uuid.v4(), name: '微信', category: PasswordCategory.social, username: 'wechat_user', password: 'Wx@123456', url: 'weixin.qq.com', note: '主账号', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: '微博', category: PasswordCategory.social, username: 'weibo_demo', password: 'Wb!654321', url: 'weibo.com', note: '', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: 'Instagram', category: PasswordCategory.social, username: 'insta_demo@gmail.com', password: 'Insta#2024', url: 'instagram.com', note: '备用邮箱登录', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: 'Twitter / X', category: PasswordCategory.social, username: '@demo_user', password: 'Tw1tter!88', url: 'x.com', note: '', createdAt: now, updatedAt: now),

      // 金融
      PasswordEntry(id: uuid.v4(), name: '招商银行', category: PasswordCategory.finance, username: '6225880012345678', password: 'Cmb@2024Pwd', url: 'cmbchina.com', note: '储蓄卡', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: '支付宝', category: PasswordCategory.finance, username: 'alipay@example.com', password: 'Ali#Pay999', url: 'alipay.com', note: '绑定手机：138****1234', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: '工商银行', category: PasswordCategory.finance, username: '6222021234567890', password: 'ICBC@8888', url: 'icbc.com.cn', note: '信用卡账单邮件', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: '富途证券', category: PasswordCategory.finance, username: 'futu_demo', password: 'F0tuSec#2024', url: 'futu.com', note: '港股账户', createdAt: now, updatedAt: now),

      // 购物
      PasswordEntry(id: uuid.v4(), name: '淘宝', category: PasswordCategory.shopping, username: 'taobao_buyer', password: 'Tb@Buy2024', url: 'taobao.com', note: '', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: '京东', category: PasswordCategory.shopping, username: 'jd_shopper@qq.com', password: 'JD!Shop888', url: 'jd.com', note: 'Plus 会员', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: 'Amazon', category: PasswordCategory.shopping, username: 'amazon_demo@gmail.com', password: 'Amz#Prime24', url: 'amazon.com', note: 'Prime 订阅', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: '拼多多', category: PasswordCategory.shopping, username: '138****5678', password: 'Pdd@2024!!', url: 'pinduoduo.com', note: '', createdAt: now, updatedAt: now),

      // 游戏
      PasswordEntry(id: uuid.v4(), name: '王者荣耀', category: PasswordCategory.game, username: 'honor_king_demo', password: 'Hk@King999', url: 'pvp.qq.com', note: '腾讯游戏账号', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: 'Steam', category: PasswordCategory.game, username: 'steam_demo', password: 'St3am#2024', url: 'store.steampowered.com', note: '已开启双重验证', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: 'PlayStation', category: PasswordCategory.game, username: 'psn_demo@outlook.com', password: 'PSN@Play88', url: 'playstation.com', note: 'PS Plus Essential', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: '原神', category: PasswordCategory.game, username: 'genshin_uid_123456', password: 'Gsh!2024Pw', url: 'genshin.hoyoverse.com', note: '米哈游通行证', createdAt: now, updatedAt: now),

      // 其他
      PasswordEntry(id: uuid.v4(), name: 'GitHub', category: PasswordCategory.other, username: 'github_dev', password: 'Git#Hub2024', url: 'github.com', note: '已开启 2FA', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: 'Gmail', category: PasswordCategory.other, username: 'demo.user@gmail.com', password: 'Gm@il#Secure', url: 'mail.google.com', note: '工作邮箱', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: 'iCloud', category: PasswordCategory.other, username: 'apple_id@icloud.com', password: 'iCl0ud!Safe', url: 'icloud.com', note: 'Apple ID 主账号', createdAt: now, updatedAt: now),
      PasswordEntry(id: uuid.v4(), name: 'ChatGPT', category: PasswordCategory.other, username: 'openai_demo@gmail.com', password: 'Gpt4#Plus24', url: 'chat.openai.com', note: 'Plus 订阅', createdAt: now, updatedAt: now),
    ];

    for (final entry in entries) {
      await DatabaseService.instance.insert(entry, keyBytes);
    }
    await loadEntries(keyBytes);
  }

  // ── 重加密（修改主密码时） ──────────────────────────────────────

  Future<void> reEncryptAll(
    Uint8List oldKey,
    Uint8List newKey,
  ) async {
    final db = DatabaseService.instance;
    final oldEntries = await db.getAll(oldKey);
    for (final entry in oldEntries) {
      await db.update(entry, newKey);
    }
    _entries = await db.getAll(newKey);
    notifyListeners();
  }

  @override
  void dispose() {
    _clipboardTimer?.cancel();
    super.dispose();
  }
}
