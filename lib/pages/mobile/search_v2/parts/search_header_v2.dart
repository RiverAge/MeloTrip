part of '../search_page_v2.dart';

class _SearchHeaderV2 extends StatefulWidget {
  const _SearchHeaderV2({
    required this.onSubmitted,
    required this.controller,
    required this.focusNode,
    required this.onReFocused,
    this.onChanged,
  });

  final void Function(String) onSubmitted;
  final void Function(String)? onChanged;
  final void Function() onReFocused;
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  State<_SearchHeaderV2> createState() => _SearchHeaderV2State();
}

class _SearchHeaderV2State extends State<_SearchHeaderV2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        onSubmitted: (val) {
          widget.focusNode.unfocus();
          widget.onSubmitted(val);
        },
        textAlignVertical: TextAlignVertical.center,
        textInputAction: .search,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: AppLocalizations.of(context)!.searchHint,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withValues(alpha: .5),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          suffixIcon: ValueListenableBuilder(
            valueListenable: widget.controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                onPressed: () {
                  widget.controller.clear();
                  widget.onChanged?.call('');
                },
                icon: const Icon(Icons.close, size: 18),
              );
            },
          ),
          border: .none,
          enabledBorder: .none,
          focusedBorder: .none,
        ),
      ),
    );
  }
}
