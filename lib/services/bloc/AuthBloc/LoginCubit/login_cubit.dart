import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Model/user_model.dart';
import 'package:myshop/services/AuthServices/auth_method.dart';
import 'package:myshop/services/Provider/user_provider.dart';
import 'package:myshop/services/bloc/AuthBloc/LoginCubit/login_state.dart';
import 'package:myshop/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginCubit extends Cubit<LoginState> {
  final Auth _auth = Auth();

  LoginCubit() : super(LoginInitialState());

  void loginStatus(BuildContext context,
      {required String email, required String password}) async {
    emit(LoginLoadingState());
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

      String loginResponse =
          await _auth.signIn(email: email, password: password);

      if (loginResponse.validateEmail()) {
        await userProvider.setUser();
        UserModel? currentUser = userProvider.getCurrentUser;

        if (currentUser != null) {
          await Utils.saveToken(currentUser.id!);
          emit(LoginLoadedState(currentUser.name!));
        } else {
          emit(LoginErrorState(loginResponse));
        }
      } else {
        emit(LoginErrorState(loginResponse));
      }
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }
}
