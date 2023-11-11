import 'package:flutter/material.dart';
import 'package:shazy/models/user/user_model.dart';
import 'package:shazy/services/user/user_service.dart';
import 'package:shazy/widgets/padding/base_padding.dart';

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
                    email: 'test23@gmail.com',
                    password: 'test22',
                    passwordConfirmation: 'test22',
                    identificationNumber: '222222221',
                    surname: 'test',
                    gender: 'male',
                    phone: '99999999991',
                  );
                  await UserService.instance.register(model);
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
