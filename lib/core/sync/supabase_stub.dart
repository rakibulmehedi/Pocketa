import 'package:flow/core/sync/sync_remote.dart';

/// Placeholder remote that simply completes. Replace with Supabase client.
class SupabaseStubRemote implements SyncRemote {
  @override
  Future<void> sendEvents(List<Map<String, dynamic>> events) async {
    // no-op in stub
  }
}

