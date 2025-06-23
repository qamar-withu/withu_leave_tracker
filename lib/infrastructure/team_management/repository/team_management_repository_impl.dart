import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/domain/team_management/repository/team_management_repository.dart';
import 'package:withu_leave_tracker/domain/team_management/entities/team.dart';
import 'package:withu_leave_tracker/domain/team_management/entities/project.dart';
import 'package:withu_leave_tracker/domain/auth/entities/user.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';
import 'package:withu_leave_tracker/infrastructure/team_management/datasources/team_management_remote_data_source.dart';
import 'package:withu_leave_tracker/infrastructure/team_management/dto/team_dto.dart';
import 'package:withu_leave_tracker/infrastructure/team_management/dto/project_dto.dart';

@LazySingleton(as: TeamManagementRepository)
class TeamManagementRepositoryImpl implements TeamManagementRepository {
  final TeamManagementRemoteDataSource _remoteDataSource;

  TeamManagementRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Unit>> createTeam(Team team) async {
    try {
      final dto = TeamDto.fromDomain(team);
      await _remoteDataSource.createTeam(dto);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Team>>> getTeams() async {
    try {
      final teamDtos = await _remoteDataSource.getTeams();
      final teams = teamDtos.map((dto) => dto.toDomain()).toList();
      return Right(teams);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Team>>> getAllTeams() async {
    return getTeams();
  }

  @override
  Future<Either<Failure, Team>> getTeamById({required UniqueId teamId}) async {
    try {
      final teamDto = await _remoteDataSource.getTeamById(teamId.value);
      return Right(teamDto.toDomain());
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getTeamMembers({
    required UniqueId teamId,
  }) async {
    try {
      final userDtos = await _remoteDataSource.getTeamMembers(teamId.value);
      final users = userDtos.map((dto) => dto.toDomain()).toList();
      return Right(users);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTeam({
    required UniqueId teamId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _remoteDataSource.updateTeam(teamId.value, updates);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTeam({required UniqueId teamId}) async {
    try {
      await _remoteDataSource.deleteTeam(teamId.value);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createProject(Project project) async {
    try {
      final dto = ProjectDto.fromDomain(project);
      await _remoteDataSource.createProject(dto);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Project>>> getProjects() async {
    try {
      final projectDtos = await _remoteDataSource.getProjects();
      final projects = projectDtos.map((dto) => dto.toDomain()).toList();
      return Right(projects);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Project>>> getAllProjects() async {
    return getProjects();
  }

  @override
  Future<Either<Failure, Project>> getProjectById({
    required UniqueId projectId,
  }) async {
    try {
      final projectDto = await _remoteDataSource.getProjectById(
        projectId.value,
      );
      return Right(projectDto.toDomain());
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProject({
    required UniqueId projectId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _remoteDataSource.updateProject(projectId.value, updates);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProject({
    required UniqueId projectId,
  }) async {
    try {
      await _remoteDataSource.deleteProject(projectId.value);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addTeamMember({
    required UniqueId teamId,
    required UniqueId userId,
  }) async {
    try {
      await _remoteDataSource.addTeamMember(teamId.value, userId.value);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeTeamMember({
    required UniqueId teamId,
    required UniqueId userId,
  }) async {
    try {
      await _remoteDataSource.removeTeamMember(teamId.value, userId.value);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addMemberToTeam({
    required UniqueId teamId,
    required UniqueId userId,
  }) async {
    return addTeamMember(teamId: teamId, userId: userId);
  }

  @override
  Future<Either<Failure, Unit>> removeMemberFromTeam({
    required UniqueId teamId,
    required UniqueId userId,
  }) async {
    return removeTeamMember(teamId: teamId, userId: userId);
  }

  @override
  Stream<Either<Failure, List<Team>>> watchTeams() {
    // For now, return a simple implementation
    // In a real app, you might want to use Firestore snapshots for real-time updates
    return Stream.periodic(const Duration(seconds: 5), (_) async {
      final result = await getTeams();
      return result;
    }).asyncMap((futureResult) => futureResult);
  }

  @override
  Stream<Either<Failure, List<Project>>> watchProjects() {
    // For now, return a simple implementation
    // In a real app, you might want to use Firestore snapshots for real-time updates
    return Stream.periodic(const Duration(seconds: 5), (_) async {
      final result = await getProjects();
      return result;
    }).asyncMap((futureResult) => futureResult);
  }
}
