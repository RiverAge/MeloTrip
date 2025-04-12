part of '../home_page.dart';

class _TopSeachBar extends StatelessWidget {
  const _TopSeachBar();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const SearchPage()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 19),
            SizedBox(width: 5),
            Text('搜索专辑、艺术家、歌曲', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
