import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _LayoutMock(title: 'Home');
  }
}

class EnergyPage extends StatelessWidget {
  const EnergyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            const SizedBox(height: 8),
            // Top row: notification (left), title (center), add button (right)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  // notification
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsPage())),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text('Eco Plug', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.green)),
                    ),
                  ),
                  // add button with popup menu
                  PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'add') {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddDevicePage()));
                      }
                    },
                    itemBuilder: (context) => [const PopupMenuItem(value: 'add', child: Text('Add Device'))],
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12)),
                      child: const Icon(Icons.add, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // main content: large centered image (energy icon or placeholder)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: GestureDetector(
                    onTap: () => _showRoomsModal(context),
                    child: Image.asset(
                      'assets/images/energy.png',
                      width: 240,
                      height: 240,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.bolt, size: 140, color: Colors.green),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoomsModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _RoomCard(title: 'Dining Room', icon: Icons.chair, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RoomPage(name: 'Dining Room')))),
                  _RoomCard(title: 'Bathroom', icon: Icons.bathtub, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RoomPage(name: 'Bathroom')))),
                  _RoomCard(title: 'Kitchen', icon: Icons.kitchen, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RoomPage(name: 'Kitchen')))),
                ],
              ),
              const SizedBox(height: 18),
            ],
          ),
        );
      },
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.title, required this.icon, required this.onTap});
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      child: Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 100,
          height: 110,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 26, backgroundColor: Colors.grey[50], child: Icon(icon, color: Colors.green, size: 28)),
              const SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomPage extends StatelessWidget {
  const RoomPage({required this.name, Key? key}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    // sample devices for Kitchen template
    // Prefer local assets (assets/images/a.png..d.png) for consistent screenshots
    final devices = [
      {'name': 'Blender', 'asset': 'assets/images/blender.png', 'image': 'assets/images/blender.png'},
      {'name': 'Toaster', 'asset': 'assets/images/toaster.png', 'image': 'assets/images/toaster.png'},
      {'name': 'Oven', 'asset': 'assets/images/oven.png', 'image': 'assets/images/oven.png'},
      {'name': 'Dishwasher', 'asset': 'assets/images/dishwasher.png', 'image': 'assets/images/dishwasher.png'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6FBF4),
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: Text(name),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 18,
          childAspectRatio: 0.75,
          children: devices.map((d) {
            return GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DeviceDetailPage(name: d['name']!, asset: d['asset'] as String?, imageUrl: d['image']!))),
              child: _DeviceCard(name: d['name']!, asset: d['asset'] as String?, imageUrl: d['image']!),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFBFF2C9),
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.name, required this.imageUrl, this.asset, Key? key}) : super(key: key);
  final String name;
  final String imageUrl;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.white,
          elevation: 2,
          borderRadius: BorderRadius.circular(14),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 88,
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ClipOval(
                    child: _buildImageWidget(),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildImageWidget() {
    // prefer explicit asset if provided
    if (asset != null && asset!.isNotEmpty) {
      return Image.asset(
        asset!,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _networkFallback(),
      );
    }

    // if imageUrl looks like network, use network
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 64,
          height: 64,
          color: Colors.grey[200],
          child: const Icon(Icons.kitchen, color: Colors.grey),
        ),
      );
    }

    // otherwise treat imageUrl as asset path
    return Image.asset(
      imageUrl,
      width: 64,
      height: 64,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _networkFallback(),
    );
  }

  Widget _networkFallback() {
    return Container(
      width: 64,
      height: 64,
      color: Colors.grey[200],
      child: const Icon(Icons.kitchen, color: Colors.grey),
    );
  }
}

class DeviceDetailPage extends StatefulWidget {
  const DeviceDetailPage({required this.name, this.asset, required this.imageUrl, Key? key}) : super(key: key);
  final String name;
  final String? asset;
  final String imageUrl;

  @override
  State<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  bool _isOn = false;

  @override
  void initState() {
    super.initState();
    _loadSavedPowerState();
  }

  void _togglePower() {
    setState(() {
      _isOn = !_isOn;
    });
    _savePowerState();
  }

  String _prefsKey() => 'device_power_${widget.name.replaceAll(' ', '_').toLowerCase()}';

  Future<void> _loadSavedPowerState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final val = prefs.getBool(_prefsKey());
      if (val != null) {
        setState(() => _isOn = val);
      }
    } catch (_) {
      // ignore errors; default _isOn stays false
    }
  }

  Future<void> _savePowerState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey(), _isOn);
    } catch (_) {
      // ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = (widget.asset != null && widget.asset!.isNotEmpty)
        ? Image.asset(widget.asset!, width: 120, height: 120, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Image.network(widget.imageUrl, width: 120, height: 120, fit: BoxFit.cover))
        : Image.network(widget.imageUrl, width: 120, height: 120, fit: BoxFit.cover);

    return Scaffold(
      backgroundColor: const Color(0xFFF6FBF4),
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: imageWidget),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        const Text('Smart plug device', style: TextStyle(color: Colors.black54)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _togglePower,
                              icon: const Icon(Icons.power_settings_new, color: Colors.white),
                              label: Text(_isOn ? 'Turn Off' : 'Turn On'),
                              style: ElevatedButton.styleFrom(backgroundColor: _isOn ? Colors.red : Colors.green),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(onPressed: () {}, child: const Text('Share')),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Power Statistics card (tappable)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DevicePowerStatisticsPage(deviceName: widget.name))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Power Statistics', style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  _StatColumn(value: '0.2', unit: 'kWh', label: 'Electricity today'),
                                  _StatColumn(value: '12.0', unit: 'w', label: 'Current power'),
                                  _StatColumn(value: '2.0', unit: 'hours', label: 'Runtime today'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.chevron_right, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Power Source card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                  child: Row(
                    children: [
                      // left: small device icon + label
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[100]),
                            child: Center(child: Image.asset(widget.asset ?? widget.imageUrl, width: 36, height: 36, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.power))),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Power Source', style: TextStyle(fontWeight: FontWeight.w600)),
                              SizedBox(height: 4),
                              Text('Switch', style: TextStyle(color: Colors.black54)),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      // big power button on right
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(color: _isOn ? Colors.red : Colors.green, shape: BoxShape.circle),
                        child: IconButton(
                          onPressed: _togglePower,
                          icon: const Icon(Icons.power_settings_new, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // List options
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.schedule),
                      title: const Text('Schedule'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SchedulePage())),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.flag),
                      title: const Text('Goals'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GoalsPage())),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.eco),
                      title: const Text('Carbon Emission'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.recommend),
                      title: const Text('Recommendations'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
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

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.value, required this.unit, required this.label, Key? key}) : super(key: key);
  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              Text(unit, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}

class DevicePowerStatisticsPage extends StatelessWidget {
  const DevicePowerStatisticsPage({required this.deviceName, Key? key}) : super(key: key);
  final String deviceName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Power Statistics'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF6FBF4),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(deviceName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _LargeStat(value: '0.2', unit: 'kWh', label: 'Electricity today'),
                    _LargeStat(value: '12.0', unit: 'w', label: 'Current power'),
                    _LargeStat(value: '2.0', unit: 'hours', label: 'Runtime today'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('More statistics and graphs can be shown here.', style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _LargeStat extends StatelessWidget {
  const _LargeStat({required this.value, required this.unit, required this.label, Key? key}) : super(key: key);
  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(width: 8),
              Text(unit, style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey[100]),
                child: const Center(child: Icon(Icons.assignment_turned_in_outlined, size: 64, color: Colors.black26)),
              ),
              const SizedBox(height: 16),
              const Text('Nothing here yet', style: TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class GoalsPage extends StatelessWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('9.0', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                        SizedBox(height: 4),
                        Text('kWh', style: TextStyle(color: Colors.black54)),
                        SizedBox(height: 8),
                        Text('Electricity today', style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text('6.0', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                        SizedBox(height: 4),
                        Text('hours', style: TextStyle(color: Colors.black54)),
                        SizedBox(height: 8),
                        Text('Time today', style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // small chart placeholder
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: 120,
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                        child: Center(child: Container(width: double.infinity, height: 80, color: Colors.grey[100])),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text('Daily Goals', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('12.0', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          SizedBox(height: 4),
                          Text('Electricity', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('8.0', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          SizedBox(height: 4),
                          Text('Runtime', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: const Text('Change Goals'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: const Text('History'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddDevicePage extends StatelessWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Device')),
      body: const Center(child: Text('Add Device page — design pending')),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(child: Text('Notifications page — design pending')),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _LayoutMock(title: 'Profile');
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _LayoutMock(title: 'Settings');
  }
}

class _LayoutMock extends StatelessWidget {
  final String title;
  const _LayoutMock({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 320,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade100,
              ),
              padding: const EdgeInsets.all(12),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: List.generate(4, (i) => _PlaceholderCard(index: i + 1)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Layout-only mockup — images not loaded', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  final int index;
  const _PlaceholderCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(child: Text('Screenshot $index', style: const TextStyle(fontSize: 12))),
    );
  }
}
