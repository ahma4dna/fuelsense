import 'package:fuelsense/core/data/network_info/network_info.dart';
import 'package:fuelsense/core/data/network_info/network_info_imp.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class CoreModule {
  @lazySingleton
  SupabaseClient supabaseClient() => Supabase.instance.client;
  @lazySingleton
  NetworkInfo networkInfo() => NetworkInfoImp();
}
