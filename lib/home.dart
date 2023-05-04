import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/lock_info.dart';

class Home extends StatefulWidget {
  final String value;
  final VoidCallback onPressed;

  const Home({super.key,
    required this.value,
    required this.onPressed
  });
  
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static List<LockInfo> locks = [
    LockInfo(
        id: '1',
        name: 'Lock1',
        state: 'locked',
        icon: const Icon(Icons.lock).icon
    ),
    LockInfo(
        id: '2',
        name: 'Lock2',
        state: 'opened',
        icon: const FaIcon(
          FontAwesomeIcons.fiveHundredPx,
          color: Colors.black,
          size: 32.0,
        ).icon
    ),
    LockInfo(
        id: '3',
        name: 'Lock3',
        state: 'error',
        icon: const FaIcon(
          FontAwesomeIcons.fiveHundredPx,
          color: Colors.black,
          size: 32.0,
        ).icon
    ),
    LockInfo(
        id: '4',
        name: 'Lock4',
        state: 'warning',
        icon: const FaIcon(
          FontAwesomeIcons.fiveHundredPx,
          color: Colors.black,
          size: 32.0,
        ).icon
    ),
    LockInfo(
        id: '5',
        name: 'Lock5',
        state: 'unlocked',
        icon: const FaIcon(
          FontAwesomeIcons.fiveHundredPx,
          color: Colors.black,
          size: 32.0,
        ).icon
    )
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.start,
            children: locks.map((e) {
              return GlassContainer(
                margin: const EdgeInsets.only(left: 10, right: 5),
                height: 150,
                width: 175,
                borderRadius: BorderRadius.circular(25.0),
                borderWidth: 1.5,
                blur: 15.0,
                frostedOpacity: 0.06,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.40),
                    Colors.white.withOpacity(0.06),
                  ],
                  begin: const Alignment(-0.10, -1.0),
                  end: const Alignment(0.00, 1.0),
                ),
                borderGradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.70),
                      Colors.white.withOpacity(0.0),
                      Colors.grey.withOpacity(0.0),
                      Colors.grey.withOpacity(0.60),
                    ],
                    begin: const Alignment(0.35, -1.0),
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.30, 0.31, 1.0]
                  // stops: []
                ),
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
                elevation: 5.0,
                child: CardChild(lockInfo: e,),
              );
            }).toList(),
          ),
        ),
      )
    );
  }
}

class CardChild extends StatelessWidget {
  final textStyle = GoogleFonts.sourceCodePro(
    color: Colors.black54,
    fontSize: 16.0,
  );
  LockInfo lockInfo;

  CardChild({
    super.key,
    required this.lockInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(lockInfo.icon),
            Text(lockInfo.id, style: textStyle),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lockInfo.name,
              style: textStyle.copyWith(fontSize: 20.0),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(lockInfo.state, style: textStyle)
              ],
            ),
          ],
        ),
      ],
    );
  }
}
