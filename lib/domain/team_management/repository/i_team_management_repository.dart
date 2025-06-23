import 'package:dartz/dartz.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';
import 'package:withu_leave_tracker/domain/team_management/entities/team.dart';
import 'package:withu_leave_tracker/domain/team_management/entities/project.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';
import 'package:withu_leave_tracker/domain/auth/entities/user.dart';

abstract class ITeamManagementRepository {
  // Team operations
  Future<Either<Failure, Unit>> createTeam(Team team);

  Future<Either<Failure, List<Team>>> getAllTeams();

  Future<Either<Failure, Team>> getTeamById({required UniqueId teamId});

  Future<Either<Failure, List<User>>> getTeamMembers({
    required UniqueId teamId,
  });

  Future<Either<Failure, Unit>> updateTeam({
    required UniqueId teamId,
    required Map<String, dynamic> updates,
  });

  Future<Either<Failure, Unit>> deleteTeam({required UniqueId teamId});

  // Project operations
  Future<Either<Failure, Unit>> createProject(Project project);

  Future<Either<Failure, List<Project>>> getAllProjects();

  Future<Either<Failure, Project>> getProjectById({
    required UniqueId projectId,
  });

  Future<Either<Failure, Unit>> updateProject({
    required UniqueId projectId,
    required Map<String, dynamic> updates,
  });

  Future<Either<Failure, Unit>> deleteProject({required UniqueId projectId});

  // Team member management
  Future<Either<Failure, Unit>> addMemberToTeam({
    required UniqueId teamId,
    required UniqueId userId,
  });

  Future<Either<Failure, Unit>> removeMemberFromTeam({
    required UniqueId teamId,
    required UniqueId userId,
  });

  Stream<Either<Failure, List<Team>>> watchTeams();
  Stream<Either<Failure, List<Project>>> watchProjects();
}
