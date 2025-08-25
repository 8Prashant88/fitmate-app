import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/workout.dart';
import '../../providers/workout_provider.dart';
import '../../providers/firestore_providers.dart';

class WorkoutsPage extends ConsumerWidget {
  const WorkoutsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutsStreamProvider);
    final fs = ref.watch(firestoreServiceProvider);

    return workouts.when(
      data: (list) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openForm(context, ref),
          label: const Text('Add Workout'),
          icon: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final w = list[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.fitness_center),
                title: Text('${w.type} • ${w.durationMin} min'),
                subtitle: Text('${w.calories} kcal • ${w.date.toLocal().toString().split(".").first}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'edit') _openForm(context, ref, existing: w);
                    if (v == 'delete') await fs?.deleteWorkout(w.id!);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  void _openForm(BuildContext context, WidgetRef ref, {Workout? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _WorkoutForm(existing: existing),
      ),
    );
  }
}

class _WorkoutForm extends ConsumerStatefulWidget {
  const _WorkoutForm({this.existing});
  final Workout? existing;

  @override
  ConsumerState<_WorkoutForm> createState() => _WorkoutFormState();
}

class _WorkoutFormState extends ConsumerState<_WorkoutForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _type;
  late TextEditingController _duration;
  late TextEditingController _calories;
  late TextEditingController _notes;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final w = widget.existing;
    _date = w?.date ?? DateTime.now();
    _type = TextEditingController(text: w?.type ?? 'Run');
    _duration = TextEditingController(text: w?.durationMin.toString() ?? '30');
    _calories = TextEditingController(text: w?.calories.toString() ?? '200');
    _notes = TextEditingController(text: w?.notes ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.read(uidProvider)!;
    final fs = ref.read(firestoreServiceProvider)!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('Date:'),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      initialDate: _date,
                    );
                    if (picked != null) setState(() => _date = picked);
                  },
                  child: Text(_date.toLocal().toString().split(' ').first),
                ),
              ],
            ),
            TextFormField(controller: _type, decoration: const InputDecoration(labelText: 'Type (e.g., Run, Yoga)')),
            TextFormField(controller: _duration, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Duration (min)')),
            TextFormField(controller: _calories, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Calories')),
            TextFormField(controller: _notes, decoration: const InputDecoration(labelText: 'Notes')),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                final w = Workout(
                  id: widget.existing?.id,
                  uid: uid,
                  date: _date,
                  type: _type.text.trim(),
                  durationMin: int.tryParse(_duration.text.trim()) ?? 0,
                  calories: int.tryParse(_calories.text.trim()) ?? 0,
                  notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
                );
                if (widget.existing == null) {
                  await fs.addWorkout(w);
                } else {
                  await fs.updateWorkout(w);
                }
                if (mounted) Navigator.pop(context);
              },
              child: Text(widget.existing == null ? 'Add' : 'Update'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
