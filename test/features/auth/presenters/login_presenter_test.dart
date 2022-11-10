import 'package:flutter_demo/core/domain/model/user.dart';
import 'package:flutter_demo/features/auth/domain/model/log_in_failure.dart';
import 'package:flutter_demo/features/auth/login/login_initial_params.dart';
import 'package:flutter_demo/features/auth/login/login_presentation_model.dart';
import 'package:flutter_demo/features/auth/login/login_presenter.dart';
import 'package:flutter_demo/localization/app_localizations_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_utils/test_utils.dart';
import '../mocks/auth_mock_definitions.dart';

void main() {
  late LoginPresentationModel model;
  late LoginPresenter presenter;
  late MockLoginNavigator navigator;
  late MockLogInUseCase logInUseCase;

  test(
    'sample test',
    () {
      expect(presenter, isNotNull); // TODO implement this
    },
  );

  test(
    'should show alert when logInUseCase execute successfully',
    () async {
      // GIVEN
      when(
        () => presenter.logInUseCase.execute(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) => successFuture(
          const User(
            id: 'id_test',
            username: 'test',
          ),
        ),
      );

      when(
        () => navigator.showAlert(
          title: appLocalizations.logInAction,
          message: appLocalizations.logInSuccess,
        ),
      ).thenAnswer((_) => Future.value());

      // WHEN
      await presenter.onLogin();

      // THEN
      verify(
        () => navigator.showAlert(
          title: appLocalizations.logInAction,
          message: appLocalizations.logInSuccess,
        ),
      );
    },
  );

  group('should show error when logInUseCase fails', () {
    test(
      'wrong credentials',
      () async {
        // GIVEN
        when(
          () => presenter.logInUseCase.execute(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => failFuture(const LogInFailure.unknown()));

        when(() => navigator.showError(any())).thenAnswer((_) => Future.value());

        // WHEN
        await presenter.onLogin();

        // THEN
        verify(() => navigator.showError(any()));
      },
    );

    test(
      'missing credentials',
      () async {
        // GIVEN
        when(
          () => presenter.logInUseCase.execute(
            username: '',
            password: '',
          ),
        ).thenAnswer(
          (_) => failFuture(const LogInFailure.missingCredentials()),
        );

        when(() => navigator.showError(any())).thenAnswer((_) => Future.value());

        // WHEN
        await presenter.onLogin();

        // THEN
        verify(() => navigator.showError(any()));
      },
    );
  });

  setUp(() {
    model = LoginPresentationModel.initial(const LoginInitialParams());
    navigator = MockLoginNavigator();
    logInUseCase = MockLogInUseCase();
    presenter = LoginPresenter(
      model,
      navigator,
      logInUseCase,
    );
  });
}
