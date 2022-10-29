import 'package:local_auth/local_auth.dart';

class Lock{
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> checkBiometrics() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<bool> isValidUser() async {
    final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to login you account',
        options: const AuthenticationOptions(biometricOnly: true));
    return didAuthenticate;
  }
}