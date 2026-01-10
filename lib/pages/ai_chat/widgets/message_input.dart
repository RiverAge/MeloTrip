import 'package:flutter/material.dart';
import 'package:melo_trip/l10n/app_localizations.dart';

class MessageInput extends StatefulWidget {
  final void Function(String) onSend;
  final void Function() onStop;
  final bool isLoading;

  const MessageInput({
    super.key,
    required this.onSend,
    required this.onStop,
    this.isLoading = false,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  void _onSend() {
    if (_hasText && !widget.isLoading) {
      widget.onSend(_controller.text);
      _controller.clear();
    } else if (widget.isLoading) {
      widget.onStop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  enabled: !widget.isLoading,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.typeMessage,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _onSend(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: _hasText && !widget.isLoading
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: widget.isLoading
                    ? Icon(Icons.stop)
                    : Icon(
                        Icons.send,
                        color: _hasText
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                onPressed: _onSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
