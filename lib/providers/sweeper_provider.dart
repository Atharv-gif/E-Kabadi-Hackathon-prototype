import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/garbage_spot_model.dart';
import '../models/cleaning_task_model.dart';
import '../repositories/sweeper_repository.dart';
import '../services/reward_rules_service.dart';

final sweeperRepositoryProvider = Provider<MockSweeperRepository>((ref) {
  return MockSweeperRepository();
});

// ── State ──

class SweeperState {
  final List<GarbageSpot> nearbySpots;
  final CleaningTask? activeTask;
  final GarbageSpot? activeSpot;
  final List<CleaningTask> taskHistory;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  // Default demo sweeper location (Sector 62, Noida — same area as existing demo)
  final double currentLat;
  final double currentLng;

  const SweeperState({
    this.nearbySpots = const [],
    this.activeTask,
    this.activeSpot,
    this.taskHistory = const [],
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.currentLat = 28.6250,
    this.currentLng = 77.3680,
  });

  SweeperState copyWith({
    List<GarbageSpot>? nearbySpots,
    CleaningTask? activeTask,
    GarbageSpot? activeSpot,
    List<CleaningTask>? taskHistory,
    bool? isLoading,
    String? error,
    String? successMessage,
    bool clearActiveTask = false,
    bool clearActiveSpot = false,
    bool clearSuccess = false,
  }) {
    return SweeperState(
      nearbySpots: nearbySpots ?? this.nearbySpots,
      activeTask: clearActiveTask ? null : (activeTask ?? this.activeTask),
      activeSpot: clearActiveSpot ? null : (activeSpot ?? this.activeSpot),
      taskHistory: taskHistory ?? this.taskHistory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
      currentLat: currentLat,
      currentLng: currentLng,
    );
  }
}

// ── Notifier ──

class SweeperNotifier extends StateNotifier<SweeperState> {
  final MockSweeperRepository _repository;

  SweeperNotifier(this._repository) : super(const SweeperState());

  Future<void> loadNearbySpots() async {
    state = state.copyWith(isLoading: true);
    try {
      final spots = await _repository.getNearbyGarbageSpots(
        state.currentLat,
        state.currentLng,
      );
      state = state.copyWith(nearbySpots: spots, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Gets the display distance for a spot in km.
  double getDistanceKm(GarbageSpot spot) {
    return _repository.getDistanceKm(state.currentLat, state.currentLng, spot);
  }

  Future<void> selectSpot(GarbageSpot spot) async {
    state = state.copyWith(activeSpot: spot);
  }

  Future<bool> claimTask(String garbageSpotId) async {
    state = state.copyWith(isLoading: true);
    try {
      final task = await _repository.claimTask(garbageSpotId, 'SWP-DEMO-001');
      if (task == null) {
        state = state.copyWith(isLoading: false, error: 'Task already claimed by someone else.');
        return false;
      }
      state = state.copyWith(activeTask: task, isLoading: false);
      // Refresh spots to remove claimed one
      await loadNearbySpots();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> startTask() async {
    if (state.activeTask == null) return false;
    state = state.copyWith(isLoading: true);
    try {
      final task = await _repository.startTask(state.activeTask!.id);
      if (task != null) {
        state = state.copyWith(activeTask: task, isLoading: false);
        return true;
      }
      state = state.copyWith(isLoading: false, error: 'Failed to start task.');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> submitBeforePhoto(String photoPath) async {
    if (state.activeTask == null) return false;
    final task = await _repository.submitBeforePhoto(state.activeTask!.id, photoPath);
    if (task != null) {
      state = state.copyWith(activeTask: task);
      return true;
    }
    return false;
  }

  Future<bool> submitAfterPhoto(String photoPath) async {
    if (state.activeTask == null) return false;
    final task = await _repository.submitAfterPhoto(state.activeTask!.id, photoPath);
    if (task != null) {
      state = state.copyWith(activeTask: task);
      return true;
    }
    return false;
  }

  Future<bool> submitCompletion(double volumeLitres) async {
    if (state.activeTask == null) return false;
    state = state.copyWith(isLoading: true);
    try {
      final task = await _repository.submitCompletion(state.activeTask!.id, volumeLitres);
      if (task != null) {
        state = state.copyWith(activeTask: task, isLoading: false);
        return true;
      }
      state = state.copyWith(isLoading: false, error: 'Failed to submit.');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Mock auto-approval for hackathon demo — credits eco points via RewardLedger.
  Future<bool> mockApproveActiveTask() async {
    if (state.activeTask == null) return false;
    state = state.copyWith(isLoading: true);
    try {
      final task = await _repository.approveTask(state.activeTask!.id);
      if (task != null) {
        // Credit sweeper eco points through the unified ledger
        RewardLedger.awardSweeperPointsForCleaning(
          task.verifiedVolumeLitres ?? 0,
        );
        state = state.copyWith(
          activeTask: task,
          isLoading: false,
          successMessage: 'Eco Points credited!',
        );
        return true;
      }
      state = state.copyWith(isLoading: false, error: 'Approval failed.');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> loadHistory() async {
    final history = await _repository.getTaskHistory('SWP-DEMO-001');
    state = state.copyWith(taskHistory: history);
  }

  void clearActiveTask() {
    state = state.copyWith(clearActiveTask: true, clearActiveSpot: true);
  }
}

// ── Provider ──

final sweeperProvider = StateNotifierProvider<SweeperNotifier, SweeperState>((ref) {
  final repo = ref.watch(sweeperRepositoryProvider);
  return SweeperNotifier(repo);
});
