import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';

class AiConfigPage extends ConsumerStatefulWidget {
  const AiConfigPage({super.key});

  @override
  ConsumerState<AiConfigPage> createState() => _AiConfigPageState();
}

class _AiConfigPageState extends ConsumerState<AiConfigPage> {
  // 控制器
  late final TextEditingController _urlController;
  late final TextEditingController _keyController;

  // 状态变量
  bool _isKeyObscured = true; // 是否隐藏 Key
  bool _isTesting = false; // 是否正在测试连接

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    _keyController = TextEditingController();
    _setText();
  }

  void _setText() async {
    final uc = await ref.read(userConfigProvider.future);

    _urlController.text = uc?.aiApiUrl ?? '';
    _keyController.text = uc?.aiApiKey ?? '';
  }

  @override
  void dispose() {
    _urlController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  void _onSave() {
    final l10n = AppLocalizations.of(context)!;
    final url = _urlController.text.trim();
    final key = _keyController.text.trim();

    ref
        .read(userConfigProvider.notifier)
        .setConfiguration(
          aiApiKey: ValueUpdater(key),
          aiApiUrl: ValueUpdater(url),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.aiConfigSaved),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  Future<void> _testConnection() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isTesting = true);
    var isSuccess = false;

    try {
      final res = await Dio().get(
        '${_urlController.text}/models',
        options: Options(
          headers: {
            if (_keyController.text != '')
              'Authorization': 'Bearer ${_keyController.text}',
            'Content-Type': 'application/json',
          },
        ),
      );
      isSuccess = res.statusCode == 200;
    } catch (e) {
      log(e.toString(), error: e);
      isSuccess = false;
    } finally {
      if (mounted) {
        setState(() => _isTesting = false);
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              SizedBox(width: 8),
              Text(
                isSuccess ? l10n.aiConnectionSuccess : l10n.aiConnectionFailed,
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aiConfig)),
      // 底部保存按钮，固定在底部方便点击
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16 + 10), // 适配底部安全区
        child: FilledButton.icon(
          onPressed: _onSave,
          icon: const Icon(Icons.save_rounded),
          label: Text(l10n.aiSaveConfig),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 提示卡片
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.aiConfigTip,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 表单区域（模仿你截图中的卡片风格）
            Material(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ), // 浅色背景
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. API URL 输入框
                    _buildSectionTitle(context, l10n.aiEndpointLabel),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        hintText: l10n.aiApiUrlHint,
                        prefixIcon: const Icon(Icons.link_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      keyboardType: TextInputType.url,
                    ),

                    const SizedBox(height: 24),

                    // 2. API Key 输入框
                    _buildSectionTitle(context, l10n.aiApiKeyLabel),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _keyController,
                      obscureText: _isKeyObscured, // 密码模式
                      decoration: InputDecoration(
                        hintText: l10n.aiApiKeyHint,
                        prefixIcon: const Icon(Icons.vpn_key_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isKeyObscured
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                          ),
                          onPressed: () {
                            setState(() {
                              _isKeyObscured = !_isKeyObscured;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 3. 测试连接按钮
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isTesting ? null : _testConnection,
                        icon: _isTesting
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.network_check_rounded),
                        label: Text(
                          _isTesting
                              ? l10n.aiTestingConnection
                              : l10n.aiTestConnection,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 辅助方法：构建小标题
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
