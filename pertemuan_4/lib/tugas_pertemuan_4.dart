import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Catatan {
  final String judul;
  final String isi;
  final String kategori;
  final String email;
  final DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email,
    required this.dibuatPada,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/tambah':
            final arg = settings.arguments as Catatan?;
            return MaterialPageRoute(
              builder: (_) => TambahCatatanPage(catatanLama: arg),
            );
          case '/detail':
            final arg = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(
                catatan: arg['catatan'],
                index: arg['index'],
              ),
            );
        }
        return null;
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _filterKategori = 'Semua';
  final List<String> _filterOpsi = ['Semua', 'Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter Dasar',
      isi: 'Mempelajari Stateful Widget, Form validation, dan sistem Navigation Named Routes.',
      kategori: 'Kuliah',
      email: 'raihan@mhs.unpas.ac.id',
      dibuatPada: DateTime.now(),
    ),
    Catatan(
      judul: 'Projek Akhir Pemrograman',
      isi: 'Membuat aplikasi manajemen catatan dengan fitur filter dan edit.',
      kategori: 'Tugas',
      email: 'raihan@mhs.unpas.ac.id',
      dibuatPada: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Color _getKategoriColor(String kategori) {
    switch (kategori) {
      case 'Kuliah': return Colors.blue.shade600;
      case 'Tugas': return Colors.orange.shade700;
      case 'Pribadi': return Colors.green.shade600;
      default: return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final listDitampilkan = _filterKategori == 'Semua'
        ? _catatan
        : _catatan.where((c) => c.kategori == _filterKategori).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('My Notes', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButton<String>(
              value: _filterKategori,
              dropdownColor: Colors.blue.shade700,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              underline: const SizedBox(),
              icon: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.tune, size: 20, color: Colors.white),
              ),
              items: _filterOpsi.map((o) => DropdownMenuItem(
                value: o, 
                child: Text(o, style: const TextStyle(color: Colors.white))
              )).toList(),
              onChanged: (v) => setState(() => _filterKategori = v!),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text(
              'Kamu punya ${listDitampilkan.length} catatan',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ),
          Expanded(
            child: listDitampilkan.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('Belum ada catatan di sini', style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: listDitampilkan.length,
              itemBuilder: (context, i) {
                final c = listDitampilkan[i];
                final color = _getKategoriColor(c.kategori);
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () async {
                      final indexAsli = _catatan.indexOf(c);
                      final update = await Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: {'catatan': c, 'index': indexAsli},
                      );

                      if (update is Map) {
                        if (update['action'] == 'update') {
                          setState(() => _catatan[update['index']] = update['data']);
                        } else if (update['action'] == 'delete') {
                          setState(() => _catatan.removeAt(update['index']));
                        }
                      }
                    },
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 5,
                              height: 50,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.judul,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c.isi,
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          c.kategori,
                                          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${c.dibuatPada.day}/${c.dibuatPada.month}/${c.dibuatPada.year}',
                                        style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.grey.shade400),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final hasil = await Navigator.pushNamed(context, '/tambah');
          if (hasil is Catatan) {
            setState(() => _catatan.add(hasil));
          }
        },
        label: const Text('Catatan Baru'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class TambahCatatanPage extends StatefulWidget {
  final Catatan? catatanLama;
  const TambahCatatanPage({super.key, this.catatanLama});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulCtrl;
  late TextEditingController _isiCtrl;
  late TextEditingController _emailCtrl;
  late String _kategori;

  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _judulCtrl = TextEditingController(text: widget.catatanLama?.judul ?? '');
    _isiCtrl = TextEditingController(text: widget.catatanLama?.isi ?? '');
    _emailCtrl = TextEditingController(text: widget.catatanLama?.email ?? '');
    _kategori = widget.catatanLama?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    final data = Catatan(
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      email: _emailCtrl.text.trim(),
      dibuatPada: widget.catatanLama?.dibuatPada ?? DateTime.now(),
    );
    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.catatanLama != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEdit ? 'Ubah Catatan' : 'Catatan Baru', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _judulCtrl,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                labelText: 'Judul Catatan',
                hintText: 'Misal: Belajar Flutter',
                prefixIcon: Icon(Icons.edit_note),
              ),
              validator: (v) => (v == null || v.trim().length < 3) ? 'Minimal 3 karakter' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                hintText: 'nama@mhs.unpas.ac.id',
                prefixIcon: Icon(Icons.alternate_email),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email wajib diisi';
                final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!regex.hasMatch(v)) return 'Format email salah';
                return null;
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: _kategoriOpsi.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Isi Catatan',
                alignLabelWithHint: true,
                hintText: 'Tulis detail catatanmu di sini...',
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 55,
              child: FilledButton(
                onPressed: _simpan,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isEdit ? 'Simpan Perubahan' : 'Buat Catatan', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailCatatanPage extends StatefulWidget {
  final Catatan catatan;
  final int index;
  const DetailCatatanPage({super.key, required this.catatan, required this.index});

  @override
  State<DetailCatatanPage> createState() => _DetailCatatanPageState();
}

class _DetailCatatanPageState extends State<DetailCatatanPage> {
  late Catatan _currentCatatan;

  @override
  void initState() {
    super.initState();
    _currentCatatan = widget.catatan;
  }

  void _hapusCatatan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan?'),
        content: const Text('Tindakan ini tidak bisa dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, {'action': 'delete', 'index': widget.index});
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final hasil = await Navigator.pushNamed(context, '/tambah', arguments: _currentCatatan);
              if (hasil is Catatan) {
                setState(() => _currentCatatan = hasil);
                if (!context.mounted) return;
                Navigator.pop(context, {'action': 'update', 'index': widget.index, 'data': hasil});
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: _hapusCatatan,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _currentCatatan.kategori.toUpperCase(),
                style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _currentCatatan.judul,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.alternate_email, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(_currentCatatan.email, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Dibuat: ${_currentCatatan.dibuatPada.day}/${_currentCatatan.dibuatPada.month}/${_currentCatatan.dibuatPada.year}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(height: 1),
            ),
            Text(
              _currentCatatan.isi,
              style: const TextStyle(fontSize: 17, height: 1.6, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
