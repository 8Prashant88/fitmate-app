import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/meal.dart';
import '../../providers/meal_provider.dart';
import '../../providers/firestore_providers.dart';

class MealsPage extends ConsumerWidget {
  const MealsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals = ref.watch(mealsStreamProvider);
    final fs = ref.watch(firestoreServiceProvider);

    return meals.when(
      data: (list) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openForm(context, ref),
          label: const Text('Add Meal'),
          icon: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final m = list[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.restaurant),
                title: Text('${m.items.join(', ')} • ${m.calories} kcal'),
                subtitle: Text('Water: ${m.waterMl ?? 0}ml • ${m.date.toLocal().toString().split(".").first}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'edit') _openForm(context, ref, existing: m);
                    if (v == 'delete') await fs?.deleteMeal(m.id!);
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

  void _openForm(BuildContext context, WidgetRef ref, {Meal? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _MealForm(existing: existing),
      ),
    );
  }
}

class _MealForm extends ConsumerStatefulWidget {
  const _MealForm({this.existing});
  final Meal? existing;

  @override
  ConsumerState<_MealForm> createState() => _MealFormState();
}

class _MealFormState extends ConsumerState<_MealForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _items;
  late TextEditingController _calories;
  late TextEditingController _protein;
  late TextEditingController _carbs;
  late TextEditingController _fat;
  late TextEditingController _water;
  late TextEditingController _notes;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final m = widget.existing;
    _date = m?.date ?? DateTime.now();
    _items = TextEditingController(text: m?.items.join(', ') ?? '');
    _calories = TextEditingController(text: m?.calories.toString() ?? '500');
    _protein = TextEditingController(text: m?.protein?.toString() ?? '');
    _carbs = TextEditingController(text: m?.carbs?.toString() ?? '');
    _fat = TextEditingController(text: m?.fat?.toString() ?? '');
    _water = TextEditingController(text: m?.waterMl?.toString() ?? '');
    _notes = TextEditingController(text: m?.notes ?? '');
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
            TextFormField(controller: _items, decoration: const InputDecoration(labelText: 'Items (comma separated)')),
            TextFormField(controller: _calories, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Calories')),
            Row(
              children: [
                Expanded(child: TextFormField(controller: _protein, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Protein g'))),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(controller: _carbs, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Carbs g'))),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(controller: _fat, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Fat g'))),
              ],
            ),
            TextFormField(controller: _water, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Water (ml)')),
            TextFormField(controller: _notes, decoration: const InputDecoration(labelText: 'Notes')),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                final m = Meal(
                  id: widget.existing?.id,
                  uid: uid,
                  date: _date,
                  items: _items.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                  calories: int.tryParse(_calories.text.trim()) ?? 0,
                  protein: int.tryParse(_protein.text.trim()),
                  carbs: int.tryParse(_carbs.text.trim()),
                  fat: int.tryParse(_fat.text.trim()),
                  waterMl: int.tryParse(_water.text.trim()),
                  notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
                );
                if (widget.existing == null) {
                  await fs.addMeal(m);
                } else {
                  await fs.updateMeal(m);
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
