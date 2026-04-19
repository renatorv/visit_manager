import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/visit.dart';
import '../../cubits/visit_cubit.dart';
import '../../cubits/visit_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VisitCubit>()..loadVisits(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Visitas'),
      ),
      body: BlocConsumer<VisitCubit, VisitState>(
        listener: (context, state) {
          if (state is VisitOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.primaryColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is VisitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is VisitLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }

          final visits = switch (state) {
            VisitLoaded(:final visits) => visits,
            VisitOperationSuccess(:final visits) => visits,
            _ => <Visit>[],
          };

          if (visits.isEmpty) {
            return const _EmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: visits.length,
            itemBuilder: (context, index) {
              return _VisitCard(visit: visits[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push(AppRouter.addVisit);
          if (context.mounted) {
            context.read<VisitCubit>().loadVisits();
          }
        },
        tooltip: 'Nova Visita',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: AppTheme.primaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'Nenhuma visita cadastrada',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Toque em + para adicionar uma visita',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _VisitCard extends StatelessWidget {
  final Visit visit;

  const _VisitCard({required this.visit});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  radius: 20,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visit.visitedPersonName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Visitante: ${visit.visitorName}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await context.push(AppRouter.editVisit, extra: visit);
                    if (context.mounted) {
                      context.read<VisitCubit>().loadVisits();
                    }
                  },
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Editar'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.calendar_today,
              text: 'Visita em: ${dateFormat.format(visit.visitDate)}',
            ),
            if (visit.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              _InfoRow(
                icon: Icons.notes,
                text: visit.description,
              ),
            ],
            if (visit.visitAgain && visit.nextVisitDate != null) ...[
              const SizedBox(height: 4),
              _InfoRow(
                icon: Icons.event_repeat,
                text:
                    'Próxima visita: ${dateFormat.format(visit.nextVisitDate!)}',
                color: AppTheme.primaryColor,
              ),
            ],
            if (visit.visitAgain &&
                visit.nextVisitReason != null &&
                visit.nextVisitReason!.isNotEmpty) ...[
              const SizedBox(height: 4),
              _InfoRow(
                icon: Icons.info_outline,
                text: 'Motivo: ${visit.nextVisitReason!}',
                color: AppTheme.primaryColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.text,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

