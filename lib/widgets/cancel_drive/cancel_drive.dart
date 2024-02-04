import 'dart:async';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/constants/navigation_constant.dart';
import '../app_bars/back_app_bar.dart';
import '../buttons/primary_button.dart';

class CancelDrive extends StatefulWidget {
  CancelDrive({
    Key? key,
  }) : super(key: key);

  @override
  _CancelDriveState createState() => _CancelDriveState();
}

class _CancelDriveState extends State<CancelDrive> {
  late Box<int> _countdownBox;
  late StreamController<int> _countdownController;
  late int _countdownValue;

  @override
  void initState() {
    super.initState();

    _countdownBox = Hive.box<int>('countdownBox');
    _countdownValue = _countdownBox.get('countdownValue', defaultValue: 30) ?? 30;

    _countdownController = StreamController<int>.broadcast();
    startCountdown();
  }

  void startCountdown() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (timer) {
      if (_countdownValue > 0) {
        setState(() {
          _countdownValue--;
        });
        _countdownBox.put('countdownValue', _countdownValue);
        _countdownController.add(_countdownValue);
      } else {
        timer.cancel();
        _countdownBox.delete('countdownValue'); // Cache'i sil
        NavigationManager.instance.navigationToPageClear(NavigationConstant.homePage);
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _countdownController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cancel Ceza Sayfası'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<int>(
        stream: _countdownController.stream,
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Dikeyde ortala
              children: [
                Text(
                  'Geri Sayım: ${formatTime(snapshot.data ?? _countdownValue)}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                PrimaryButton(
                  text: 'Ana sayfaya dön',
                  context: context,
                  onPressed: () {
                    NavigationManager.instance.navigationToPageClear(NavigationConstant.homePage);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
