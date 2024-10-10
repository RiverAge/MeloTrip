part of "../search_page.dart";

class _Searchbar extends StatefulWidget {
  const _Searchbar(
      {required this.onSubmitted,
      required this.controller,
      required this.onFocusChange});
  final void Function(String) onSubmitted;
  final void Function(bool hasFocus) onFocusChange;
  final TextEditingController controller;

  @override
  State<StatefulWidget> createState() => _SearchbarState();
}

class _SearchbarState extends State<_Searchbar> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(_onFocusChange);
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();

    super.dispose();
  }

  _onFocusChange() {
    widget.onFocusChange(_focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
              width: 1, color: Theme.of(context).colorScheme.primary)),
      child: TextField(
          controller: widget.controller,
          onSubmitted: (val) {
            _focusNode.unfocus();
            widget.onSubmitted(val);
          },
          focusNode: _focusNode,
          cursorHeight: 17,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
              isDense: true,
              icon: Icon(Icons.search),
              hintText: '搜索专辑、艺术家、歌曲',
              border: InputBorder.none)),
    );
  }
  // @override
  // Widget build(BuildContext context) => Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
  //       decoration: BoxDecoration(
  //           border: Border.all(
  //               width: 1, color: Theme.of(context).colorScheme.primary),
  //           borderRadius: BorderRadius.circular(8)),
  //       child: Row(children: [
  //         const Icon(Icons.search, size: 20),
  //         const SizedBox(width: 5),
  //         Expanded(
  //             child: TextField(
  //                 onSubmitted: onSubmitted,
  //                 autofocus: true,
  //                 textAlignVertical: TextAlignVertical.center,
  //                 textInputAction: TextInputAction.search,
  //                 decoration: const InputDecoration(
  //                     isDense: true,
  //                     contentPadding: EdgeInsets.zero,
  //                     hintText: '搜索专辑、艺术家、歌曲',
  //                     hintStyle: TextStyle(fontSize: 12),
  //                     border: InputBorder.none)))
  //       ]),
  //     );
}
