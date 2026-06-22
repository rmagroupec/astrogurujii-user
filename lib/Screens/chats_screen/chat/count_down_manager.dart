// lib/Screens/chats_screen/chat/count_down_manager.dart
//
// ═══════════════════════════════════════════════════════════════════════════════
// Firebase-synced countdown — mirrors the React ChatContext exactly.
//
// Firebase node: CallSession/{channelId}
//   max_minutes   (int)    — remaining minutes after last server debit tick
//   last_tick_at  (int/ms) — epoch-ms when last debit happened
//   started_at    (int/ms) — epoch-ms when astrologer accepted (before 1st debit)
//   status        (String) — end_astro | end_user | wallet_empty
//
// Accurate formula (same as React):
//   if max_minutes + last_tick_at present:
//     accurateSeconds = (max_minutes × 60) − ⌊(now − last_tick_at) / 1000⌋
//   else if started_at present (before first debit):
//     accurateSeconds = (wallet ÷ rate × 60) − ⌊(now − started_at) / 1000⌋
//   else:
//     fall back to local optimistic estimate
//
// Drift correction: only applied when |local − server| > 10 s  (React uses 5 s)
// ═══════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class CountdownManager {
  static const _dbUrl =
      'https://astrogurujii-production-default-rtdb.firebaseio.com/';

  // ── Public notifiers ────────────────────────────────────────────────────────
  /// Countdown seconds remaining — update your UI with ValueListenableBuilder.
  final ValueNotifier<int>    timeLeftNotifier = ValueNotifier<int>(0);

  /// Server status string — listen for 'end_astro' / 'end_user' / 'wallet_empty'.
  final ValueNotifier<String> statusNotifier   = ValueNotifier<String>('');

  // ── Private ─────────────────────────────────────────────────────────────────
  Timer?                             _localTick;
  StreamSubscription<DatabaseEvent>? _firebaseSub;

  bool _started  = false;
  bool _disposed = false;

  // Stored so Firebase handler can compute started_at fallback
  int _initialWallet   = 0;
  int _perMinCharge    = 1;

  // ─────────────────────────────────────────────────────────────────────────────
  // start()
  // Call once when the chat / call screen opens.
  // ─────────────────────────────────────────────────────────────────────────────
  void start({
    required String channelId,
    required int    initialWallet,
    required int    perMinCharge,
  }) {
    if (_started || _disposed) return;
    _started = true;

    _initialWallet = initialWallet;
    _perMinCharge  = perMinCharge > 0 ? perMinCharge : 1;

    // Optimistic local seed while Firebase first snapshot arrives (~0.5 s)
    final optimisticSeconds = (initialWallet ~/ _perMinCharge) * 60;
    _setTime(optimisticSeconds);

    // Local 1 Hz tick
    _localTick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_disposed) return;
      final cur = timeLeftNotifier.value;
      if (cur > 0) _setTime(cur - 1);
    });

    _listenFirebase(channelId);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Firebase listener
  // ─────────────────────────────────────────────────────────────────────────────
  void _listenFirebase(String channelId) {
    final ref = FirebaseDatabase.instanceFor(
      app        : Firebase.app(),
      databaseURL: _dbUrl,
    ).ref().child('CallSession').child(channelId);

    _firebaseSub = ref.onValue.listen(
      (DatabaseEvent event) {
        if (_disposed) return;
        final raw = event.snapshot.value;
        if (raw == null) return;

        final data   = Map<String, dynamic>.from(raw as Map);
        final status = (data['status'] ?? '') as String;

        // ── 1. React to end status ─────────────────────────────────────────
        if (['end_astro', 'end_user', 'wallet_empty'].contains(status)) {
          _setTime(0);
          if (!_disposed) statusNotifier.value = status;
          _stopTick();
          return;
        }

        // ── 2. Compute accurate seconds ────────────────────────────────────
        final accurate = _computeAccurateSeconds(data);
        if (accurate == null) return;

        // ── 3. Drift-correct only if difference > 10 s ────────────────────
        final local = timeLeftNotifier.value;
        if ((local - accurate).abs() > 10) {
          debugPrint(
            '[CountdownManager] drift ${local - accurate}s → correcting '
            'local=$local server=$accurate',
          );
          _setTime(accurate);
        }
      },
      onError: (e) {
        debugPrint('[CountdownManager] Firebase error: $e');
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // _computeAccurateSeconds — mirrors React's 3-tier formula
  // ─────────────────────────────────────────────────────────────────────────────
  int? _computeAccurateSeconds(Map<String, dynamic> data) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    final rawMaxMinutes = data['max_minutes'];
    final rawLastTick   = data['last_tick_at'];
    final rawStartedAt  = data['started_at'];

    // ── Tier 1: max_minutes + last_tick_at (most accurate — post-first-debit) ──
    if (rawMaxMinutes != null) {
      final maxSeconds = (int.tryParse(rawMaxMinutes.toString()) ?? 0) * 60;

      if (rawLastTick != null) {
        final lastTickMs      = int.tryParse(rawLastTick.toString()) ?? nowMs;
        final elapsedSinceTick = ((nowMs - lastTickMs) / 1000).floor();
        final accurate         = (maxSeconds - elapsedSinceTick).clamp(0, maxSeconds);
        debugPrint(
          '[CountdownManager] tier1 max_minutes=$rawMaxMinutes '
          'elapsed=${elapsedSinceTick}s → accurate=${accurate}s',
        );
        return accurate;
      }

      // max_minutes present but no last_tick_at yet — use as-is
      debugPrint('[CountdownManager] tier1 (no last_tick) → ${maxSeconds}s');
      return maxSeconds;
    }

    // ── Tier 2: started_at (before first debit tick) ──────────────────────
    if (rawStartedAt != null) {
      final startedAtMs       = int.tryParse(rawStartedAt.toString()) ?? nowMs;
      final elapsedSinceStart = ((nowMs - startedAtMs) / 1000).floor();
      final maxSeconds        = (_initialWallet ~/ _perMinCharge) * 60;
      final accurate          = (maxSeconds - elapsedSinceStart).clamp(0, maxSeconds);
      debugPrint(
        '[CountdownManager] tier2 started_at elapsed=${elapsedSinceStart}s '
        '→ accurate=${accurate}s',
      );
      return accurate;
    }

    // ── Tier 3: no Firebase data yet — keep local estimate ────────────────
    debugPrint('[CountdownManager] tier3: no Firebase data, keeping local');
    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────────
  void _setTime(int seconds) {
    if (_disposed) return;
    timeLeftNotifier.value = seconds.clamp(0, 99999);
  }

  void _stopTick() {
    _localTick?.cancel();
    _localTick = null;
  }

  /// Public alias kept for backward-compat with any code that calls stopCountdown()
  void stopCountdown() => _stop();

  void _stop() {
    _stopTick();
    _firebaseSub?.cancel();
    _firebaseSub = null;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // dispose
  // ─────────────────────────────────────────────────────────────────────────────
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _stop();
    try { timeLeftNotifier.dispose(); } catch (_) {}
    try { statusNotifier.dispose();   } catch (_) {}
  }
}