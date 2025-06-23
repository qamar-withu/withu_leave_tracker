import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:withu_leave_tracker/application/team_management/team_management_bloc.dart';

import 'package:withu_leave_tracker/domain/team_management/entities/team.dart';
import 'package:withu_leave_tracker/domain/team_management/entities/project.dart';
import 'package:withu_leave_tracker/domain/auth/value_objects/user_role.dart';
import 'package:withu_leave_tracker/domain/team_management/value_objects/project_status.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/custom_button.dart';
import 'package:withu_leave_tracker/presentation/core/widgets/custom_text_field.dart';
import 'package:withu_leave_tracker/core/constants/app_colors.dart';
import 'package:withu_leave_tracker/locator.dart';

class TeamManagementPage extends StatefulWidget {
  const TeamManagementPage({super.key});

  @override
  State<TeamManagementPage> createState() => _TeamManagementPageState();
}

class _TeamManagementPageState extends State<TeamManagementPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TeamManagementBloc _teamManagementBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _teamManagementBloc = getIt<TeamManagementBloc>();
    _loadInitialData();
  }

  void _loadInitialData() {
    _teamManagementBloc.add(const TeamManagementEvent.loadTeams());
    _teamManagementBloc.add(const TeamManagementEvent.loadProjects());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _teamManagementBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _teamManagementBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Team Management'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadInitialData,
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Teams'),
              Tab(text: 'Projects'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(24.w),
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Team Management',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Manage teams, projects, and team members',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildTeamsTab(), _buildProjectsTab()],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateDialog(),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTeamsTab() {
    return BlocBuilder<TeamManagementBloc, TeamManagementState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: Text('Loading teams...')),
          loading: () => const Center(child: CircularProgressIndicator()),
          teamsLoaded: (teams) {
            if (teams.isEmpty) {
              return _buildEmptyState(
                'No teams found',
                'Create your first team',
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(24.w),
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return _buildTeamCard(teams[index]);
              },
            );
          },
          projectsLoaded: (_) => const SizedBox(),
          teamMembersLoaded: (_) => const SizedBox(),
          submitting: () => const Center(child: CircularProgressIndicator()),
          submitted: () {
            _loadInitialData();
            return const Center(
              child: Text('Operation completed successfully'),
            );
          },
          error: (failure) =>
              _buildErrorState(failure.message ?? 'Unknown error'),
        );
      },
    );
  }

  Widget _buildProjectsTab() {
    return BlocBuilder<TeamManagementBloc, TeamManagementState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: Text('Loading projects...')),
          loading: () => const Center(child: CircularProgressIndicator()),
          teamsLoaded: (_) => const SizedBox(),
          projectsLoaded: (projects) {
            if (projects.isEmpty) {
              return _buildEmptyState(
                'No projects found',
                'Create your first project',
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(24.w),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return _buildProjectCard(projects[index]);
              },
            );
          },
          teamMembersLoaded: (_) => const SizedBox(),
          submitting: () => const Center(child: CircularProgressIndicator()),
          submitted: () {
            _loadInitialData();
            return const Center(
              child: Text('Operation completed successfully'),
            );
          },
          error: (failure) =>
              _buildErrorState(failure.message ?? 'Unknown error'),
        );
      },
    );
  }

  Widget _buildTeamCard(Team team) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  team.name.value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view_members',
                    child: Row(
                      children: [
                        Icon(Icons.people),
                        SizedBox(width: 8),
                        Text('View Members'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit Team'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: AppColors.error),
                        SizedBox(width: 8),
                        Text(
                          'Delete Team',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) => _handleTeamAction(value, team),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...[
            Text(
              team.description.value ?? 'No description',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 12.h),
          ],
          Row(
            children: [
              Icon(Icons.person, size: 16.w, color: AppColors.textSecondary),
              SizedBox(width: 4.w),
              Text(
                'Manager: ${team.managerId ?? 'Not assigned'}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                'Created: ${_formatDate(team.createdAt)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  project.name.value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    ProjectStatus.fromString(project.status.value),
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  _getStatusText(
                    ProjectStatus.fromString(project.status.value),
                  ),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(
                      ProjectStatus.fromString(project.status.value),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...[
            Text(
              project.description.value ?? 'No description',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 12.h),
          ],
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16.w,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 4.w),
              Text(
                'Start: ${_formatDate(project.startDate)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(width: 16.w),
              if (project.endDate != null) ...[
                Icon(Icons.event, size: 16.w, color: AppColors.textSecondary),
                SizedBox(width: 4.w),
                Text(
                  'End: ${_formatDate(project.endDate!)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off, size: 64.w, color: AppColors.textSecondary),
          SizedBox(height: 16.h),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.w, color: AppColors.error),
          SizedBox(height: 16.h),
          Text(
            'Error: $message',
            style: const TextStyle(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          CustomButton(text: 'Retry', onPressed: _loadInitialData),
        ],
      ),
    );
  }

  Color _getStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.active:
        return AppColors.success;
      case ProjectStatus.inactive:
        return AppColors.warning;
      case ProjectStatus.completed:
        return AppColors.info;
    }
  }

  String _getStatusText(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.active:
        return 'Active';
      case ProjectStatus.inactive:
        return 'Inactive';
      case ProjectStatus.completed:
        return 'Completed';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleTeamAction(String action, Team team) {
    switch (action) {
      case 'view_members':
        _viewTeamMembers(team);
        break;
      case 'edit':
        _editTeam(team);
        break;
      case 'delete':
        _deleteTeam(team);
        break;
    }
  }

  void _viewTeamMembers(Team team) {
    _teamManagementBloc.add(
      TeamManagementEvent.loadTeamMembers(teamId: team.id.value),
    );

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: _teamManagementBloc,
        child: AlertDialog(
          title: Text('${team.name} Members'),
          content: SizedBox(
            width: 300.w,
            height: 400.h,
            child: BlocBuilder<TeamManagementBloc, TeamManagementState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const Center(child: Text('Loading...')),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  teamsLoaded: (_) => const SizedBox(),
                  projectsLoaded: (_) => const SizedBox(),
                  teamMembersLoaded: (members) {
                    if (members.isEmpty) {
                      return const Center(child: Text('No members found'));
                    }
                    return ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(member.name[0].toUpperCase()),
                          ),
                          title: Text(member.name),
                          subtitle: Text(member.email.value),
                          trailing: Text(_getRoleText(member.role)),
                        );
                      },
                    );
                  },
                  submitting: () =>
                      const Center(child: CircularProgressIndicator()),
                  submitted: () => const SizedBox(),
                  error: (failure) =>
                      Center(child: Text('Error: ${failure.message}')),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _editTeam(Team team) {
    // Implementation for editing team
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit team functionality coming soon')),
    );
  }

  void _deleteTeam(Team team) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Team'),
        content: Text('Are you sure you want to delete "${team.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _teamManagementBloc.add(
                TeamManagementEvent.deleteTeam(teamId: team.id.value),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog() {
    final currentTab = _tabController.index;

    if (currentTab == 0) {
      _showCreateTeamDialog();
    } else {
      _showCreateProjectDialog();
    }
  }

  void _showCreateTeamDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Team'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: nameController,
              label: 'Team Name',
              hint: 'Enter team name',
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: descriptionController,
              label: 'Description',
              hint: 'Enter team description',
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.of(context).pop();
                // Create team logic would go here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Create team functionality coming soon'),
                  ),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showCreateProjectDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create project functionality coming soon')),
    );
  }

  String _getRoleText(UserRole role) {
    switch (role) {
      case UserRole.employee:
        return 'Employee';
      case UserRole.manager:
        return 'Manager';
      case UserRole.admin:
        return 'Admin';
      case UserRole.hr:
        return 'HR';
    }
  }
}
