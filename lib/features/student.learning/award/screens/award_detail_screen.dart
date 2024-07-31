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
                child: ListView(
                  children: [
                    Text('Award ID: ${award.id ?? 'N/A'}',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text('Status: ${award.status.toString().split('.').last}',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(
                        'Submission Date: ${award.submissionDate?.toLocal() ?? 'N/A'}',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text('Review Date: ${award.reviewDate?.toLocal() ?? 'N/A'}',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text('Comments: ${award.comments ?? 'No Comments'}',
                        style: Theme.of(context).textTheme.bodyMedium),
                    ElevatedButton(
                        onPressed: () {
                          // TODO: handle receive an award if possible
                        },
                        child: const Text('Receive the award'))
                  ],
                ),
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
}
