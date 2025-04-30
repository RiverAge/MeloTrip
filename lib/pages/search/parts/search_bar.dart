part of "../search_page.dart";

class _Searchbar extends StatefulWidget {
  const _Searchbar({
    required this.onSubmitted,
    required this.controller,
    required this.focusNode,
    required this.onReFocused,
  });
  final void Function(String) onSubmitted;
  final void Function() onReFocused;
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  State<StatefulWidget> createState() => _SearchbarState();
}

class _SearchbarState extends State<_Searchbar> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 19),
          SizedBox(width: 5),
          Expanded(
            child: TextField(
              controller: widget.controller,
              style: TextStyle(fontSize: 13),
              onSubmitted: (val) {
                widget.focusNode.unfocus();
                widget.onSubmitted(val);
              },
              focusNode: widget.focusNode,
              cursorHeight: 17,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isDense: true,
                // icon: Icon(Icons.search),
                hintText: AppLocalizations.of(context)!.searchHint,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            constraints: BoxConstraints(),
            padding: EdgeInsets.zero,
            style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            onPressed: () {
              widget.controller.text = '';
              widget.focusNode.requestFocus();
              widget.onReFocused();
            },
            icon: Icon(Icons.clear, size: 19),
          ),
        ],
      ),
    );
  }
}
