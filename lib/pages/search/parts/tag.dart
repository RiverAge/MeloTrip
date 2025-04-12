part of '../search_page.dart';

class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(right: 5),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        decoration: BoxDecoration(
          border: Border.all(
              width: 0.5, color: Theme.of(context).colorScheme.secondary),
          borderRadius: const BorderRadius.all(Radius.circular(3)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 10, height: 1),
        ),
      );
}
