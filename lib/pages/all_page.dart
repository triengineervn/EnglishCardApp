import 'package:english_card_app/models/english_today.dart';
import 'package:flutter/material.dart';

import '../values/app_assets.dart';
import '../values/app_colors.dart';
import '../values/app_styles.dart';

class AllPage extends StatelessWidget {
  final List<EnglishToday> words;
  const AllPage({super.key, required this.words});

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
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: (index % 2) == 0
                    ? AppColors.JORDY_BLUE
                    : AppColors.ALICE_BLUE,
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                words[index].noun!,
                style: AppStyles.h4.copyWith(
                    color: AppColors.JET, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(words[index].quote ??
                  'Think of all the beauty still left around you and be happy'),
              leading: Icon(
                Icons.favorite,
                color: words[index].isFavorite ? Colors.red : Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}
