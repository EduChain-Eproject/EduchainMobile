import 'package:educhain/core/models/award.dart';
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
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(children: [
                  _buildDetailTile(
                    context,
                    title: 'Award ID',
                    value: award.id?.toString() ?? 'N/A',
                  ),
                  _buildDetailTile(
                    context,
                    title: 'Status',
                    value: award.status.toString().split('.').last,
                  ),
                  _buildDetailTile(
                    context,
                    title: 'Submission Date',
                    value: award.submissionDate != null
                        ? award.submissionDate.toString()
                        : 'N/A',
                  ),
                  _buildDetailTile(
                    context,
                    title: 'Review Date',
                    value: award.reviewDate != null
                        ? award.reviewDate.toString()
                        : 'N/A',
                  ),
                  _buildDetailTile(
                    context,
                    title: 'Comments',
                    value: award.comments ?? 'No Comments',
                  ),
                  const SizedBox(height: 16.0),
                  if (award.status == AwardStatus.APPROVED) ...[
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<AwardBloc>()
                            .add(ReceiveAward(award.id ?? 0));
                      },
                      child: const Text('Receive the award'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ] else if (award.status == AwardStatus.RECEIVED) ...[
                    Text(
                      'Award has already been received.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.green),
                    ),
                  ] else if (award.status == AwardStatus.REJECTED) ...[
                    Text(
                      'Award has been rejected.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.red),
                    ),
                  ] else if (award.status == AwardStatus.PENDING) ...[
                    Text(
                      'Award is still pending review.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.orange),
                    ),
                  ],
                ]),
              );
            } else if (state is AwardError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailTile(BuildContext context,
      {required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black),
        ),
        subtitle: Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.black),
        ),
      ),
    );
  }
}
