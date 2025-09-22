import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:flow/core/db/hive_box.dart';
import 'package:flow/core/sync/sync_prefs.dart';
import 'package:flow/core/sync/sync_remote.dart';
import 'package:flow/features/transaction/domain/entities/transaction_entity.dart';

final syncRemoteProvider = Provider<SyncRemote>((ref) {
  // Default wired to a stub; override in prod with real Supabase client
  // using ProviderScope overrides.
  return _defaultStub;
});

// Late initialized to avoid import cycle in tests
final SyncRemote _defaultStub = _StubRemote();

class _StubRemote implements SyncRemote {
  @override
  Future<void> sendEvents(List<Map<String, dynamic>> events) async {}
}

final syncQueueProvider = Provider<SyncQueue>((ref) {
  final remote = ref.read(syncRemoteProvider);
  final prefs = HiveSyncPrefs(Hive.box<dynamic>(HiveBoxes.prefs));
  final queue = SyncQueue(prefs: prefs, remote: remote);
  ref.onDispose(queue.dispose);
  return queue;
});

class SyncQueue {
  final SyncPrefs prefs;
  final SyncRemote remote;
  final List<Map<String, dynamic>> _buffer = [];
  Timer? _timer;

  SyncQueue({required this.prefs, required this.remote}) {
    // Load persisted queue
    final existing = prefs.get('sync_queue');
    if (existing is List) {
      _buffer.addAll(existing.cast<Map>().map((e) => Map<String, dynamic>.from(e)));
    }
  }

  void enqueue(String type, Map<String, dynamic> payload) {
    final event = {
      'type': type,
      'payload': payload,
      'ts': DateTime.now().toUtc().toIso8601String(),
    };
    _buffer.add(event);
    _persist();
    _schedule();
  }

  void enqueueTransactionUpsert(TransactionEntity e) {
    enqueue('txn_upsert', {
      'id': e.id,
      'amount': e.amount,
      'date': e.date.toIso8601String(),
      'type': e.type.name,
      'categoryId': e.categoryId,
      'walletId': e.walletId,
      'targetWalletId': e.targetWalletId,
      'note': e.note,
      'currency': e.currency,
      'tags': e.tags,
      'isDeleted': e.isDeleted,
    });
  }

  void enqueueTransactionDelete(String id) {
    enqueue('txn_delete', {'id': id});
  }

  void _schedule() {
    _timer ??= Timer(const Duration(seconds: 3), () {
      unawaited(flush());
    });
  }

  Future<void> flush() async {
    _timer?.cancel();
    _timer = null;
    if (_buffer.isEmpty) return;
    final batch = List<Map<String, dynamic>>.from(_buffer);
    try {
      await remote.sendEvents(batch);
      _buffer.clear();
      _persist();
    } catch (_) {
      // keep buffer for retry
    }
  }

  void _persist() {
    // store plain maps only
    prefs.put(
      'sync_queue',
      _buffer.map((e) => Map<String, dynamic>.from(e)).toList(),
    );
  }

  void dispose() {
    _timer?.cancel();
  }
}
