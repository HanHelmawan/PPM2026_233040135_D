import 'package:flutter/material.dart';
import 'screens/gallery_home.dart';
import 'widget/profile_helpers.dart';
import 'quiz_pertemuan3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GalleryHome()),
                );
              },
            ),
            // TUGAS MANDIRI 5: AlertDialog Placeholder saat Pengaturan ditekan
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer terlebih dahulu
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pengaturan'),
                    content: const Text('Fitur pengaturan belum tersedia.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // TUGAS MANDIRI 2: Mengubah tema warna Scaffold menjadi Gradien Soft Blue ke Putih
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F2FE), Color(0xFFF8FAFC)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // === HEADER PROFIL ===
              Center(
                child: Column(
                  children: [
                    // TUGAS MANDIRI 1: Menggunakan NetworkImage dari Avatar GitHub Anda
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade100,
                      backgroundImage: const NetworkImage('https://avatars.githubusercontent.com/u/108425234?v=4'),
                      onBackgroundImageError: (exception, stackTrace) {
                        debugPrint('Error loading profile image: $exception');
                      },
                      child: const Icon(Icons.person, size: 50, color: Colors.blue),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Raihan Azzani Helmawan',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mahasiswa Teknik Informatika',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              // === BARIS STATISTIK ===
              Row(
                children: const [
                  Expanded(child: StatBox(label: 'Post', value: '12')),
                  Expanded(child: StatBox(label: 'Teman', value: '128')),
                  Expanded(child: StatBox(label: 'Like', value: '1.2K')),
                ],
              ),
              const SizedBox(height: 24),
              // === SECTION CARD ===
              const SectionCard(
                icon: Icons.info_outline,
                title: 'Tentang Saya',
                content: 'Saya suka belajar hal baru, terutama yang berkaitan dengan teknologi, Internet of Things (IoT), dan pengembangan aplikasi mobile.',
              ),
              const SectionCard(
                icon: Icons.school,
                title: 'Pendidikan',
                content: 'Universitas Pasundan\nTeknik Informatika\nSemester 6',
              ),
              const SectionCard(
                icon: Icons.favorite,
                title: 'Hobi & Minat',
                content: 'Coding, Game Development, IoT Projects, Music Production',
              ),
              const SectionCard(
                icon: Icons.email,
                title: 'Kontak',
                content: 'raihanazzani@unpas.ac.id\n+62 812-3456-7890',
              ),
              // TUGAS MANDIRI 3: Menambahkan Section Card ke-5 berjudul "Skills" dengan Wrap & 5 Chip
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.star, color: Colors.blue, size: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Skills', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: const [
                                Chip(label: Text('Flutter')),
                                Chip(label: Text('Dart')),
                                Chip(label: Text('IoT (ESP32)')),
                                Chip(label: Text('Unity')),
                                Chip(label: Text('LMMS')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80), // Ruang pengaman agar tidak tertutup FAB
            ],
          ),
        ),
      ),
      // TUGAS MANDIRI 4: Menampilkan SnackBar saat FAB ditekan
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit profil belum tersedia')),
          );
        },
        child: const Icon(Icons.edit),
      ),
      // TUGAS MANDIRI 6 (Bonus): Mengganti BottomNavigationBar menjadi NavigationBar (Material 3)
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1, // Fokus aktif pada item kedua ('Profil')
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Pesan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        onDestinationSelected: (int index) {},
      ),
    );
  }
}