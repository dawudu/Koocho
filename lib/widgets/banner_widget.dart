import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class BannerWigdet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .25,
        color: Colors.yellow.shade300,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Barter",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 45.0,
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              shadows: [
                                Shadow(
                                  blurRadius: 7.0,
                                  color: Colors.black,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                FlickerAnimatedText(
                                  'Barter anything!',
                                  speed: const Duration(seconds: 4),
                                ),
                                FlickerAnimatedText(
                                  'Art work for\n electronics!',
                                  speed: const Duration(seconds: 4),
                                ),
                                FlickerAnimatedText(
                                  'Gym access\nfor detergents!',
                                  speed: const Duration(seconds: 4),
                                ),
                                FlickerAnimatedText(
                                  "Clothes for books",
                                  speed: const Duration(seconds: 4),
                                ),
                                FlickerAnimatedText(
                                  "Cooking skills\nfor trips",
                                  speed: const Duration(seconds: 4),
                                ),
                                FlickerAnimatedText(
                                  "Baby sitting \nfor wifi access",
                                  speed: const Duration(seconds: 4),
                                ),
                                FlickerAnimatedText(
                                  "Bitcoin lessons\nfor airtime",
                                  speed: const Duration(seconds: 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Neumorphic(
                      style: NeumorphicStyle(
                          color: Colors.white, oppositeShadowLightSource: true),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                            "https://firebasestorage.googleapis.com/v0/b/koochobarterapp.appspot.com/o/banner%2Fmtnlogo.png?alt=media&token=b1541ad2-deb2-4eb6-8074-576e6efa8102"),
                      ),
                    ),
                    Text("Sponsored by\nMTN "),
                  ],
                ),
              ),
              // Row(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Expanded(
              //       child: NeumorphicButton(
              //         onPressed: () {},
              //         style: NeumorphicStyle(
              //           color: Colors.white,
              //         ),
              //         child: Text(
              //           "Top traders scoreboard",
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: 20,
              //     ),
              //     Expanded(
              //       child: NeumorphicButton(
              //         onPressed: () {},
              //         style: NeumorphicStyle(
              //           color: Colors.white,
              //         ),
              //         child: Text(
              //           "Trade referral scoreboard",
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
