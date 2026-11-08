import 'package:fuelsense/core/preferences/preferences_provider.dart';
import 'package:fuelsense/core/preferences/preferences_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProviderImp implements PreferencesProvider {
  final SharedPreferences sharedPreferences;

  PreferencesProviderImp({required this.sharedPreferences});

  //auth provider
  @override
  String getAuthMethode() {
    return sharedPreferences.getString(PreferencesSettings.authProviderKey) ?? "";
  }

  @override
  void setAuthMethode(String authMethode) {
    sharedPreferences.setString(
      PreferencesSettings.authProviderKey,
      authMethode,
    );
  }

  @override
  void sinOutAuthMethode() {
    sharedPreferences.clear();
  }
}
