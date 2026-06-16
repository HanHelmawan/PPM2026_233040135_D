import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'screens/gallery_home.dart';
import 'widget/profile_helpers.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizProfilePage(),
    );
  }
}


// === Models ===

class ProfileData {
  String avatarImage; // URL or local path
  String name;
  String role;
  String about;
  String education;
  String location;
  String contact;
  List<String> skills;

  ProfileData({
    required this.avatarImage,
    required this.name,
    required this.role,
    required this.about,
    required this.education,
    required this.location,
    required this.contact,
    required this.skills,
  });

  ProfileData copy() {
    return ProfileData(
      avatarImage: avatarImage,
      name: name,
      role: role,
      about: about,
      education: education,
      location: location,
      contact: contact,
      skills: List.from(skills),
    );
  }
}

class ExperienceItem {
  String imagePath; // URL or local path
  String title;
  String description;

  ExperienceItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

// === Helper Widget for Image Display ===

Widget buildImageWidget(String path, {double? width, double? height, BoxFit fit = BoxFit.cover, Widget? fallback}) {
  if (path.isEmpty) {
    return fallback ?? const Icon(Icons.image, size: 50, color: Colors.grey);
  }
  
  if (kIsWeb || path.startsWith('http') || path.startsWith('https') || path.startsWith('blob:')) {
    return Image.network(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return fallback ?? const Icon(Icons.broken_image, size: 50, color: Colors.grey);
      },
    );
  } else {
    try {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return fallback ?? const Icon(Icons.broken_image, size: 50, color: Colors.grey);
          },
        );
      }
    } catch (_) {}
    return fallback ?? const Icon(Icons.broken_image, size: 50, color: Colors.grey);
  }
}

// === Preset Images List for Image Selection Helper Dialog ===

final List<String> presetAvatars = [
  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=250&q=80', // Male 1
  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=250&q=80', // Female 1
  'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=250&q=80', // Male 2
  'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=250&q=80', // Female 2
  'https://avatars.githubusercontent.com/u/108425234?v=4', // Raihan Azzani
];

final List<String> presetExperiences = [
  'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?auto=format&fit=crop&w=500&q=80', // Mobile app
  'https://images.unsplash.com/photo-1547082299-de196ea013d6?auto=format&fit=crop&w=500&q=80', // Web dev
  'https://images.unsplash.com/photo-1517055720730-0d53ffd24def?auto=format&fit=crop&w=500&q=80', // IoT
  'https://images.unsplash.com/photo-1581291518633-83b4ebd1d83e?auto=format&fit=crop&w=500&q=80', // UI/UX
];

// Dialog to Choose between Camera, Presets, or URL input
void showImagePickerDialog({
  required BuildContext context,
  required bool isAvatar,
  required Function(String) onImageSelected,
}) {
  final urlController = TextEditingController();
  final presets = isAvatar ? presetAvatars : presetExperiences;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isAvatar ? 'Pilih Foto Profil' : 'Pilih Gambar Pengalaman',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Gallery Option
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE8EAF6),
                child: Icon(Icons.photo_library, color: Color(0xFF535182)),
              ),
              title: const Text('Ambil dari Galeri HP'),
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                try {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,
                  );
                  if (pickedFile != null) {
                    onImageSelected(pickedFile.path);
                  }
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Gagal mengambil gambar: $e')),
                  );
                }
              },
            ),
            const Divider(),
            const SizedBox(height: 8),
            // URL Input Option
            const Text(
              'Atau masukkan URL Gambar:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: 'https://example.com/image.jpg',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (urlController.text.trim().isNotEmpty) {
                      final url = urlController.text.trim();
                      Navigator.pop(context);
                      onImageSelected(url);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF535182),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Gunakan'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            // Presets Option
            const Text(
              'Atau gunakan Pilihan Preset Indah:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: presets.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final imgUrl = presets[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onImageSelected(imgUrl);
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: buildImageWidget(
                          imgUrl,
                          width: 70,
                          height: 70,
                          fallback: const Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

// === Custom Section Card supporting Widgets as children ===

class CustomSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const CustomSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF535182), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === Main Profile Page ===

class QuizProfilePage extends StatefulWidget {
  const QuizProfilePage({super.key});

  @override
  State<QuizProfilePage> createState() => _QuizProfilePageState();
}

class _QuizProfilePageState extends State<QuizProfilePage> {
  // Profile state initialization
  late ProfileData profileData;
  
  // Experiences state initialization
  final List<ExperienceItem> experiences = [];

  @override
  void initState() {
    super.initState();
    profileData = ProfileData(
      avatarImage: 'https://avatars.githubusercontent.com/u/108425234?v=4',
      name: 'Raihan Azzani Helmawan',
      role: 'Mahasiswa Teknik Informatika',
      about: 'Saya suka belajar hal baru, terutama yang berkaitan dengan teknologi, Internet of Things (IoT), dan pengembangan aplikasi mobile.',
      education: 'Universitas Pasundan\nTeknik Informatika\nSemester 6',
      location: 'Bandung, Jawa Barat',
      contact: 'raihanazzani@unpas.ac.id\n+62 812-3456-7890',
      skills: ['Flutter', 'Dart', 'IoT (ESP32)', 'Unity', 'LMMS'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // Drawer Header with Purple Gradient
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF7C7BAD), Color(0xFF535182)],
                ),
              ),
              child: Container(
                alignment: Alignment.bottomLeft,
                width: double.infinity,
                child: const Text(
                  'Menu Utama',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF535182)),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.widgets, color: Color(0xFF535182)),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GalleryHome()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_upload, color: Color(0xFF535182)),
              title: const Text('Upload Pengalaman'),
              onTap: () async {
                Navigator.pop(context); // Close drawer
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadExperiencePage(),
                  ),
                );
                if (result != null && result is ExperienceItem) {
                  setState(() {
                    experiences.add(result);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF535182)),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context); // Close drawer
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
      // Soft purple/blueish to off-white gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8EAF6), Color(0xFFF5F5F7)],
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
                    const SizedBox(height: 12),
                    // Circular Avatar with profile image
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ClipOval(
                        child: buildImageWidget(
                          profileData.avatarImage,
                          width: 96,
                          height: 96,
                          fallback: const Icon(Icons.person, size: 50, color: Color(0xFF535182)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profileData.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profileData.role,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
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

              // === SECTION CARDS ===

              // Tentang Saya
              CustomSectionCard(
                icon: Icons.info_outline,
                title: 'Tentang Saya',
                child: Text(
                  profileData.about,
                  style: const TextStyle(height: 1.4, color: Colors.black87),
                ),
              ),

              // Pendidikan
              CustomSectionCard(
                icon: Icons.school_outlined,
                title: 'Pendidikan',
                child: Text(
                  profileData.education,
                  style: const TextStyle(height: 1.4, color: Colors.black87),
                ),
              ),

              // Lokasi
              CustomSectionCard(
                icon: Icons.location_on_outlined,
                title: 'Lokasi',
                child: Text(
                  profileData.location,
                  style: const TextStyle(height: 1.4, color: Colors.black87),
                ),
              ),

              // Kontak
              CustomSectionCard(
                icon: Icons.email_outlined,
                title: 'Kontak',
                child: Text(
                  profileData.contact,
                  style: const TextStyle(height: 1.4, color: Colors.black87),
                ),
              ),

              // Skills
              CustomSectionCard(
                icon: Icons.star_border,
                title: 'Skills',
                child: profileData.skills.isEmpty
                    ? const Text('Belum ada skill yang ditambahkan', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))
                    : Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: profileData.skills.map((skill) {
                          return Chip(
                            label: Text(skill, style: const TextStyle(color: Colors.black87)),
                            backgroundColor: const Color(0xFFE8EAF6),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          );
                        }).toList(),
                      ),
              ),

              // BONUS: Pengalaman Card
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.work_outline, color: Color(0xFF535182), size: 28),
                              SizedBox(width: 16),
                              Text(
                                'Pengalaman',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          // Badge count
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8EAF6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${experiences.length}',
                              style: const TextStyle(
                                color: Color(0xFF535182),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      experiences.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  'Belum ada pengalaman kerja / proyek.',
                                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                                ),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: experiences.length,
                              separatorBuilder: (context, index) => const Divider(height: 24),
                              itemBuilder: (context, index) {
                                final exp = experiences[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: buildImageWidget(
                                        exp.imagePath,
                                        width: 60,
                                        height: 60,
                                        fallback: const Icon(Icons.work, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    exp.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  subtitle: Text(
                                    exp.description,
                                    style: TextStyle(color: Colors.grey.shade600, height: 1.3),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: const Icon(Icons.edit_outlined, size: 20),
                                  onTap: () async {
                                    // Open experience in edit mode
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UploadExperiencePage(
                                          experienceItem: exp,
                                        ),
                                      ),
                                    );
                                    if (result != null) {
                                      if (result is ExperienceItem) {
                                        setState(() {
                                          experiences[index] = result;
                                        });
                                      } else if (result == 'delete') {
                                        setState(() {
                                          experiences.removeAt(index);
                                        });
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80), // Space to not cover under FAB
            ],
          ),
        ),
      ),
      
      // Floating Action Button to Edit Profile
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfilePage(profileData: profileData.copy()),
            ),
          );
          if (result != null && result is ProfileData) {
            setState(() {
              profileData = result;
            });
          }
        },
        backgroundColor: const Color(0xFFE8EAF6),
        foregroundColor: const Color(0xFF535182),
        icon: const Icon(Icons.edit),
        label: const Text('Edit Profil', style: TextStyle(fontWeight: FontWeight.bold)),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 1, // Focused on Profile
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

// === Edit Profile Page ===

class EditProfilePage extends StatefulWidget {
  final ProfileData profileData;

  const EditProfilePage({super.key, required this.profileData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _aboutController;
  late TextEditingController _educationController;
  late TextEditingController _locationController;
  late TextEditingController _contactController;
  late TextEditingController _skillsController;
  late String _avatarImage;

  @override
  void initState() {
    super.initState();
    final data = widget.profileData;
    _nameController = TextEditingController(text: data.name);
    _roleController = TextEditingController(text: data.role);
    _aboutController = TextEditingController(text: data.about);
    _educationController = TextEditingController(text: data.education);
    _locationController = TextEditingController(text: data.location);
    _contactController = TextEditingController(text: data.contact);
    _skillsController = TextEditingController(text: data.skills.join(', '));
    _avatarImage = data.avatarImage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _aboutController.dispose();
    _educationController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Split skills by commas
      final List<String> parsedSkills = _skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final updatedData = ProfileData(
        avatarImage: _avatarImage,
        name: _nameController.text.trim(),
        role: _roleController.text.trim(),
        about: _aboutController.text.trim(),
        education: _educationController.text.trim(),
        location: _locationController.text.trim(),
        contact: _contactController.text.trim(),
        skills: parsedSkills,
      );

      Navigator.pop(context, updatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        actions: [
          TextButton.icon(
            onPressed: _saveChanges,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF535182),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Photo Selector
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Foto Profil',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        showImagePickerDialog(
                          context: context,
                          isAvatar: true,
                          onImageSelected: (path) {
                            setState(() {
                              _avatarImage = path;
                            });
                          },
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade200,
                              child: ClipOval(
                                child: buildImageWidget(
                                  _avatarImage,
                                  width: 100,
                                  height: 100,
                                  fallback: const Icon(Icons.person, size: 50, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF535182),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        showImagePickerDialog(
                          context: context,
                          isAvatar: true,
                          onImageSelected: (path) {
                            setState(() {
                              _avatarImage = path;
                            });
                          },
                        );
                      },
                      icon: const Icon(Icons.photo_library, size: 16),
                      label: const Text('Ganti Foto dari Galeri'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF535182),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Informasi Profil',
                style: TextStyle(color: Color(0xFF535182), fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Form fields
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap *',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama lengkap wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(
                  labelText: 'Pekerjaan / Jabatan',
                  prefixIcon: Icon(Icons.work_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _aboutController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Bio / Tentang',
                  prefixIcon: Icon(Icons.info_outline),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _educationController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Pendidikan',
                  prefixIcon: Icon(Icons.school_outlined),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _contactController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Kontak',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(
                  labelText: 'Skills (pisahkan dengan koma)',
                  prefixIcon: Icon(Icons.star_border),
                  border: OutlineInputBorder(),
                  hintText: 'Flutter, Dart, IoT',
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton.icon(
                onPressed: _saveChanges,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF535182),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === Upload / Edit Experience Page ===

class UploadExperiencePage extends StatefulWidget {
  final ExperienceItem? experienceItem;

  const UploadExperiencePage({super.key, this.experienceItem});

  @override
  State<UploadExperiencePage> createState() => _UploadExperiencePageState();
}

class _UploadExperiencePageState extends State<UploadExperiencePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _imagePath;

  bool get isEditMode => widget.experienceItem != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.experienceItem?.title ?? '');
    _descController = TextEditingController(text: widget.experienceItem?.description ?? '');
    _imagePath = widget.experienceItem?.imagePath ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveExperience() {
    if (_formKey.currentState!.validate()) {
      if (_imagePath.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan pilih gambar pengalaman terlebih dahulu')),
        );
        return;
      }
      final item = ExperienceItem(
        imagePath: _imagePath,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
      );
      Navigator.pop(context, item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Pengalaman' : 'Upload Pengalaman'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        actions: [
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Hapus Pengalaman'),
                    content: const Text('Apakah Anda yakin ingin menghapus pengalaman ini?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Tutup dialog
                          Navigator.pop(context, 'delete'); // Pop page dengan return 'delete'
                        },
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Hapus'),
                      ),
                    ],
                  ),
                );
              },
            ),
          TextButton.icon(
            onPressed: _saveExperience,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF535182),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Experience Image Picker Box
              GestureDetector(
                onTap: () {
                  showImagePickerDialog(
                    context: context,
                    isAvatar: false,
                    onImageSelected: (path) {
                      setState(() {
                        _imagePath = path;
                      });
                    },
                  );
                },
                child: _imagePath.isEmpty
                    ? Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F2FB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: const Color(0xFF7C7BAD).withOpacity(0.5),
                            width: 1.5,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_photo_alternate_outlined, size: 48, color: Color(0xFF535182)),
                            SizedBox(height: 12),
                            Text(
                              'Ketuk untuk pilih gambar',
                              style: TextStyle(
                                color: Color(0xFF535182),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'dari galeri perangkat atau preset',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: buildImageWidget(_imagePath, fit: BoxFit.cover),
                            ),
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  // ignore: deprecated_member_use
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.edit, color: Colors.white, size: 14),
                                    SizedBox(width: 4),
                                    Text('Ganti Gambar', style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Informasi Pengalaman',
                style: TextStyle(color: Color(0xFF535182), fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul *',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton.icon(
                onPressed: _saveExperience,
                icon: const Icon(Icons.save),
                label: Text(
                  isEditMode ? 'Simpan Perubahan' : 'Simpan Pengalaman',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF535182),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
