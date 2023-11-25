import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../models/comment/comment_model.dart';
import '../models/drive/drive_model.dart';
import '../services/comment/comment_service.dart';
import '../services/drive/drive_service.dart';
import '../services/security/security_service.dart';
import '../utils/extensions/context_extension.dart';
import '../utils/theme/themes.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/containers/payment_method_container.dart';
import '../widgets/icons/circular_svg_icon.dart';
import '../widgets/modal_bottom_sheet/comment_bottom_sheet.dart';
import '../widgets/rating_bars/star_rating_bar.dart';
import '../widgets/textfields/otp_text_form_field.dart';
import '../core/init/cache/cache_manager.dart';
import '../models/user/user_model.dart';
import '../services/history/history_service.dart';
import '../services/user/user_service.dart';
import '../widgets/padding/base_padding.dart';

// TODO: End pointleri test etmek için olan sayfa proda çıkmadan kaldırılacak
class TestPage extends StatelessWidget {
  TestPage({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BasePadding(
        context: context,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  UserModel model = UserModel(
                    name: 'test2',
                    email: 'test234@gmail.com',
                    password: 'test222',
                    passwordConfirmation: 'test222',
                    identificationNumber: '222222223',
                    surname: 'test',
                    gender: 'male',
                    phone: '99999999998',
                  );
                  await UserService.instance.register(model);
                },
                child: Text('Register'),
              ),
              ElevatedButton(
                onPressed: () async {
                  UserModel model = UserModel(
                    email: 'test23@gmail.com',
                    password: 'test22',
                  );
                  await UserService.instance.login(model);
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var response =
                      await HistoryService.instance.getDriverHistory();
                  print(response);
                },
                child: Text('GetDriverHistory'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var response =
                      await HistoryService.instance.getDriverHistory();
                  print(response);
                },
                child: Text('GetPassengerHistory'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var data =
                      await CacheManager.instance.getData('user', 'email');
                  print(data);
                },
                child: Text('HiveTest'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var data = await UserService.instance.getUser();
                  print(data);
                },
                child: Text('User'),
              ),
              ElevatedButton(
                onPressed: () async {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    context: context,
                    builder: (_) => CommentBottomSheet(
                      selectedIndex: 0,
                      context: context,
                      textController: TextEditingController(),
                      onPressed: () {},
                      text: 'You rated Zübeyir X 5 star',
                    ),
                  );
                },
                child: Text('CommentBottomSheetBar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  CommentModel model = CommentModel(
                    commentorUserId: userId,
                    comment: 'test',
                    point: '5',
                  );
                  await CommentService.instance.comment(model);
                },
                child: Text('Comment'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  await CommentService.instance.getComment(userId);
                },
                child: Text('My Comment'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  DriveModel model = DriveModel(driverId: userId);
                  await DriveService.instance.driverActive(model);
                },
                child: Text('Driver Active'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  DriveModel model = DriveModel(driverId: userId);
                  await DriveService.instance.driveCancel(model);
                },
                child: Text('Drive Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  DriveModel model = DriveModel(driverId: userId);
                  await DriveService.instance.driverPassive(model);
                },
                child: Text('Driver Passive'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  var now = DateTime.now();
                  var timeTo =
                      DateTime(now.year, now.month, now.day, 23, 23, 23);
                  DriveModel model = DriveModel(
                    driverId: userId,
                    to: 'id',
                    timeFrom: now.toString(),
                    timeTo: timeTo.toString(),
                  );
                  await DriveService.instance.driveMatched(model);
                },
                child: Text('Driver Matched'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  DriveModel model = DriveModel(
                    callerId: userId,
                  );
                  await DriveService.instance.driveConfirmed(model);
                },
                child: Text('Driver Confirmed'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  DriveModel model = DriveModel(
                    driverId: userId,
                  );
                  await DriveService.instance.driving(model);
                },
                child: Text('Driving'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await SecurityService.intance.callerCode('sadsda');
                },
                child: Text('Caller Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
