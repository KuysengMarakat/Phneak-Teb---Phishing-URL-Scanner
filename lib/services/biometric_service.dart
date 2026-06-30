import 'package:local_auth/local_auth.dart';

/// Wraps device biometric authentication (fingerprint / face).
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Whether the device supports and has biometrics enrolled.
  Future<bool> isAvailable() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return supported && canCheck;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> availableTypes() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return const [];
    }
  }

  /// Prompt the user to authenticate. Returns true on success.
  Future<bool> authenticate({
    String reason = 'Authenticate to access Phneak Teb',
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
