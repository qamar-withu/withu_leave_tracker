import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/domain/dashboard/entities/dashboard_stats.dart';
import 'package:withu_leave_tracker/domain/dashboard/repository/dashboard_repository.dart';
import 'package:withu_leave_tracker/domain/leave_request/entities/leave_request.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';

part 'dashboard_bloc.freezed.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc(this._repository) : super(const DashboardState.initial()) {
    on<_LoadDashboardData>(_onLoadDashboardData);
    on<_RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboardData(
    _LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardState.loading());

    final statsResult = await _repository.getDashboardStats(event.userId);
    final recentRequestsResult = await _repository.getRecentLeaveRequests(
      event.userId,
    );

    statsResult.fold((failure) => emit(DashboardState.error(failure)), (stats) {
      recentRequestsResult.fold(
        (failure) => emit(DashboardState.error(failure)),
        (requests) => emit(DashboardState.loaded(stats, requests)),
      );
    });
  }

  Future<void> _onRefreshDashboard(
    _RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    // Keep current state while refreshing
    add(DashboardEvent.loadDashboardData(userId: event.userId));
  }
}
