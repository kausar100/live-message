class IOConstant {
  //EMITTER
  //auth
  static const loginEmitter = 'onLoginUser';
  static const registerEmitter = 'onRegisterUser';

  //active user
  static const onFetchActiveUserEmitter = 'onFetchActiveUser';

  //request sent and accept
  static const requestSentEmitter = 'onRequestSent';
  static const requestAcceptEmitter = 'onRequestAccept';

  //message sent
  static const messageSentEmitter = 'onMessageSent';
  static const joinRoomEmitter = 'onJoinRoom';

  //LISTENER
  //auth
  static const registerSuccessListener = 'onRegistrationSuccess';
  static const loginSuccessListener = 'onLoginSuccess';

  //message sent and receive
  static const messageSentSuccessListener = 'onMessageSentSuccess';
  static const messageReceiveSuccessListener = 'onMessageReceiveSuccess';

  //active user and request user
  static const onUserRequestListener = 'onUserRequestListener';
  static const onActiveUserListener = 'onActiveUserListener';

  //request sent and accept
  static const requestSentSuccessListener = 'onRequestSentSuccess';
  static const requestAcceptSuccessListener = 'onRequestAcceptSuccess';

  //error
  static const errorOccurredListener = 'errorOccurred';
  static const userBusyListener = "userBusy";
}
