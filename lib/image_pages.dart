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

class DevicePowerStatisticsPage extends StatefulWidget {
  const DevicePowerStatisticsPage({required this.deviceName, Key? key}) : super(key: key);
  final String deviceName;

  @override
  State<DevicePowerStatisticsPage> createState() => _DevicePowerStatisticsPageState();
}

class _DevicePowerStatisticsPageState extends State<DevicePowerStatisticsPage> {
  int _selectedRange = 0; // 0: Week, 1: Month, 2: Year

  Widget _buildTopStat(String value, String unit, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.deviceName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),

                // top two rows of stats (3 + 3)
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildTopStat('0.2', 'kWh', 'Electricity today'),
                            _buildTopStat('0.4', 'kWh', 'Electricity yesterday'),
                            _buildTopStat('5.9', 'kWh', 'Electricity this month'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildTopStat('12.0', 'w', 'Current power'),
                            _buildTopStat('2.0', 'hours', 'Runtime today'),
                            _buildTopStat('15.0', 'hours', 'Runtime this month'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                // segmented control
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) {
                      final labels = ['Week', 'Month', 'Year'];
                      final selected = _selectedRange == i;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedRange = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: selected ? Colors.grey[200] : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(labels[i], style: TextStyle(color: selected ? Colors.black : Colors.black54, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 8),
                // date range selector
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                    const SizedBox(width: 8),
                    const Text('04/25-05/01', style: TextStyle(color: Colors.black54)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ],
                ),

                const SizedBox(height: 12),
                // chart card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('0.9 kWh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            Text('Total electricity', style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // chart placeholder with simple simulated line
                        SizedBox(
                          height: 180,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                  child: CustomPaint(
                                    painter: _SparklinePainter(),
                                    child: Container(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('04/25', style: TextStyle(color: Colors.black54, fontSize: 12)),
                            Text('05/01', style: TextStyle(color: Colors.black54, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
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
                    onLongPress: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NetZeroPage())),
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
                          const SizedBox(height: 8),
                          // top centered icon
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(child: Icon(Icons.eco, size: 56, color: Colors.green[700])),
                                ),
                                const SizedBox(height: 18),
                              ],
                            ),
                          ),

                          // Field cards
                          _fieldCard(icon: Icons.location_on, title: 'Location', subtitle: 'Kitchen'),
                          _fieldCard(
                            icon: Icons.add_circle_outline,
                            title: 'Things',
                            subtitle: 'Air Conditioner',
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(onPressed: () {}, icon: Icon(Icons.add, color: Colors.green[700])),
                                const SizedBox(width: 6),
                                Row(children: const [Icon(Icons.camera_alt, size: 18, color: Colors.green), SizedBox(width: 6), Text('Add Photo', style: TextStyle(color: Colors.green))]),
                              ],
                            ),
                          ),
                          _fieldCard(
                            icon: Icons.devices, title: 'Device', subtitle: 'Wifi Smart Plug',
                            trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.black38),
                          ),
                          _fieldCard(icon: Icons.monetization_on_outlined, title: 'Costs', subtitle: ''),

                          const SizedBox(height: 28),

                          // Save button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Save Task', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(height: 24),
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
                      onTap: () {
                        // estimate watts (example): Blender ~100W, otherwise 50W
                        final est = widget.name.toLowerCase().contains('blender') ? 100.0 : 50.0;
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => CarbonEmissionPage(deviceName: widget.name, watts: est)));
                      },
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

class DevicePowerStatisticsPage extends StatefulWidget {
  const DevicePowerStatisticsPage({required this.deviceName, Key? key}) : super(key: key);
  final String deviceName;

  @override
  State<DevicePowerStatisticsPage> createState() => _DevicePowerStatisticsPageState();
}

class _DevicePowerStatisticsPageState extends State<DevicePowerStatisticsPage> {
  int _selectedRange = 0; // 0: Week, 1: Month, 2: Year

  Widget _buildTopStat(String value, String unit, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.deviceName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),

                // top two rows of stats (3 + 3)
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildTopStat('0.2', 'kWh', 'Electricity today'),
                            _buildTopStat('0.4', 'kWh', 'Electricity yesterday'),
                            _buildTopStat('5.9', 'kWh', 'Electricity this month'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildTopStat('12.0', 'w', 'Current power'),
                            _buildTopStat('2.0', 'hours', 'Runtime today'),
                            _buildTopStat('15.0', 'hours', 'Runtime this month'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                // segmented control
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) {
                      final labels = ['Week', 'Month', 'Year'];
                      final selected = _selectedRange == i;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedRange = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: selected ? Colors.grey[200] : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(labels[i], style: TextStyle(color: selected ? Colors.black : Colors.black54, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 8),
                // date range selector
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                    const SizedBox(width: 8),
                    const Text('04/25-05/01', style: TextStyle(color: Colors.black54)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ],
                ),

                const SizedBox(height: 12),
                // chart card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('0.9 kWh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            Text('Total electricity', style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // chart placeholder with simple simulated line
                        SizedBox(
                          height: 180,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                  child: CustomPaint(
                                    painter: _SparklinePainter(),
                                    child: Container(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('04/25', style: TextStyle(color: Colors.black54, fontSize: 12)),
                            Text('05/01', style: TextStyle(color: Colors.black54, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // sample points to simulate a rising line
    final points = <Offset>[
      Offset(0, size.height * 0.9),
      Offset(size.width * 0.15, size.height * 0.8),
      Offset(size.width * 0.3, size.height * 0.7),
      Offset(size.width * 0.45, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.5),
      Offset(size.width * 0.75, size.height * 0.35),
      Offset(size.width * 0.9, size.height * 0.15),
    ];

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);

    // fill gradient under line
    final fillPaint = Paint()..shader = LinearGradient(colors: [Colors.blue.withOpacity(0.15), Colors.transparent]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final fillPath = Path.from(path)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Map<String, dynamic>> _schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // prefer new JSON storage
      final raw = prefs.getString('schedules_json');
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        setState(() => _schedules = decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList());
        return;
      }

      // fallback to old query-string list format
      final jsonList = prefs.getStringList('schedules') ?? [];
      final loaded = <Map<String, dynamic>>[];
      for (var e in jsonList) {
        try {
          final m = Uri.splitQueryString(e);
          // convert values: attempt to parse booleans/numbers where appropriate
          final parsed = <String, dynamic>{};
          m.forEach((k, v) {
            if (v == 'true' || v == 'false') {
              parsed[k] = v == 'true';
            } else if (int.tryParse(v) != null) {
              parsed[k] = v; // keep as string for id/hours; we'll normalize later
            } else {
              parsed[k] = v;
            }
          });
          loaded.add(parsed);
        } catch (_) {
          // ignore malformed entries
        }
      }
      setState(() => _schedules = loaded);
    } catch (_) {
      setState(() => _schedules = []);
    }
  }

  Future<void> _saveSchedules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // save as a single JSON string to preserve types
      await prefs.setString('schedules_json', jsonEncode(_schedules));
    } catch (_) {}
  }

  void _addSchedule(Map<String, dynamic> s) {
    setState(() => _schedules.add(s));
    _saveSchedules();
  }

  void _removeSchedule(String id) {
    setState(() => _schedules.removeWhere((e) => e['id']?.toString() == id.toString()));
    _saveSchedules();
  }

  void _removeScheduleAtIndex(int idx) {
    if (idx < 0 || idx >= _schedules.length) return;
    setState(() => _schedules.removeAt(idx));
    _saveSchedules();
  }

  void _removeMultipleByIndices(List<int> indices) {
    // remove in descending order to keep indices valid
    final sorted = indices.toList()..sort((a, b) => b.compareTo(a));
    setState(() {
      for (var i in sorted) {
        if (i >= 0 && i < _schedules.length) _schedules.removeAt(i);
      }
    });
    _saveSchedules();
  }

  void _toggleEnabled(String id, bool val) {
    final idx = _schedules.indexWhere((e) => e['id']?.toString() == id.toString());
    if (idx >= 0) {
      setState(() => _schedules[idx]['enabled'] = val);
      _saveSchedules();
      return;
    }
    // fallback: try parse id as index
    final tryIdx = int.tryParse(id);
    if (tryIdx != null && tryIdx >= 0 && tryIdx < _schedules.length) {
      setState(() => _schedules[tryIdx]['enabled'] = val);
      _saveSchedules();
    }
  }

  void _updateSchedule(Map<String, dynamic> s) {
    final id = s['id']?.toString();
    if (id == null) return;
    final idx = _schedules.indexWhere((e) => e['id']?.toString() == id.toString());
    if (idx >= 0) {
      setState(() => _schedules[idx] = s);
      _saveSchedules();
      return;
    }
    // if no matching id, try to match by index stored in id
    final tryIdx = int.tryParse(id);
    if (tryIdx != null && tryIdx >= 0 && tryIdx < _schedules.length) {
      setState(() => _schedules[tryIdx] = s);
      _saveSchedules();
    }
  }

  void _updateScheduleAtIndex(int idx, Map<String, dynamic> s) {
    if (idx < 0 || idx >= _schedules.length) return;
    setState(() => _schedules[idx] = s);
    _saveSchedules();
  }

  Future<void> _openEditAtIndex(int idx) async {
    if (idx < 0 || idx >= _schedules.length) return;
    final s = _schedules[idx];
    final res = await Navigator.of(context).push<Map<String, dynamic>>(MaterialPageRoute(builder: (_) => AddSchedulePage(initialData: s)));
    if (res != null) _updateScheduleAtIndex(idx, res);
  }

  void _showScheduleOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Center(child: Container(width: 48, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 12),
              ListTile(
                title: const Center(child: Text('Schedule time', style: TextStyle(fontWeight: FontWeight.w600))),
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddSchedulePage()));
                },
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Start', textAlign: TextAlign.center),
                onTap: () {
                  // enable all
                  setState(() {
                    for (var s in _schedules) s['enabled'] = true;
                    _saveSchedules();
                  });
                  Navigator.of(ctx).pop();
                },
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('End', textAlign: TextAlign.center),
                onTap: () {
                  // disable all
                  setState(() {
                    for (var s in _schedules) s['enabled'] = false;
                    _saveSchedules();
                  });
                  Navigator.of(ctx).pop();
                },
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Close', textAlign: TextAlign.center),
                onTap: () => Navigator.of(ctx).pop(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openAdd() async {
    final res = await Navigator.of(context).push<Map<String, dynamic>>(MaterialPageRoute(builder: (_) => const AddSchedulePage()));
    if (res != null) _addSchedule(res);
  }

  void _showDeletePicker() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final count = _schedules.length;
        final selected = List<bool>.filled(count, false);
        return StatefulBuilder(builder: (ctx2, setInner) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select schedules to delete', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: count,
                    itemBuilder: (c, i) {
                      final s = _schedules[i];
                      final start = s['start']?.toString() ?? '—';
                      final end = s['end']?.toString() ?? '—';
                      return CheckboxListTile(
                        value: selected[i],
                        onChanged: (v) => setInner(() => selected[i] = v ?? false),
                        title: Text('$start - $end'),
                        subtitle: Text(s['repeat']?.toString() ?? ''),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                    ElevatedButton(
                      onPressed: selected.any((v) => v)
                          ? () {
                              final toDelete = <int>[];
                              for (var i = 0; i < selected.length; i++) if (selected[i]) toDelete.add(i);
                              Navigator.of(ctx).pop();
                              _removeMultipleByIndices(toDelete);
                            }
                          : null,
                      child: const Text('Delete'),
                    ),
                  ],
                )
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Schedule time',
            icon: const Icon(Icons.access_time_outlined),
            onPressed: _showScheduleOptions,
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'delete') _showDeletePicker();
            },
            itemBuilder: (_) => [const PopupMenuItem(value: 'delete', child: Text('Delete schedule'))],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _schedules.isEmpty
            ? Center(
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
              )
            : ListView.separated(
                itemCount: _schedules.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final s = _schedules[i];
                  final enabled = (s['enabled'] is bool) ? s['enabled'] as bool : (s['enabled']?.toString() == 'true');
                  final start = s['start']?.toString() ?? '—';
                  final end = s['end']?.toString() ?? '—';
                  final repeat = s['repeat']?.toString() ?? '';
                  return ListTile(
                    title: Text('$start - $end'),
                    subtitle: Text(repeat),
                    onTap: () async {
                      await _openEditAtIndex(i);
                    },
                    trailing: Switch.adaptive(value: enabled, onChanged: (v) => _toggleEnabled(i.toString(), v)),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
 
class AddSchedulePage extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const AddSchedulePage({Key? key, this.initialData}) : super(key: key);

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class AddNewRoomPage extends StatefulWidget {
  const AddNewRoomPage({Key? key}) : super(key: key);

  @override
  State<AddNewRoomPage> createState() => _AddNewRoomPageState();
}

class _AddNewRoomPageState extends State<AddNewRoomPage> {
  final TextEditingController _locationController = TextEditingController(text: 'Kitchen');
  final TextEditingController _thingsController = TextEditingController(text: 'Air Conditioner');
  final TextEditingController _deviceController = TextEditingController(text: 'Wifi Smart Plug');
  final TextEditingController _costsController = TextEditingController();
  late List<String> _availableDevices;
  String? _selectedDevice;

  @override
  void dispose() {
    _locationController.dispose();
    _thingsController.dispose();
    _deviceController.dispose();
    _costsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // populate device list; in future this can be replaced with a runtime query
    _availableDevices = ['Wifi Smart Plug'];
    _selectedDevice = _deviceController.text.isNotEmpty ? _deviceController.text : _availableDevices.first;
    _deviceController.text = _selectedDevice!;
  }

  Widget _fieldCard({required IconData icon, required String title, String? subtitle, Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.green[700]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                if (subtitle != null) const SizedBox(height: 6),
                if (subtitle != null) Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),
          if (trailing != null) trailing else const Icon(Icons.chevron_right, color: Colors.black38),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Add New Room'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // top icon
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                  child: const Center(child: Icon(Icons.eco, size: 48, color: Colors.green)),
                ),
                const SizedBox(height: 18),

                // form cards with editable trailing fields
                _fieldCard(
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  subtitle: null,
                  trailing: SizedBox(
                    width: 180,
                    child: TextField(
                      controller: _locationController,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Enter location'),
                    ),
                  ),
                ),

                _fieldCard(
                  icon: Icons.add_circle_outline,
                  title: 'Things',
                  subtitle: null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 140,
                        child: TextField(
                          controller: _thingsController,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(border: InputBorder.none, hintText: 'Item'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt, color: Colors.green[700])),
                    ],
                  ),
                ),

                _fieldCard(
                  icon: Icons.monetization_on_outlined,
                  title: 'Costs',
                  subtitle: null,
                  trailing: SizedBox(
                    width: 140,
                    child: TextField(
                      controller: _costsController,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Costs'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                // Device card with dropdown to choose a connected device
                _fieldCard(
                  icon: Icons.wifi_outlined,
                  title: 'Device',
                  subtitle: _selectedDevice ?? _deviceController.text,
                  trailing: SizedBox(
                    width: 180,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedDevice,
                        items: _availableDevices.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                        onChanged: (v) {
                          setState(() {
                            _selectedDevice = v;
                            if (v != null) _deviceController.text = v;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      // default action: return entered values
                      Navigator.of(context).pop({
                        'location': _locationController.text,
                        'things': _thingsController.text,
                        'device': _selectedDevice ?? _deviceController.text,
                        'costs': _costsController.text,
                      });
                    },
                    child: const Text('Save Task', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialData != null ? 'Edit Schedule' : 'Add Schedule'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // build schedule map and return to caller
              final id = widget.initialData != null ? widget.initialData!['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString() : DateTime.now().millisecondsSinceEpoch.toString();
              final repeatCsv = _repeatDays.asMap().entries.where((e) => e.value).map((e) => e.key.toString()).join(',');
              final map = {
                'id': id,
                'start': _format(_start),
                'startHour': _start.hour.toString(),
                'startMinute': _start.minute.toString(),
                'end': _format(_end),
                'endHour': _end.hour.toString(),
                'endMinute': _end.minute.toString(),
                'repeat': _repeatLabel,
                'repeatDays': repeatCsv,
                'label': widget.initialData?['label']?.toString() ?? '',
                'vibrate': _vibrate,
                'enabled': (widget.initialData != null && widget.initialData!['enabled'] is bool)
                    ? widget.initialData!['enabled']
                    : (widget.initialData?['enabled']?.toString() == 'true'),
              };
              Navigator.of(context).pop(map);
            },
            child: const Text('Save'),
          )
        ],
      ),
      backgroundColor: const Color(0xFFF6FBF4),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // time selectors area with pale green background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    // Start
                    _TimeRow(label: 'Start time', value: _format(_start), onTap: _pickStart),
                    const SizedBox(height: 12),
                    // End
                    _TimeRow(label: 'End time', value: _format(_end), onTap: _pickEnd),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    ListTile(leading: const Icon(Icons.repeat), title: const Text('Repeat'), subtitle: Text(_repeatLabel), onTap: _openRepeatModal),
                    const Divider(height: 1),
                    ListTile(leading: const Icon(Icons.notifications), title: const Text('Default'), subtitle: const Text('Default'), onTap: () {}),
                    const Divider(height: 1),
                    SwitchListTile.adaptive(
                      value: _vibrate,
                      onChanged: (v) => setState(() => _vibrate = v),
                      secondary: const Icon(Icons.vibration),
                      title: const Text('Vibrate'),
                    ),
                    const Divider(height: 1),
                    ListTile(leading: const Icon(Icons.label_outline), title: const Text('Label'), subtitle: const Text('None'), onTap: () {}),
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

class _TimeRow extends StatelessWidget {
  const _TimeRow({required this.label, required this.value, required this.onTap, Key? key}) : super(key: key);
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
                  const Icon(Icons.access_time_outlined, color: Colors.black54),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  // sample data; replace with real values as needed
  double electricityToday = 9.0; // kWh
  double timeToday = 6.0; // hours
  double electricityGoal = 12.0; // kWh goal
  double timeGoal = 8.0; // hours goal
  String electricityUnit = 'kWh';
  List<double> sparklinePoints = [0.2, 0.4, 0.6, 0.8, 0.75, 0.85, 0.6];

  @override
  void initState() {
    super.initState();
    _loadGoalsFromPrefs();
  }

  Future<void> _loadGoalsFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // prefer canonical kWh key
      final storedKwh = prefs.getDouble('settings_electricity_goal_kwh');
      final oldEg = prefs.getDouble('settings_electricity_goal');
      final storedUnit = prefs.getString('settings_electricity_unit');
      final rt = prefs.getDouble('settings_runtime_goal');
      double newGoalKwh = electricityGoal;
      if (storedKwh != null) {
        newGoalKwh = storedKwh;
      } else if (oldEg != null) {
        // migrate from old key using storedUnit
        if (storedUnit == 'W') newGoalKwh = oldEg / 1000.0; else newGoalKwh = oldEg;
      }
      setState(() {
        electricityGoal = newGoalKwh;
        if (rt != null) timeGoal = rt;
        if (storedUnit != null) electricityUnit = storedUnit;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final progress = (electricityGoal > 0) ? (electricityToday / electricityGoal).clamp(0.0, 1.0) : 0.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () async {
              final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
              // if settings changed, reload goals from prefs so UI updates immediately
              if (res != null) {
                _loadGoalsFromPrefs();
              }
            },
          ),
        ],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: electricity value
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(builder: (_) {
                            final displayToday = (electricityUnit == 'kWh') ? electricityToday : (electricityToday * 1000.0);
                            final unitLabel = electricityUnit;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(displayToday.toStringAsFixed(1), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                Text(unitLabel, style: const TextStyle(color: Colors.black54)),
                              ],
                            );
                          }),
                          const SizedBox(height: 8),
                          const Text('Electricity today', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),

                    // Middle: time value
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(timeToday.toStringAsFixed(1), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          const Text('hours', style: TextStyle(color: Colors.black54)),
                          const SizedBox(height: 8),
                          const Text('Time today', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),

                    // Right: progress bar box
                    SizedBox(
                      width: 110,
                      child: Column(
                        children: [
                          Container(
                            height: 22,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Stack(
                                children: [
                                  Container(color: Colors.white),
                                  FractionallySizedBox(widthFactor: progress, child: Container(color: Colors.black)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Chart card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: 120,
                      child: Row(
                        children: [
                          // sparkline area
                          Expanded(
                            child: CustomPaint(
                              painter: _SparklinePainter(),
                              child: Container(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // y-axis labels
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('6.0', style: TextStyle(color: Colors.black38, fontSize: 12)),
                              Text('3.0', style: TextStyle(color: Colors.black38, fontSize: 12)),
                              Text('0.0', style: TextStyle(color: Colors.black38, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text('Daily Goals', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(builder: (_) {
                            final displayGoal = (electricityUnit == 'kWh') ? electricityGoal : (electricityGoal * 1000.0);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(displayGoal.toStringAsFixed(1), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                const Text('Electricity', style: TextStyle(color: Colors.black54)),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(timeGoal.toStringAsFixed(1), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          const Text('Runtime', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 'Change Goals' removed — use SettingsPage to edit goals
                const SizedBox(height: 8),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: const Text('History'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryPage())),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: const Text('Recommendations'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RecommendationsPage())),
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
      appBar: AppBar(
        title: const Text('Add Device'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: const [
                  Text('Searching for nearby devices. Make sure your device has entered pairing mode',
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.black87)),
                  SizedBox(height: 14),
                ],
              ),
            ),

            // Wi-Fi hint card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Turn on Wi-Fi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          SizedBox(height: 6),
                          Text('Wi‑Fi is required to search for devices.', style: TextStyle(color: Colors.black54, fontSize: 13)),
                        ],
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: const [
                          Icon(Icons.wifi, color: Colors.black54, size: 18),
                          Positioned(right: 6, top: 6, child: Icon(Icons.error, color: Colors.red, size: 10)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Large radar circles
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: CustomPaint(
                    painter: _RadarPainter(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Add manually and socket icon
            Padding(
              padding: const EdgeInsets.only(bottom: 28.0),
              child: Column(
                children: [
                  const Text('Add Manually', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Material(
                    color: Colors.white,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.grey[50]),
                      child: IconButton(
                        icon: const Icon(Icons.power, size: 30, color: Colors.black54),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.blue.withOpacity(0.12);

    for (var i = 4; i >= 1; i--) {
      canvas.drawCircle(center, maxR * i / 4, paint);
    }

    // inner filled dot
    final fill = Paint()..color = Colors.blue.withOpacity(0.9);
    canvas.drawCircle(center, 6, fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({Key? key}) : super(key: key);

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _twoFactor = true;
  bool _appLock = false;

  @override
  void initState() {
    super.initState();
    _loadSecurityPrefs();
  }

  Future<void> _loadSecurityPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final two = prefs.getBool('settings_security_2fa');
      final lock = prefs.getBool('settings_security_app_lock');
      if (two != null || lock != null) {
        setState(() {
          if (two != null) _twoFactor = two;
          if (lock != null) _appLock = lock;
        });
      }
    } catch (_) {}
  }

  Future<void> _saveSecurityPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('settings_security_2fa', _twoFactor);
      await prefs.setBool('settings_security_app_lock', _appLock);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Security Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF2FBF0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Account Security', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),

                // 2FA pill
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Two-Factor Authemi cation (2FA)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            SizedBox(height: 6),
                            Text('Manage your verification methods', style: TextStyle(color: Colors.black45, fontSize: 12)),
                          ],
                        ),
                      ),
                      Switch.adaptive(value: _twoFactor, onChanged: (v) {
                        setState(() => _twoFactor = v);
                        _saveSecurityPrefs();
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // simple list tiles
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Change Password'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Recent Login Activity'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),
                const Text('Device Management', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Manage Authorized Devices'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.lock_outline, color: Colors.black54),
                        title: const Text('App Lock'),
                        trailing: Switch.adaptive(value: _appLock, onChanged: (v) {
                          setState(() => _appLock = v);
                          _saveSecurityPrefs();
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _enableAll = true;
  bool _generalNotifications = false;
  bool _energyTips = false;
  bool _doNotDisturb = false;
  bool _vibration = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPrefs();
  }

  Future<void> _loadNotificationPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eAll = prefs.getBool('settings_notif_enable_all');
      final gen = prefs.getBool('settings_notif_general');
      final energy = prefs.getBool('settings_notif_energy_tips');
      final dnd = prefs.getBool('settings_notif_dnd');
      final vib = prefs.getBool('settings_notif_vibration');
      setState(() {
        if (eAll != null) _enableAll = eAll;
        if (gen != null) _generalNotifications = gen;
        if (energy != null) _energyTips = energy;
        if (dnd != null) _doNotDisturb = dnd;
        if (vib != null) _vibration = vib;
      });
    } catch (_) {}
  }

  Future<void> _saveNotificationPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('settings_notif_enable_all', _enableAll);
      await prefs.setBool('settings_notif_general', _generalNotifications);
      await prefs.setBool('settings_notif_energy_tips', _energyTips);
      await prefs.setBool('settings_notif_dnd', _doNotDisturb);
      await prefs.setBool('settings_notif_vibration', _vibration);
    } catch (_) {}
  }

  void _setAll(bool v) {
    setState(() {
      _enableAll = v;
      _generalNotifications = v;
      _energyTips = v;
      _doNotDisturb = v;
      _vibration = v;
    });
    _saveNotificationPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Notification Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF2FBF0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top large pill with toggle
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text('Enable All Notifications', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                      Switch.adaptive(value: _enableAll, onChanged: (v) => _setAll(v)),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // General section header
                const Text('General', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('Notification Types', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 8),

                // Card with notification types
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('General Notifications'),
                        trailing: Switch.adaptive(value: _generalNotifications, onChanged: (v) {
                          setState(() => _generalNotifications = v);
                          _saveNotificationPrefs();
                        }),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Energy Saving Tips', style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: const Text('Recommended to keep on Promotional. Recommended', style: TextStyle(color: Colors.black45, fontSize: 12)),
                        trailing: Switch.adaptive(value: _energyTips, onChanged: (v) {
                          setState(() => _energyTips = v);
                          _saveNotificationPrefs();
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Common Settings
                const Text('Common Settings', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.nights_stay, color: Colors.green),
                        title: const Text('Do Not Disturb Mode'),
                        trailing: Switch.adaptive(value: _doNotDisturb, onChanged: (v) {
                          setState(() => _doNotDisturb = v);
                          _saveNotificationPrefs();
                        }),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.vibration, color: Colors.black54),
                        title: const Text('Notification Vibration'),
                        trailing: Switch.adaptive(value: _vibration, onChanged: (v) {
                          setState(() => _vibration = v);
                          _saveNotificationPrefs();
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationsPageState extends State<NotificationsPage> {
  // sample notifications; in a real app these would come from a backend or local DB
  final List<Map<String, dynamic>> _items = [
    {'id': '1', 'title': 'Welcome to Eco Plug', 'body': 'Learn how to save energy with simple steps.', 'time': '2h', 'read': false},
    {'id': '2', 'title': 'Schedule Active', 'body': 'Your schedule for Blender is active at 08:00.', 'time': '1d', 'read': false},
    {'id': '3', 'title': 'Weekly Report', 'body': 'Your electricity usage decreased by 12% this week.', 'time': '3d', 'read': true},
  ];

  void _markRead(int idx) {
    setState(() => _items[idx]['read'] = true);
  }

  void _toggleRead(int idx) {
    setState(() => _items[idx]['read'] = !_items[idx]['read']);
  }

  void _removeItem(String id) {
    setState(() => _items.removeWhere((e) => e['id'] == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _items.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.notifications_none, size: 72, color: Colors.black26),
                    const SizedBox(height: 12),
                    const Text('No notifications', style: TextStyle(color: Colors.black54)),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final it = _items[i];
                  final read = it['read'] as bool? ?? false;
                  return Dismissible(
                    key: ValueKey(it['id']),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => _removeItem(it['id'].toString()),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: read ? Colors.grey[200] : Colors.green[100],
                        child: Icon(Icons.notifications, color: read ? Colors.grey : Colors.green),
                      ),
                      title: Text(it['title'].toString(), style: TextStyle(fontWeight: FontWeight.w600, color: read ? Colors.black54 : Colors.black)),
                      subtitle: Text(it['body'].toString(), maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(it['time'].toString(), style: const TextStyle(color: Colors.black45, fontSize: 12)),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () => _toggleRead(i),
                            child: Icon(read ? Icons.mark_email_read : Icons.mark_email_unread, size: 18, color: read ? Colors.green : Colors.black45),
                          ),
                        ],
                      ),
                      onTap: () {
                        // open detail (for now, mark read and show simple dialog)
                        _markRead(i);
                        showDialog<void>(context: context, builder: (dctx) {
                          return AlertDialog(
                            title: Text(it['title'].toString()),
                            content: Text(it['body'].toString()),
                            actions: [TextButton(onPressed: () => Navigator.of(dctx).pop(), child: const Text('Close'))],
                          );
                        });
                      },
                    ),
                  );
                },
              ),
      ),
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

class NetZeroPage extends StatelessWidget {
  const NetZeroPage({Key? key}) : super(key: key);

  static const String _bodyText = '''Net Zero refers to the goal of reducing greenhouse gas emissions to zero by 2050. This ambitious target is essential to preventing the worst effects of climate change and limiting global warming to 1.5°C above pre-industrial levels. Achieving Net Zero requires a combination of reducing emissions and actively removing carbon from the atmosphere.

One of the primary strategies for reaching Net Zero is transitioning to renewable energy sources such as solar, wind, and hydroelectric power. These alternatives to fossil fuels help minimize carbon emissions while promoting sustainable energy consumption. Additionally, advances in carbon capture and storage technologies play a crucial role in removing existing greenhouse gases from the atmosphere, ensuring a cleaner environment. Governments and organizations worldwide have recognized the urgency of this goal, implementing policies and initiatives to drive progress. International agreements like the Paris Agreement have set clear objectives for emission reductions, urging countries to adopt sustainable practices. Businesses are also taking significant steps by committing to carbon neutrality, investing in green technologies, and enhancing energy efficiency in operations.

Despite these efforts, achieving Net Zero presents numerous challenges, including economic costs, technological limitations, and political obstacles. However, the transition also brings opportunities, such as the growth of green industries, job creation, and improved public health due to reduced air pollution. The shift toward sustainability requires collective action, fostering innovation and collaboration across various sectors. Individuals also play a vital role in contributing to Net Zero. Small lifestyle changes, such as using energy-efficient appliances, reducing waste, and advocating for climate-friendly policies, can have a meaningful impact. By making conscious choices and supporting sustainability efforts, individuals can help shape a greener future.

Reaching Net Zero by 2050 is a complex yet necessary endeavor. While challenges exist, global cooperation, technological advancements, and a commitment to sustainability can pave the way for a cleaner and healthier planet. Everyone—governments, businesses, and individuals—must take responsibility in ensuring that future generations inherit a world free from the devastating consequences of climate change.''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Net Zero'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top rounded image (use existing asset as fallback)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: Colors.grey[100]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/a.png',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        color: Colors.green[50],
                        child: const Center(child: Icon(Icons.bedtime, size: 56, color: Colors.green)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                Center(child: Text('Net Zero', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87))),
                const SizedBox(height: 12),

                SelectableText(
                  _bodyText,
                  style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EcoPlugPage extends StatelessWidget {
  const EcoPlugPage({Key? key}) : super(key: key);

  static const String _bodyText = '''Eco Plug is an AI-powered app that helps you manage your home’s energy use more efficiently. It controls devices automatically and offers real-time energy data and savings tips.

Eco Plug is designed to enhance energy efficiency and reduce carbon emissions through AI-driven automation. It monitors real-time power usage, provides energy reports, and optimizes consumption by learning user habits.

With remote control via a mobile app or voice assistants, users can schedule appliances and reduce unnecessary power waste. Safety alerts detect abnormal usage, while a built-in carbon footprint tracker converts energy use into CO₂ emissions and offers eco-friendly recommendations.

By integrating smart energy solutions into daily life, Eco Plug makes sustainability effortless while helping users lower their environmental impact.''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Eco Plug'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top rounded image (use existing asset as fallback)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: Colors.grey[100]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/b.png',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        color: Colors.green[50],
                        child: const Center(child: Icon(Icons.bedtime, size: 56, color: Colors.green)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                Center(child: Text('Eco Plug', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87))),
                const SizedBox(height: 12),

                SelectableText(
                  _bodyText,
                  style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TipsPage extends StatelessWidget {
  const TipsPage({Key? key}) : super(key: key);

  static const String _bodyText = '''Tips for Saving Power:
●Use Smart Plugs to Manage Energy Consumption: Install AI-driven smart plugs like Eco Plug to automate the management of your household appliances and avoid unnecessary energy use.
●Optimize Energy Efficiency at Home: Set your smart plugs to turn off unused devices, particularly those that consume power in standby mode.
●Choose Energy-Saving Appliances: Replace old, inefficient devices with energy-efficient ones that work seamlessly with your smart plug, reducing your energy consumption even further.
●Educate and Share: Spread the word about the benefits of smart plugs and energy-saving solutions within your community, helping others contribute to the Net Zero goal.
●Advocate for Smart Energy Solutions: Support policies that promote the adoption of AI and energy-saving technologies in households, businesses, and governments.''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Tips & Tricks'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top rounded image (use existing asset as fallback)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: Colors.grey[100]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/d.png',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        color: Colors.green[50],
                        child: const Center(child: Icon(Icons.bedtime, size: 56, color: Colors.green)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                Center(child: Text('Tips & Tricks', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87))),
                const SizedBox(height: 12),

                SelectableText(
                  _bodyText,
                  style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LearnPage extends StatelessWidget {
  const LearnPage({Key? key}) : super(key: key);

  static const String _bodyText = '''Eco Plug helps users monitor, control, and optimize their electricity usage with real-time power tracking, AI-based energy optimization, and remote access. Here’s how it makes energy efficiency effortless:
●Reducing Wasted Energy: Many devices consume power even when switched off. Eco Plug detects and eliminates unnecessary standby energy use.
●Lowering Carbon Emissions: The plug converts electricity usage into CO₂ emissions, helping users track their environmental impact.
●Enhancing Energy Efficiency: AI analyzes usage patterns and suggests energy-saving habits, ensuring optimal power management.
●Remote Control for Convenience: Users can control appliances anytime, anywhere through a mobile app or voice assistants.
●By integrating these smart energy-saving features into daily life, Eco Plug empowers users to make sustainable choices with ease.''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Learn How You Can Help'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top rounded image (use existing asset as fallback)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: Colors.grey[100]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/c.png',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        color: Colors.green[50],
                        child: const Center(child: Icon(Icons.bedtime, size: 56, color: Colors.green)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                Center(child: Text('Learn How You Can Help', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87))),
                const SizedBox(height: 12),

                SelectableText(
                  _bodyText,
                  style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // canonical storage: keep electricity goal in kWh internally
  double _electricityGoalKwh = 10.0;
  String electricityUnit = 'W'; // 'kWh' or 'W' (display)
  double runtimeGoal = 0.0;

  void _saveAndClose() {
    // persist canonical kWh value and unit for display, then pop
    () async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('settings_electricity_goal_kwh', _electricityGoalKwh);
        await prefs.setString('settings_electricity_unit', electricityUnit);
        await prefs.setDouble('settings_runtime_goal', runtimeGoal);
      } catch (_) {}
      Navigator.of(context).pop({'electricityGoalKwh': _electricityGoalKwh, 'electricityUnit': electricityUnit, 'runtimeGoal': runtimeGoal});
    }();
  }

  @override
  void initState() {
    super.initState();
    () async {
      try {
        final prefs = await SharedPreferences.getInstance();
        // migration: if legacy key exists, convert to canonical kWh
        final oldVal = prefs.getDouble('settings_electricity_goal');
        final oldUnit = prefs.getString('settings_electricity_unit');
        final storedKwh = prefs.getDouble('settings_electricity_goal_kwh');
        final eu = prefs.getString('settings_electricity_unit');
        final rt = prefs.getDouble('settings_runtime_goal');

        double loadedKwh = _electricityGoalKwh;
        if (storedKwh != null) {
          loadedKwh = storedKwh;
        } else if (oldVal != null) {
          if (oldUnit == 'W') {
            loadedKwh = oldVal / 1000.0;
          } else {
            loadedKwh = oldVal;
          }
        }

        setState(() {
          _electricityGoalKwh = loadedKwh;
          if (eu != null) electricityUnit = eu;
          if (rt != null) runtimeGoal = rt;
        });
      } catch (_) {}
    }();
  }

  void _convertElectricityGoalTo(String newUnit) {
    // Keep canonical kWh value; switching unit only changes display
    if (newUnit == electricityUnit) return;
    setState(() => electricityUnit = newUnit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(onPressed: _saveAndClose, child: const Text('Save', style: TextStyle(color: Colors.green))),
        ],
      ),
      backgroundColor: const Color(0xFFF6FBF4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text('Electricity Goal', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Builder(builder: (_) {
                        final display = (electricityUnit == 'kWh') ? _electricityGoalKwh : (_electricityGoalKwh * 1000.0);
                        return Text(display.toStringAsFixed(1), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800));
                      }),
                    ),
                    DropdownButton<String>(
                      value: electricityUnit,
                      items: const [DropdownMenuItem(value: 'kWh', child: Text('kWh')), DropdownMenuItem(value: 'W', child: Text('W'))],
                      onChanged: (v) => _convertElectricityGoalTo(v ?? electricityUnit),
                    ),
                  ],
                ),
                Builder(builder: (_) {
                  final display = (electricityUnit == 'kWh') ? _electricityGoalKwh : (_electricityGoalKwh * 1000.0);
                  final min = (electricityUnit == 'kWh') ? 0.1 : 0.1 * 1000.0;
                  final max = (electricityUnit == 'kWh') ? 20.0 : 20.0 * 1000.0;
                  return Slider.adaptive(
                    value: display.clamp(min, max),
                    min: min,
                    max: max,
                    onChanged: (v) => setState(() {
                      _electricityGoalKwh = (electricityUnit == 'kWh') ? v : (v / 1000.0);
                    }),
                  );
                }),
                const SizedBox(height: 8),
                const Text('Electricity Units', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _convertElectricityGoalTo('kWh'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: electricityUnit == 'kWh' ? Colors.green : Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [Text('kWh', style: TextStyle(fontWeight: FontWeight.w600)), SizedBox(height: 6), Text('kilowatt-hour', style: TextStyle(color: Colors.black54))],
                                ),
                              ),
                              Icon(electricityUnit == 'kWh' ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: electricityUnit == 'kWh' ? Colors.green : Colors.black26),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _convertElectricityGoalTo('W'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: electricityUnit == 'W' ? Colors.green : Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [Text('W', style: TextStyle(fontWeight: FontWeight.w600)), SizedBox(height: 6), Text('Watt', style: TextStyle(color: Colors.black54))],
                                ),
                              ),
                              Icon(electricityUnit == 'W' ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: electricityUnit == 'W' ? Colors.green : Colors.black26),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Text('Runtime Goal', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text(runtimeGoal.toStringAsFixed(1), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700))),
                    const SizedBox(width: 8),
                    const Text('Hours', style: TextStyle(color: Colors.black54)),
                  ],
                ),
                Slider.adaptive(value: runtimeGoal, min: 0.0, max: 24.0, divisions: 24, onChanged: (v) => setState(() => runtimeGoal = v)),
                const SizedBox(height: 8),
                const Text('Runtime Units', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 28),
                const Text(
                  'Note: Electricity goal is edited as a value between 0.1 and 20.0.\nWhen switching units the displayed number will convert (kWh ⇄ W). 0.0 is not allowed.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
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

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

// Simple Recommendations page
class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            ListTile(
              leading: Icon(Icons.lightbulb_outline, color: Colors.green),
              title: Text('Unplug idle devices'),
              subtitle: Text('Reduce standby power by unplugging or using smart strips.'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.schedule, color: Colors.orange),
              title: Text('Schedule heavy appliances'),
              subtitle: Text('Shift dishwasher or washing machine to off-peak hours.'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.emoji_events, color: Colors.blue),
              title: Text('Set daily goals'),
              subtitle: Text('Aim to reduce daily consumption by 10% this week.'),
            ),
          ],
        ),
      ),
    );
  }
}

// helper tile used by CarbonEmissionPage
Widget _metricTile({required String value, required String unit, required String label}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(width: 6),
            Text(unit, style: const TextStyle(color: Colors.black54)),
          ],
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
      ],
    ),
  );
}

class CarbonEmissionPage extends StatelessWidget {
  final String deviceName;
  final double watts;
  const CarbonEmissionPage({Key? key, required this.deviceName, required this.watts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Interpret incoming `watts` as a kWh-like display value for the template.
    final displayKwh = watts; // caller may pass kWh already (e.g., 100)

    // Example derived metrics (placeholders) based on displayKwh
    final energySavedPerMonth = (displayKwh * 0.72);
    final co2SavedKg = (energySavedPerMonth * 0.42); // sample conversion
    final trees = (energySavedPerMonth / 50.0); // arbitrary equivalence
    final drivingHours = (energySavedPerMonth / 30.0);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Carbon Emission'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                const Text('Today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // left: label + big value
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Power (kWh)', style: TextStyle(color: Colors.black54)),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${displayKwh.toStringAsFixed(0)}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900)),
                              const SizedBox(width: 8),
                              Text('kWh', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black54)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // right: image
                    Expanded(
                      flex: 6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 140,
                          color: Colors.grey[50],
                          child: Image.asset(
                            'assets/images/eco_house.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.nature, size: 64, color: Colors.green)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),
                const Divider(),
                const SizedBox(height: 14),

                const Text('If you reach this target:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),

                // metrics grid (2x2)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _metricTile(value: '${energySavedPerMonth.toStringAsFixed(0)}', unit: 'kWh', label: 'Energy saved per month')),
                          const SizedBox(width: 12),
                          Expanded(child: _metricTile(value: '${co2SavedKg.toStringAsFixed(2)}', unit: 'kg', label: 'CO2 saved per month')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _metricTile(value: '${trees.toStringAsFixed(1)}', unit: 'trees', label: 'Equivalent to planting')),
                          const SizedBox(width: 12),
                          Expanded(child: _metricTile(value: '${drivingHours.toStringAsFixed(2)}', unit: 'hours', label: 'Equivalent of driving')),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: const Text('Information'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DevicePowerStatisticsPage(deviceName: deviceName))),
                  ),
                ),

                // bottom handle removed per request
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryPageState extends State<HistoryPage> {
  // sample months and sample data
  final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  int selectedMonthIndex = 5; // June as default

  // sample history entries (kWh, hours, day)
  final List<Map<String,dynamic>> entries = [
    {'kwh': 9.0, 'hours': 6.0, 'day': '20th'},
    {'kwh': 9.0, 'hours': 6.0, 'day': '29th'},
    {'kwh': 6.0, 'hours': 7.8, 'day': '25th'},
    {'kwh': 7.0, 'hours': 7.0, 'day': '23th'},
    {'kwh': 6.0, 'hours': 7.0, 'day': '21th'},
  ];

  @override
  Widget build(BuildContext context) {
    final hasData = entries.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, i) {
                  final sel = i == selectedMonthIndex;
                  return GestureDetector(
                    onTap: () => setState(() => selectedMonthIndex = i),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(child: Text(months[i], style: TextStyle(color: sel ? Colors.white : Colors.black))),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: months.length,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: hasData ? ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (ctx, i) {
                  final e = entries[i];
                  final kwh = e['kwh'] as double;
                  final hours = e['hours'] as double;
                  final day = e['day'] as String;
                  // progress relative to a goal sample (use 12 kWh as full)
                  final prog = (kwh / 12.0).clamp(0.0, 1.0);
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // left value
                      SizedBox(
                        width: 72,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(kwh.toStringAsFixed(1), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            const Text('kWh', style: TextStyle(color: Colors.black54, fontSize: 12)),
                          ],
                        ),
                      ),

                      // middle progress bar
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(height: 18, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8))),
                                FractionallySizedBox(widthFactor: prog, child: Container(height: 18, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)))),
                              ],
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),

                      // right hours and day
                      SizedBox(
                        width: 96,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${hours.toStringAsFixed(1)} hours', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            Text(day, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ) : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey[100]),
                      child: const Center(child: Icon(Icons.history, size: 64, color: Colors.black26)),
                    ),
                    const SizedBox(height: 16),
                    const Text('No data for this month', style: TextStyle(color: Colors.black54)),
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

class CarbonInformationPage extends StatelessWidget {
  const CarbonInformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Information'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Carbon Emission Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              SizedBox(height: 12),
              Text('Details coming soon. You can replace this placeholder with the full information screen content when ready.', style: TextStyle(color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}

