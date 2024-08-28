import 'package:educhain/core/models/award.dart';
import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/award_bloc.dart';

class AwardDetailScreen extends StatelessWidget {
  static Route route(int awardId) => MaterialPageRoute(
        builder: (context) => AwardDetailScreen(awardId: awardId),
      );

  final int awardId;

  const AwardDetailScreen({Key? key, required this.awardId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AwardBloc>()..add(FetchAwardDetail(awardId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Award Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<AwardBloc, AwardState>(
          builder: (context, state) {
            if (state is AwardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AwardLoaded) {
              final award = state.award;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserSection(context, award),
                    const SizedBox(height: 24),
                    _buildDetailTile(
                      context,
                      title: 'Status',
                      value: award.status.toString().split('.').last,
                    ),
                    const SizedBox(height: 16.0),
                    _buildActionSection(context, award),
                  ],
                ),
              );
            } else if (state is AwardError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.redAccent),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<AwardBloc>()
                              .add(FetchAwardDetail(awardId));
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserSection(BuildContext context, Award award) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (award.userDto?.avatarPath != null)
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(award.userDto!.avatarPath!),
            backgroundColor: Colors.transparent,
          ),
        const SizedBox(height: 16),
        Text(
          'This award is issued to ${award.userDto?.firstName ?? 'User'}',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailTile(BuildContext context,
      {required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.black),
        ),
        subtitle: Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildActionSection(BuildContext context, Award award) {
    switch (award.status) {
      case AwardStatus.APPROVED:
        return ElevatedButton(
          onPressed: () {
            context.read<AwardBloc>().add(ReceiveAward(award.id ?? 0));
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Receive the award'),
        );
      case AwardStatus.RECEIVED:
        return _buildStatusText(
          context,
          'Award has already been received.',
          Colors.green,
        );
      case AwardStatus.REJECTED:
        return _buildStatusText(
          context,
          'Award has been rejected.',
          Colors.red,
        );
      case AwardStatus.PENDING:
        return _buildStatusText(
          context,
          'Award is pending, waiting teacher to approve.',
          Colors.orange,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStatusText(BuildContext context, String message, Color color) {
    return Text(
      message,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
      textAlign: TextAlign.center,
    );
  }
}
