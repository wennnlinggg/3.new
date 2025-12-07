import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'profile_page.dart';

void main() {
  runApp(const MyApp());
}

class LoggedInHomePage extends StatelessWidget {
  const LoggedInHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [Colors.green.shade100, Colors.green.shade50.withAlpha(153)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    Widget imageCard(String title, Color color, {String? assetName, VoidCallback? onTap}) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // image area
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: assetName != null
                      ? Image.asset(
                          'assets/images/$assetName',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: color),
                        )
                      : Container(color: color),
                ),
              ),

              // title bar under the image
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.centerLeft,
                child: Text(title, style: const TextStyle(color: Colors.black87, fontSize: 16)),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Container(
          decoration: BoxDecoration(gradient: gradient),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text('Eco Plug', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28, color: Colors.green[900])),
                const SizedBox(height: 12),
                imageCard('Net Zero', Colors.pink.shade300, assetName: 'a.png', onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Net Zero (placeholder)'))); }),
                imageCard('Eco Plug', Colors.green.shade300, assetName: 'b.png', onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Eco Plug (placeholder)'))); }),
                imageCard('Tips & Tricks', Colors.blueGrey.shade300, assetName: 'd.png', onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tips & Tricks (placeholder)'))); }),
                imageCard('Learn How You Can Help', Colors.teal.shade300, assetName: 'c.png', onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Learn (placeholder)'))); }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        // NOTE: bottom navigation is provided by the outer RootShell scaffold.
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Layout',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade700),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      // Use the RootShell as the app home so bottom navigation is available.
      home: const RootShell(),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key, this.initialIndex = 2});
  final int initialIndex;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onNavTap(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final tabs = <Widget>[
      const LoggedInHomePage(),
      const EnergyPage(),
      const ProfilePage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: tabs[_selectedIndex],
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        notchMargin: 6,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                selected: _selectedIndex == 0,
                onTap: () => _onNavTap(0),
              ),
              _NavItem(
                icon: Icons.bolt_outlined,
                selected: _selectedIndex == 1,
                onTap: () => _onNavTap(1),
              ),
              const SizedBox(width: 56), // space for FAB if any
              _NavItem(
                icon: Icons.person_outline,
                selected: _selectedIndex == 2,
                onTap: () => _onNavTap(2),
              ),
              _NavItem(
                icon: Icons.more_horiz,
                selected: _selectedIndex == 3,
                onTap: () => _onNavTap(3),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.onTap, this.selected = false});
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Icon(
          icon,
          size: selected ? 28 : 22,
          color: selected ? Theme.of(context).colorScheme.primary : Colors.black54,
        ),
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget({required this.label, super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(label));
  }
}

class EnergyPage extends StatelessWidget {
  const EnergyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Energy'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.bolt, size: 80, color: Colors.green),
              SizedBox(height: 12),
              Text('Energy page (temporary)', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: BackButton(),
              ),
            ),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.assignment_outlined, size: 120, color: Colors.black26),
                    SizedBox(height: 12),
                    Text('Nothing here yet', style: TextStyle(color: Colors.black45)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [Colors.green.shade100, Colors.green.shade50.withAlpha(153)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header with gradient and title
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: gradient,
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: [
                    Text('Eco Plug', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28, color: Colors.green[900])),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ManageProfilePage())),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, size: 28, color: Colors.grey[700]),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ManageProfilePage())),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Set name', style: TextStyle(fontSize: 16)),
                                Icon(Icons.chevron_right, color: Colors.grey[600]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Replace cards with a LoginCard that mirrors the attached design
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    LoginCard(),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// _SmallCard and _LargeCard were removed because they are no longer used.

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class ManageProfilePage extends StatelessWidget {
  const ManageProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [Colors.green.shade100, Colors.green.shade50.withAlpha(153)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Manage Profile', style: TextStyle(color: Colors.black)),
        leading: const BackButton(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              // big avatar
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.black12, width: 2),
                  ),
                  child: const Icon(Icons.person, size: 64, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: const [
                    _FormRow(label: 'Name'),
                    SizedBox(height: 12),
                    _FormRow(label: 'Gender'),
                    SizedBox(height: 12),
                    _FormRow(label: 'Birthday', trailingIcon: Icons.calendar_today),
                    SizedBox(height: 12),
                    _FormRow(label: 'Location'),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({super.key, required this.label, this.trailingIcon});
  final String label;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 16)),
              if (trailingIcon != null) Icon(trailingIcon, color: Colors.grey[600]) else const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginCardState extends State<LoginCard> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _remember = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // centered logo
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: Colors.green[400], borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.bolt, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 12),
            const Text('Hi, Welcome Back! 👋', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),

            // Email
            Align(alignment: Alignment.centerLeft, child: const Text('Email')),
            const SizedBox(height: 6),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'example@gmail.com',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 12),

            // Password
            Align(alignment: Alignment.centerLeft, child: const Text('Password')),
            const SizedBox(height: 6),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v ?? false)),
                const Text('Remember Me'),
              ],
            ),
            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: () {
                  // simple dev-only credential check
                  final email = _emailController.text.trim();
                  final pwd = _passwordController.text;
                  if (email == 'abcde' && pwd == '12345') {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoggedInHomePage()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
                  }
                },
                child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Log in')),
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('Forgot password?', style: TextStyle(color: Colors.red))),

            const Divider(),
            const SizedBox(height: 8),
            Row(children: const [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('or')), Expanded(child: Divider())]),
            const SizedBox(height: 8),

            // Social buttons
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.g_mobiledata, color: Colors.black),
                label: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Continue with Google')),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.apple, color: Colors.black),
                label: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Continue with Apple')),
              ),
            ),

            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text("Don't have an account? "), TextButton(onPressed: () {}, child: const Text('Sign Up', style: TextStyle(color: Colors.green)))]),
          ],
        ),
      ),
    );
  }
}

