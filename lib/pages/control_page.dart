import 'package:english_card_app/values/app_colors.dart';
import 'package:english_card_app/values/share_key.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../values/app_assets.dart';
import '../values/app_styles.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  double slideValue = 5;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    initDefaultValue();
    super.initState();
  }

  initDefaultValue() async {
    sharedPreferences = await SharedPreferences.getInstance();
    int len = sharedPreferences.getInt(ShareKey.counter) ?? 5;
    setState(() {
      slideValue = len.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ALICE_BLUE,
      appBar: AppBar(
        backgroundColor: AppColors.ALICE_BLUE,
        title: Text(
          'Your Control',
          style: AppStyles.h4.copyWith(
            color: AppColors.JET,
            fontSize: 36,
          ),
        ),
        leading: InkWell(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.setInt(ShareKey.counter, slideValue.toInt());
            Navigator.pop(context);
          },
          child: Image.asset(AppAssets.leftArrow),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'How much a number word at once',
                style: AppStyles.h5
                    .copyWith(color: AppColors.SILVER, fontSize: 18),
              ),
            ),
            const Spacer(),
            Text(
              '${slideValue.toInt()}',
              style: AppStyles.h1.copyWith(
                  color: AppColors.JORDY_BLUE,
                  fontSize: 150,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Slider(
                  value: slideValue,
                  min: 5,
                  max: 100,
                  divisions: 95,
                  activeColor: AppColors.JORDY_BLUE,
                  inactiveColor: AppColors.JORDY_BLUE,
                  onChanged: (value) {
                    setState(() {
                      slideValue = value;
                    });
                  }),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              alignment: Alignment.centerLeft,
              child: Text(
                'Slide to set',
                style: AppStyles.h5.copyWith(color: AppColors.JET),
              ),
            ),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
