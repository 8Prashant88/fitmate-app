import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/mood_entry.dart';
import '../../providers/mood_provider.dart';
import '../../providers/firestore_providers.dart';

class MoodPage extends ConsumerWidget {
  const MoodPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moods = ref.watch(moodsStreamProvider);
    final fs = ref.watch(firestoreServiceProvider);

    return moods.when(
      data: (list) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openForm(context, ref),
          label: const Text('Add Mood'),
          icon: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final m = list[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.mood),
                title: Text(m.mood),
                subtitle: Text('${m.date.toLocal().toString().split(".").first}\n${m.note ?? ''}'),
                isThreeLine: m.note != null && m.note!.isNotEmpty,
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'edit') _openForm(context, ref, existing: m);
                    if (v == 'delete') await fs?.deleteMood(m.id!);
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

  void _openForm(BuildContext context, WidgetRef ref, {MoodEntry? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _MoodForm(existing: existing),
      ),
    );
  }
}

class _MoodForm extends ConsumerStatefulWidget {
  const _MoodForm({this.existing});
  final MoodEntry? existing;

  @override
  ConsumerState<_MoodForm> createState() => _MoodFormState();
}

class _MoodFormState extends ConsumerState<_MoodForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _mood;
  late TextEditingController _note;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final m = widget.existing;
    _date = m?.date ?? DateTime.now();
    _mood = TextEditingController(text: m?.mood ?? 'happy');
    _note = TextEditingController(text: m?.note ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.read(firestoreServiceProvider)!.uid;
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
            TextFormField(controller: _mood, decoration: const InputDecoration(labelText: 'Mood (happy/okay/stressed/tired)')),
            TextFormField(controller: _note, decoration: const InputDecoration(labelText: 'Note')),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                final m = MoodEntry(
                  id: widget.existing?.id,
                  uid: uid,
                  date: _date,
                  mood: _mood.text.trim(),
                  note: _note.text.trim().isEmpty ? null : _note.text.trim(),
                );
                if (widget.existing == null) {
                  await fs.addMood(m);
                } else {
                  await fs.updateMood(m);
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
