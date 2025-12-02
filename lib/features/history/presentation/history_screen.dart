import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ppt_generator/core/constants/app_routes.dart';
import 'package:ppt_generator/features/history/presentation/bloc/history_bloc.dart';
import 'package:ppt_generator/features/history/presentation/bloc/history_event.dart';
import 'package:ppt_generator/features/history/presentation/bloc/history_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(FetchHistoryRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is HistoryLoaded) {
            if (state.history.isEmpty) {
              return const Center(child: Text('No history found'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.history.length,
              itemBuilder: (context, index) {
                final item = state.history[index];
                final date = DateFormat.yMMMd().add_jm().format(item.createdAt);
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      item.topic,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Created: $date',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Slides: ${item.slideCount}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: item.resultSuccess && item.resultUrl != null
                        ? IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.ppt_viewer_screen,
                                arguments: item.resultUrl,
                              );
                            },
                          )
                        : const Icon(Icons.error_outline, color: Colors.red),
                    onTap: item.resultSuccess && item.resultUrl != null
                        ? () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.ppt_viewer_screen,
                              arguments: item.resultUrl,
                            );
                          }
                        : null,
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
