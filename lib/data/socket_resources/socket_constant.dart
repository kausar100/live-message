class IOConstant {
  //EMITTER
  //auth
  static const loginEmitter = 'onLoginUser';
  static const registerEmitter = 'onRegisterUser';

  //active user and request user
  static const onUserRequestListener = 'onUserRequestListener';
  static const onActiveUserListener = 'onActiveUserListener';

  //error
  static const errorOccurredListener = 'errorOccurred';

  //request sent and accept
  static const requestSentEmitter = 'onRequestSent';
  static const requestAcceptEmitter = 'onRequestAccept';

  //message sent
  static const messageSentEmitter = 'onMessageSent';

  //LISTENER
  //auth
  static const registerSuccessListener = 'onRegistrationSuccess';
  static const loginSuccessListener = 'onLoginSuccess';

  //message sent and receive
  static const messageSentSuccessListener = 'onMessageSentSuccess';
  static const messageReceiveSuccessListener = 'onMessageReceiveSuccess';

  //request sent and accept
  static const requestSentSuccessListener = 'onRequestSentSuccess';
  static const requestAcceptSuccessListener = 'onRequestAcceptSuccess';
}
