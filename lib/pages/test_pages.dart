import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/utils/theme/themes.dart';
import 'package:shazy/widgets/buttons/primary_button.dart';
import 'package:shazy/widgets/containers/payment_method_container.dart';
import 'package:shazy/widgets/icons/circular_svg_icon.dart';
import 'package:shazy/widgets/modal_bottom_sheet/comment_bottom_sheet.dart';
import 'package:shazy/widgets/rating_bars/star_rating_bar.dart';
import 'package:shazy/widgets/textfields/otp_text_form_field.dart';
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
            ],
          ),
        ),
      ),
    );
  }
}
