import 'package:flutter_test/flutter_test.dart';
import 'package:flow/core/sync/sync_prefs.dart';
import 'package:flow/core/sync/sync_queue.dart';
import 'package:flow/core/sync/sync_remote.dart';
import 'package:flow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flow/features/transaction/data/models/transaction_model.dart';

class _MemPrefs implements SyncPrefs {
  final Map<String, dynamic> _m = {};
  @override
  get(String key) => _m[key];
  @override
  Future<void> put(String key, value) async {
    _m[key] = value;
  }
}

class _CollectRemote implements SyncRemote {
  final List<Map<String, dynamic>> sent = [];
  @override
  Future<void> sendEvents(List<Map<String, dynamic>> events) async {
    sent.addAll(events);
  }
}

void main() {
  test('enqueues and flushes sync events', () async {
    final prefs = _MemPrefs();
    final remote = _CollectRemote();
    final q = SyncQueue(prefs: prefs, remote: remote);

    final e = TransactionEntity(
      id: 't1',
      amount: 100,
      date: DateTime.utc(2024, 1, 1),
      type: TransactionType.income,
      categoryId: 'c1',
      walletId: 'w1',
      currency: 'BDT',
      tags: const [],
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 1, 1),
      isSynced: false,
      isDeleted: false,
    );

    q.enqueueTransactionUpsert(e);
    expect((prefs.get('sync_queue') as List).length, 1);
    await q.flush();
    expect(remote.sent.length, 1);
    expect((prefs.get('sync_queue') as List).isEmpty, true);
  });
}

