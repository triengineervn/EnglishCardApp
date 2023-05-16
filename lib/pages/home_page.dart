import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_card_app/models/english_today.dart';
import 'package:english_card_app/pages/all_words_page.dart';
import 'package:english_card_app/pages/control_page.dart';
import 'package:english_card_app/values/app_assets.dart';
import 'package:english_card_app/values/app_colors.dart';
import 'package:english_card_app/values/app_styles.dart';
import 'package:english_card_app/values/share_key.dart';
import 'package:english_card_app/widgets/app_buttons.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../packages/quote/quote.dart';
import '../packages/quote/quote_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<EnglishToday> words = [];
  String quoteRandom = Quotes().getRandom().content!;

  List<int> fixedListRandom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];

    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int len = preferences.getInt(ShareKey.counter) ?? 5;
    List<String> newList = [];
    List<int> rans = fixedListRandom(len: len, max: nouns.length);
    rans.forEach((index) {
      newList.add(nouns[index]);
    });
    setState(() {
      words = newList.map((e) => getQuote(e)).toList();
    });
  }

  EnglishToday getQuote(String noun) {
    Quote? quote;
    quote = Quotes().getByWord(noun);
    return EnglishToday(
      noun: noun,
      quote: quote?.content,
      id: quote?.id,
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
    getEnglishToday();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Image.asset(AppAssets.menu),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: size.height * 1 / 10,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: Text(
                '"$quoteRandom"',
                style: AppStyles.h5.copyWith(
                  fontSize: 12,
                  color: AppColors.JET,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 2 / 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: words.length,
                itemBuilder: (context, index) {
                  String fisrtLetter =
                      words[index].noun != null ? words[index].noun! : '';
                  fisrtLetter = fisrtLetter.substring(0, 1).toUpperCase();
                  String leftLetter =
                      words[index].noun != null ? words[index].noun! : '';
                  leftLetter = leftLetter.substring(1, leftLetter.length);
                  String quoteDefault =
                      "Think of all the beauty still left around you and be happy";
                  String quote = words[index].quote != null
                      ? words[index].quote!
                      : quoteDefault;

                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.JORDY_BLUE,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(3, 6),
                            blurRadius: 6,
                          ),
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: Image.asset(AppAssets.heart),
                          ),
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: fisrtLetter,
                              style: TextStyle(
                                fontFamily: FontFamily.sen,
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                shadows: const [
                                  BoxShadow(
                                      color: AppColors.BLACK,
                                      offset: Offset(3, 6),
                                      blurRadius: 6),
                                ],
                              ),
                              children: [
                                TextSpan(
                                  text: leftLetter,
                                  style: TextStyle(
                                    fontFamily: FontFamily.sen,
                                    fontSize: 52,
                                    fontWeight: FontWeight.bold,
                                    shadows: const [
                                      BoxShadow(
                                          color: AppColors.BLACK,
                                          offset: Offset(3, 6),
                                          blurRadius: 6),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: AutoSizeText(
                              '"$quote"',
                              maxFontSize: 24,
                              style: AppStyles.h4.copyWith(
                                  letterSpacing: 1, color: AppColors.JET),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _currentIndex >= 5
                ? buildShowMore()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      height: size.height * 1 / 12,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return buildIndicator(index == _currentIndex, size);
                          },
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.JORDY_BLUE,
        onPressed: () {
          setState(() {
            getEnglishToday();
          });
        },
        child: Image.asset(AppAssets.exchange),
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.LAVENDER_WEB,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 16),
                child: Text(
                  'Your mind',
                  style: AppStyles.h3.copyWith(
                    color: AppColors.JET,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                  label: 'Favorites',
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                  label: 'Your Control',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ControlPage()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
        color: isActive ? AppColors.LAVENDER_WEB : AppColors.SILVER,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black38, offset: Offset(2, 3), blurRadius: 3),
        ],
      ),
      duration: const Duration(milliseconds: 200),
    );
  }

  Widget buildShowMore() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      alignment: Alignment.centerLeft,
      child: Material(
        color: AppColors.JORDY_BLUE,
        elevation: 4,
        borderRadius: const BorderRadius.all(
          Radius.circular(24),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AllWordPage(words: words)),
            );
          },
          splashColor: Colors.black38,
          borderRadius: const BorderRadius.all(
            Radius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              'Show more',
              style: AppStyles.h5,
            ),
          ),
        ),
      ),
    );
  }
}
