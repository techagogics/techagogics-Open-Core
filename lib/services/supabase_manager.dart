import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techagogics_open_core/config.dart';

class SupabaseManager {
  static final SupabaseClient client =
      SupabaseClient(SUPABASE_URL, SUPABASE_KEY);
}
