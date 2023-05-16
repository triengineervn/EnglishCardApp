import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_card_app/models/english_today.dart';
import 'package:flutter/material.dart';

import '../values/app_assets.dart';
import '../values/app_colors.dart';
import '../values/app_styles.dart';

class AllWordPage extends StatelessWidget {
  final List<EnglishToday> words;
  const AllWordPage({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ALICE_BLUE,
      appBar: AppBar(
        backgroundColor: AppColors.ALICE_BLUE,
        title: Text(
          'English Today',
          style: AppStyles.h4.copyWith(
            color: AppColors.JET,
            fontSize: 36,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(AppAssets.leftArrow),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: words
              .map((e) => Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.JORDY_BLUE,
                      borderRadius: BorderRadius.all(
                        Radius.circular(24),
                      ),
                    ),
                    child: AutoSizeText(
                      e.noun ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: AppStyles.h3.copyWith(
                        shadows: [
                          const BoxShadow(
                            color: Colors.black26,
                            offset: Offset(2, 3),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
