import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String name;
  const CategoryPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (name) {
      case 'Display':
        body = const DisplayDemo();
        break;
      case 'Input':
        body = const InputDemo();
        break;
    // Kategori lain bisa ditambahkan di sini nanti
      default:
        body = const Center(child: Text('Demo belum tersedia'));
    }

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
    );
  }
}

// === DEMO DISPLAY ===
class DisplayDemo extends StatelessWidget {
  const DisplayDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Card', style: TextStyle(fontWeight: FontWeight.bold)),
        const Card(
          child: ListTile(
            leading: Icon(Icons.album),
            title: Text('Judul Item'),
            subtitle: Text('Sub-judul'),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Chip', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: const [
            Chip(label: Text('Flutter')),
            Chip(label: Text('Dart')),
            Chip(label: Text('Mobile')),
          ],
        ),
      ],
    );
  }
}

// === DEMO INPUT ===
class InputDemo extends StatefulWidget {
  const InputDemo({super.key});

  @override
  State<InputDemo> createState() => _InputDemoState();
}

class _InputDemoState extends State<InputDemo> {
  bool _checked = false;
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nama',
            hintText: 'Ketik nama Anda',
          ),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Setujui Syarat'),
          value: _checked,
          onChanged: (v) => setState(() => _checked = v ?? false),
        ),
        const SizedBox(height: 16),
        const Text('Slider'),
        Slider(
          value: _sliderValue,
          onChanged: (v) => setState(() => _sliderValue = v),
        ),
      ],
    );
  }
}