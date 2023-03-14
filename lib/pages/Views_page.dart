import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/pages/audio_player_page.dart';
import 'package:sheet_demo/pages/gridPage.dart';
import 'package:sheet_demo/pages/listPage.dart';
import 'package:sheet_demo/utils/size_utils.dart';

int current = 0;
List<CardClass> gridList = [
  CardClass(label: 'Android', cardColor: Color(0xff421e38)),
  CardClass(label: 'Flutter', cardColor: Color(0xff7c476d)),
  CardClass(label: 'Ios', cardColor: Color(0xff825a76)),
  CardClass(label: 'Python', cardColor: Color(0xff824a72)),
  CardClass(label: 'React Native', cardColor: Color(0xffa25d8f)),
  CardClass(label: 'Graphics', cardColor: Color(0xffb57da5)),
  CardClass(label: 'UI/Ux', cardColor: Color(0xffc79ebc)),
  CardClass(label: 'Nod Js', cardColor: Color(0xffdabed2)),
  CardClass(label: 'Web Design', cardColor: Color(0xffefdcea)),
];

List<SliderClass> sliderList = [
  SliderClass(image: 'assets/images/slider1.jpeg'),
  SliderClass(image: 'assets/images/slider5.png'),
  SliderClass(image: 'assets/images/slider4.jpeg'),
  SliderClass(image: 'assets/images/slider2.jpeg'),
  SliderClass(image: 'assets/images/slider3.jpeg'),
];

class ViewsPage extends StatefulWidget {
  @override
  ViewsPageState createState() => ViewsPageState();
}

class ViewsPageState extends State<ViewsPage> {
  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
        ),
        label: 'Red',
      ),
      BottomNavigationBarItem(icon:  Icon(Icons.search), label: 'Blue'),
      BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Yellow')
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Red(),
        Blue(),
        Yellow(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    audioPlayer.stop();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  double currentPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    print('Current page --> $runtimeType');
    return Scaffold(
      backgroundColor: ColorResource.white,
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorResource.white,
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        selectedItemColor: ColorResource.themeColor,
        items: buildBottomNavBarItems(),
      ),
    );
  }
}

class CardClass {
  String label;
  Color cardColor;

  CardClass({this.label, this.cardColor});
}

class SliderClass {
  String label;
  Color cardColor;
  String image;

  SliderClass({this.label, this.cardColor, this.image});
}

class Red extends StatefulWidget {
  @override
  RedState createState() => RedState();
}

class RedState extends State<Red> {
  PageController _pageController = PageController();
  double currentPage = 0;

  int selectedIndex = 0;

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });
    });
    super.initState();
  }

  static const _Duration = const Duration(milliseconds: 300);

  static const _Curve = Curves.ease;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
            margin: EdgeInsets.only(
                top: height * 0.06, right: width * 0.02, bottom: height * 0.03),
            alignment: Alignment.center,
            child: commonText(
                text: S.of(context).gridView, color: ColorResource.themeColor)),
        Container(
          margin: EdgeInsets.all(height * 0.015),
          child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: gridList.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GridPage(
                                    label: gridList[index].label,
                                    color: gridList[index].cardColor,
                                  )));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: gridList[index].cardColor,
                      child: Center(
                          child: Text(
                        gridList[index].label,
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  )),
        ),
        Container(
            margin: EdgeInsets.only(
                top: height * 0.04,
                right: width * 0.025,
                bottom: height * 0.01),
            child: commonText(
                text: S.of(context).listView, color: ColorResource.themeColor)),
        Container(
          margin: EdgeInsets.only(
            top: height * 0.01,
          ),
          height: height * 0.2,
          child: ListView.builder(
              //physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: gridList.length,
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListPage(
                                      label: gridList[index].label,
                                      color: gridList[index].cardColor,
                                    )));
                      },
                      child: Container(
                        height: 80,
                        width: 100,
                        decoration: BoxDecoration(
                          color: gridList[index].cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Text(
                          gridList[index].label,
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  )),
        ),
        Container(
            margin: EdgeInsets.only(
                top: height * 0.04,
                right: width * 0.025,
                bottom: height * 0.01),
            child: commonText(
                text: S.of(context).pageViewSlider,
                color: ColorResource.themeColor)),
        Container(
          height: height * 0.35,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                selectedIndex = page;
              });
            },
            itemCount: sliderList.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    // color: gridList[index].cardColor,
                    borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    sliderList[index].image,
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          child: Center(
            child: DotsIndicator(
              color: ColorResource.themeColor,
              controller: _pageController,
              itemCount: sliderList.length,
              onPageSelected: (int page) {
                _pageController.animateToPage(
                  page,
                  duration: _Duration,
                  curve: _Curve,
                );
              },
            ),
          ),
        ),
      ]),
    );
  }
}

class Blue extends StatefulWidget {
  @override
  _BlueState createState() => _BlueState();
}

class _BlueState extends State<Blue> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}

class Yellow extends StatefulWidget {
  @override
  _YellowState createState() => _YellowState();
}

class _YellowState extends State<Yellow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellowAccent,
    );
  }
}

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  final PageController controller;
  final int itemCount;
  final ValueChanged<int> onPageSelected;
  final Color color;

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }

  Widget _buildDot(int index) {
    double selectedNess = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2 - 1.0) * selectedNess;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.5, vertical: 12),
      width: width * 0.06,
      child: Center(
        child: Material(
          color: color,
          type: MaterialType.circle,
          child: InkWell(
            onTap: () => onPageSelected(index),
            child: Container(
              width: 8 * zoom,
              height: 8 * zoom,
            ),
          ),
        ),
      ),
    );
  }
}
