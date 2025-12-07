import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetNamePage extends StatefulWidget {
  const SetNamePage({super.key});

  @override
  State<SetNamePage> createState() => _SetNamePageState();
}

class _SetNamePageState extends State<SetNamePage> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _locationCtrl = TextEditingController();
  String? _gender;
  DateTime? _birthday;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSavedProfile();
  }

  Future<void> _loadSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('profile_name');
    final gender = prefs.getString('profile_gender');
    final birthdayStr = prefs.getString('profile_birthday');
    final location = prefs.getString('profile_location');
    setState(() {
      if (name != null) _nameCtrl.text = name;
      if (location != null) _locationCtrl.text = location;
      _gender = gender;
      if (birthdayStr != null) {
        try {
          _birthday = DateTime.parse(birthdayStr);
        } catch (_) {
          _birthday = null;
        }
      }
    });
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(now.year - 25),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFFE8F8EC), Color(0xFFF2F6F3)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // centered avatar
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    height: 96,
                    width: 96,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: const Icon(Icons.person, size: 44, color: Colors.black54),
                  ),
                ),

                const SizedBox(height: 18),

                // Name (label + input)
                _roundedField(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 96,
                          padding: const EdgeInsets.only(left: 8.0),
                          child: const Text('Name', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _nameCtrl,
                            decoration: const InputDecoration(
                              hintText: 'Set name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Gender (label + dropdown) — match Name height
                _roundedField(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 96,
                          padding: const EdgeInsets.only(left: 8.0),
                          child: const Text('Gender', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: DropdownButtonFormField<String>(
                              value: _gender,
                              decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12)),
                              hint: const Text('Select', style: TextStyle(color: Colors.black54)),
                              items: const [
                                DropdownMenuItem(value: 'male', child: Text('Male')),
                                DropdownMenuItem(value: 'female', child: Text('Female')),
                                DropdownMenuItem(value: 'other', child: Text('Other')),
                              ],
                              onChanged: (v) => setState(() => _gender = v),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Birthday (label + picker)
                _roundedField(
                  child: InkWell(
                    onTap: _pickBirthday,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 96,
                            padding: const EdgeInsets.only(left: 8.0),
                            child: const Text('Birthday', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _birthday == null ? 'Select date' : '${_birthday!.year}-${_birthday!.month.toString().padLeft(2, '0')}-${_birthday!.day.toString().padLeft(2, '0')}',
                                  style: TextStyle(color: _birthday == null ? Colors.black54 : Colors.black87),
                                ),
                                const Icon(Icons.calendar_today_outlined, color: Colors.black54),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Location (label + input)
                _roundedField(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 96,
                          padding: const EdgeInsets.only(left: 8.0),
                          child: const Text('Location', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _locationCtrl,
                            decoration: const InputDecoration(
                              hintText: 'Enter location',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final name = _nameCtrl.text.trim();
                      final location = _locationCtrl.text.trim();
                      if (name.isEmpty || _gender == null || _birthday == null || location.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields before saving')));
                        return;
                      }
                      // persist
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('profile_name', name);
                      if (_gender != null) await prefs.setString('profile_gender', _gender!);
                      if (_birthday != null) await prefs.setString('profile_birthday', _birthday!.toIso8601String());
                      await prefs.setString('profile_location', location);

                      final result = {
                        'name': name,
                        'gender': _gender,
                        'birthday': _birthday?.toIso8601String(),
                        'location': location,
                      };
                      if (!mounted) return;
                      Navigator.of(context).pop(result);
                    },
                    child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _roundedField({required Widget child}) {
  return Material(
    color: Colors.white,
    elevation: 2,
    borderRadius: BorderRadius.circular(28),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: child,
      ),
    ),
  );
}
