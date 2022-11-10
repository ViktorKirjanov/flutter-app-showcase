import 'package:flutter_demo/dependency_injection/app_component.dart';
import 'package:flutter_demo/features/auth/login/login_initial_params.dart';
import 'package:flutter_demo/features/auth/login/login_navigator.dart';
import 'package:flutter_demo/features/auth/login/login_page.dart';
import 'package:flutter_demo/features/auth/login/login_presentation_model.dart';
import 'package:flutter_demo/features/auth/login/login_presenter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/mocks.dart';
import '../../../test_utils/golden_tests_utils.dart';
import '../mocks/auth_mocks.dart';

Future<void> main() async {
  late LoginPage page;
  late LoginInitialParams initParams;
  late LoginPresentationModel model;
  late LoginPresenter presenter;
  late LoginNavigator navigator;

  // ignore: no_leading_underscores_for_local_identifiers
  void _initMvp() {
    initParams = const LoginInitialParams();
    model = LoginPresentationModel.initial(
      initParams,
    );
    navigator = LoginNavigator(Mocks.appNavigator);
    presenter = LoginPresenter(
      model,
      navigator,
      AuthMocks.logInUseCase,
    );
    page = LoginPage(presenter: presenter);
  }

  await screenshotTest(
    "login_page_init",
    setUp: () async {
      _initMvp();
    },
    pageBuilder: () => page,
  );
  await screenshotTest(
    "login_page_with_username_only",
    setUp: () async {
      _initMvp();
      presenter.emit(
        model.copyWith(
          username: "test",
        ),
      );
    },
    pageBuilder: () => page,
  );

  await screenshotTest(
    "login_page_with_password_only",
    setUp: () async {
      _initMvp();
      presenter.emit(
        model.copyWith(
          password: "test123",
        ),
      );
    },
    pageBuilder: () => page,
  );

  await screenshotTest(
    "login_page_with_credentials",
    setUp: () async {
      _initMvp();
      presenter.emit(
        model.copyWith(
          username: "test",
          password: "test123",
        ),
      );
    },
    pageBuilder: () => page,
  );

  test("getIt page resolves successfully", () async {
    _initMvp();
    final page = getIt<LoginPage>(param1: initParams);
    expect(page.presenter, isNotNull);
    expect(page, isNotNull);
  });
}
