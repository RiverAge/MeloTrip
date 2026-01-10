import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/ai_chat/chat_message.dart';
import 'package:melo_trip/pages/ai_chat/widgets/typing_indicator.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isReasoningExpanded = false;

  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    final isUser = widget.message.role == MessageRole.user;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final isLoading =
        message.isStreaming &&
        message.content.isEmpty &&
        (message.reasoningContent == null || message.reasoningContent == '');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: isLoading
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(context, widget.message),
          const SizedBox(width: 12),
          isLoading
              ? TypingIndicator()
              : Flexible(
                  child: Column(
                    crossAxisAlignment: isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      _buildTimeTag(context, widget.message.timestamp),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onLongPress: () => _showMessageOptions(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser
                                ? colorScheme.primaryContainer
                                : colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                            border: !isUser
                                ? Border.all(
                                    color: colorScheme.outlineVariant
                                        .withValues(alpha: 0.3),
                                  )
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.message.reasoningContent != null &&
                                  widget.message.reasoningContent!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _buildReasoningBox(context),
                                ),
                              if (isUser)
                                Text(
                                  widget.message.content,
                                  style: TextStyle(
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                )
                              else
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MarkdownBody(
                                      data: widget.message.content,
                                      selectable: true,
                                      styleSheet: MarkdownStyleSheet(
                                        p: TextStyle(
                                          color: colorScheme.onSurface,
                                          fontSize: 15,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    if (message.error != null)
                                      Text(
                                        message.error ==
                                                'ERR_CANCELLED_BY_USER_STOP'
                                            ? l10n.cancelledByUser
                                            : message.error ==
                                                  'ERR_CANCELLED_BY_NEW_REQ'
                                            ? l10n.resetByNewRequest
                                            : message.error ?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.error,
                                        ),
                                      ),
                                    if (!isUser &&
                                        message.totalDuration != null)
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Text(
                                            l10n.timeConsumed(
                                              message.totalDuration?.inSeconds
                                                      .toString() ??
                                                  '',
                                            ),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: colorScheme.onSurface
                                                  .withAlpha(100),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          const SizedBox(width: 12),
          if (isUser) _buildAvatar(context, widget.message),
          // TypingIndicator(),
        ],
      ),
    );
  }

  Widget _buildReasoningBox(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final duration = widget.message.reasoningDuration;
    final seconds = duration != null
        ? (duration.inMilliseconds / 1000.0).toStringAsFixed(1)
        : null;

    final isThinking =
        widget.message.content.isEmpty && widget.message.error == null;
    // 只有当还在思考且没正文时才显示“思考中”，否则显示“已思考”
    final statusText = isThinking ? l10n.thinking : l10n.thoughtProcess;

    return InkWell(
      onTap: () => setState(() => _isReasoningExpanded = !_isReasoningExpanded),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 20,
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '$statusText${seconds != null ? l10n.timeUsed(seconds) : ''}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                Icon(
                  _isReasoningExpanded
                      ? Icons.expand_less
                      : Icons.chevron_right,
                  size: 20,
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ],
            ),
            if (_isReasoningExpanded) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              MarkdownBody(
                data: widget.message.reasoningContent!,
                styleSheet: MarkdownStyleSheet(
                  p: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    height: 1.6,
                  ),
                ),
              ),
            ] else if (widget.message.reasoningContent!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                widget.message.reasoningContent?.trim() ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, ChatMessage msg) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUser = widget.message.role == MessageRole.user;
    final iconThemeStr = isDark ? 'dark' : 'light';
    final logURI = msg.model != null
        ? getLogoUriOfProvider(
            (msg.model?.split('/')[0] ?? ''),
            iconThemeStr: iconThemeStr,
          )
        : null;
    return CircleAvatar(
      radius: 16,
      backgroundColor: isUser
          ? colorScheme.primary
          : colorScheme.secondaryContainer,
      child: isUser
          ? Icon(Icons.person, size: 18, color: colorScheme.onPrimary)
          : logURI != null
          ? Image.network(
              logURI,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                Icons.dns_outlined,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            )
          : Icon(
              Icons.smart_toy,
              size: 18,
              color: colorScheme.onSecondaryContainer,
            ),
    );
  }

  Widget _buildTimeTag(BuildContext context, DateTime time) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isUser = widget.message.role == MessageRole.user;

    return Text(
      _formatTime(context, time),
      style: theme.textTheme.bodySmall?.copyWith(
        color: isUser
            ? colorScheme.onPrimaryContainer.withValues(alpha: 0.7)
            : colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }

  void _showMessageOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: Text(l10n.copy),
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.message.content));
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.copiedToClipboard)));
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(BuildContext context, DateTime time) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return l10n.justNow;
    } else if (difference.inHours < 1) {
      return l10n.minutesAgo(difference.inMinutes);
    } else if (difference.inDays < 1) {
      return l10n.hoursAgo(difference.inHours);
    } else {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
