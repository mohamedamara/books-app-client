import 'package:books_app_client/core/extensions/context_extension.dart';
import 'package:books_app_client/core/themes/custom_colors.dart';
import 'package:books_app_client/features/book_details/presentation/views/book_details_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/models/book/book.dart';
import '../../../../../core/navigation/navigation_paths.dart';

class CarouselItem extends StatelessWidget {
  const CarouselItem({
    super.key,
    required this.book,
    required this.isActiveItem,
  });

  final Book book;
  final bool isActiveItem;

  @override
  Widget build(BuildContext context) {
    String bookAnimationHeroTag = 'carousel${book.id}';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              NavigationPaths.bookDetailsRoute,
              arguments: BookDetailsArguments(
                book: book,
                bookAnimationHeroTag: bookAnimationHeroTag,
              ),
            ),
            child: Hero(
              tag: bookAnimationHeroTag,
              child: SizedBox(
                height: context.setHeight(200),
                width: context.setHeight(127),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(context.setRadius(10)),
                    child: CachedNetworkImage(
                      imageUrl: book.coverImageURL,
                      fit: BoxFit.fitHeight,
                      placeholder: (_, __) => const SizedBox(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: context.setHeight(28)),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: isActiveItem
              ? Theme.of(context).textTheme.bodyMedium ?? const TextStyle()
              : Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CustomColors.textColorAlmostBlack.withOpacity(
                          0.5,
                        ),
                      ) ??
                  const TextStyle(),
          child: Text(book.title, textAlign: TextAlign.center),
        ),
        SizedBox(height: context.setHeight(5)),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: isActiveItem
              ? Theme.of(context).textTheme.bodySmall ?? const TextStyle()
              : Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CustomColors.textColorAlmostBlack.withOpacity(
                          0.25,
                        ),
                      ) ??
                  const TextStyle(),
          child: Text(book.author, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
