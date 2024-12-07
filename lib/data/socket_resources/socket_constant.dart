class IOConstant {
  //EMITTER
  //auth
  static const loginEmitter = 'onLoginUser';
  static const logoutEmitter = 'onLogoutUser';
  static const registerEmitter = 'onRegisterUser';

  //active user
  static const onFetchActiveUserEmitter = 'onFetchActiveUser';
  static const onUpdateEngagedStatusEmitter = 'onUpdateEngagedStatus';

  //request sent and accept
  static const requestSentEmitter = 'onRequestSent';
  static const requestAcceptEmitter = 'onRequestAccept';

  //message sent
  static const messageSentEmitter = 'onSendMessage';
  static const joinRoomEmitter = 'onJoinRoom';

  //LISTENER
  //auth
  static const registerSuccessListener = 'onRegistrationSuccess';
  static const loginSuccessListener = 'onLoginSuccess';
  static const logoutSuccessListener = 'onLogoutSuccess';
  static const onUpdateEngagedStatusSuccessListener = 'onUpdateEngagedStatusSuccessListener';

  //message sent and receive
  static const messageSentSuccessListener = 'onMessageSentSuccess';
  static const messageReceiveSuccessListener = 'onMessageReceiveSuccess';

  //active user and request user
  static const onUserRequestListener = 'onUserRequestListener';
  static const onActiveUserListener = 'onActiveUserListener';
  static const onNewUserLoginListener = 'onNewLoginUserListener';

  //request sent and accept
  static const requestSentSuccessListener = 'onRequestSentSuccess';
  static const requestAcceptSuccessListener = 'onRequestAcceptSuccess';

  //error
  static const errorOccurredListener = 'errorOccurred';
  static const userBusyListener = "userBusy";
}
