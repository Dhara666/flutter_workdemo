import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sheet_demo/common_widget/common_button.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/pages/image_permission.dart';
import 'package:sheet_demo/utils/size_utils.dart';

AudioPlayer audioPlayer = AudioPlayer();

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({Key key}) : super(key: key);

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  Duration _duration = Duration();
  Duration _position = Duration();

  int result;
  String dropdownValue = "1";
  bool playingStatus = false;

  // bool isPlaying = false;
  String get _durationText => _duration?.toString()?.split('.')?.first ?? '';

  String get _positionText => _position?.toString()?.split('.')?.first ?? '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
    print("_durationText--->>$_durationText");
    print("_positionText--->>$_positionText");
    !playingStatus ?? audioPlayer.resume();
  }

  initPlayer() {
    // ignore: deprecated_member_use
    audioPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });
    // ignore: deprecated_member_use
    audioPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
  }

  @override
  Widget build(BuildContext context) {
    print('Current page --> $runtimeType');
    print('Current duration --> $_duration');
    print('Current position --> $_position');
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: height * 0.25,
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: ColorResource.themeColor,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Container(
                    height: height * 0.043,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorResource.white,
                    ),
                    margin: EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10),
                    child: slider()),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      commonIconButton(
                          icon: Icons.volume_down,
                          function: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (builder) {
                                  return Container(
                                    height: 160,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        commonMaterialButton(
                                            text: '0',
                                            function: () {
                                              audioPlayer.setVolume(0.0);
                                              Navigator.of(context).pop();
                                            }),
                                        commonMaterialButton(
                                            text: '50',
                                            function: () {
                                              audioPlayer.setVolume(0.5);
                                              Navigator.of(context).pop();
                                            }),
                                        commonMaterialButton(
                                            text: '100',
                                            function: () {
                                              audioPlayer.setVolume(1.0);
                                              Navigator.of(context).pop();
                                            }),
                                      ],
                                    ),
                                  );
                                });
                          }),
                      commonIconButton(
                          icon: !playingStatus ? Icons.play_arrow : Icons.pause,
                          function: () async {
                            setState(() {
                              playingStatus = !playingStatus;
                            });
                            !playingStatus
                                ? result = await audioPlayer.pause()
                                : result = await audioPlayer.play(
                                    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3');
                          }),
                      commonIconButton(
                          icon: Icons.stop,
                          function: () async {
                            // ignore: unnecessary_statements
                            result = await audioPlayer.stop();
                            playingStatus = false;
                            setState(() {});
                          }),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                          child: DropdownButton(
                        dropdownColor: ColorResource.white,
                        value: dropdownValue,
                        icon: Icon(
                          Icons.arrow_downward,
                          color: ColorResource.lightThemeColor,
                        ),
                        style: TextStyle(
                          color: ColorResource.lightThemeColor,
                        ),
                        underline: Container(
                          height: 2,
                          color: ColorResource.lightThemeColor,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items:
                            ["0.5", "1", "1.5", "2", "2.5"].map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            onTap: () {
                              audioPlayer.setPlaybackRate(
                                  playbackRate: double.parse(value));
                              //isPlaying = true;
                              setState(() {});
                            },
                            child: Text(value + "x"),
                          );
                        }).toList(),
                      )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    !playingStatus || _durationText == _positionText
                        ? '$_positionText / $_durationText'
                        : '$_positionText / $_durationText',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: ColorResource.lightThemeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          commonMaterialButton(
              text: "Image Download Permission",
              function: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ImagePermission()));
              }),
        ],
      ),
    );
  }

  seekToSecond(int time) {
    Duration newDuration = Duration(microseconds: time);
    audioPlayer.seek(newDuration);
    //isPlaying = true;
  }

  Widget slider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
          trackShape: RoundedRectSliderTrackShape(),
          trackHeight: 3.5,
          activeTrackColor: ColorResource.themeColor,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 9.0),
          thumbColor: ColorResource.themeColor,
          inactiveTrackColor: ColorResource.lightThemeColor,
          overlayColor: ColorResource.lightThemeColor),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Slider(
          // value: position?.inMicroseconds?.toDouble(),
          value: _positionText != _durationText
              ? _position.inMicroseconds.toDouble()
              : 0.0,
          min: 0.0,
          max: _duration?.inMicroseconds?.toDouble(),
          label: '${_position?.inMicroseconds?.toDouble()}',
          onChanged: (double value) {
            setState(() {
              print('value --> $value');
              seekToSecond(value.toInt());
              value = value;
              // isPlaying = true;
            });
          },
        ),
      ),
    );
  }
}
// if (showBackButton)
// Container(
// padding: const EdgeInsets.only(left: 32),
// alignment: Alignment.centerLeft,
// child: const AppBackButton(),
// ),
