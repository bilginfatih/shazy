import 'package:flutter/material.dart';
import '../core/init/cache/cache_manager.dart';
import '../models/user/user_model.dart';
import '../services/history/history_service.dart';
import '../services/user/user_service.dart';
import '../widgets/padding/base_padding.dart';

// TODO: End pointleri test etmek için olan sayfa proda çıkmadan kaldırılacak
class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  var data = await CacheManager.instance.getData('user', 'email');
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
            ],
          ),
        ),
      ),
    );
  }
}
