
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const StudentProfileScreen(),
    );
  }
}

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  DateTime _selectedDate = _today();
  String _selectedHouse = 'Slytherin';

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _validSelectedDate(DateTime date, DateTime today) {
    final minDate = DateTime(1950);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly.isBefore(minDate)) {
      return minDate;
    }
    if (dateOnly.isAfter(today)) {
      return today;
    }
    return dateOnly;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  // Material Date Picker
  Future<void> _selectMaterialDate() async {
    final today = _today();
    final initialDate = _validSelectedDate(_selectedDate, today);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: today,
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
        );
      });
    }
  }

  // Cupertino Date Picker
  // The date is saved only when Done is pressed.
  void _showCupertinoDatePicker() {
    final today = _today();
    DateTime tempDate = _validSelectedDate(
      _selectedDate,
      today,
    );

    showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) {
        return Container(
          height: 280,
          color: CupertinoColors.systemBackground
              .resolveFrom(popupContext),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                SizedBox(
                  height: 44,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: const Text('Done'),
                      onPressed: () {
                        setState(() {
                          _selectedDate = tempDate;
                        });
                        Navigator.pop(popupContext);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: tempDate,
                    maximumDate: today,
                    minimumDate: DateTime(1950),
                    onDateTimeChanged: (DateTime newDate) {
                      tempDate = DateTime(
                        newDate.year,
                        newDate.month,
                        newDate.day,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Cupertino House Wheel Picker
  void _showCupertinoRolePicker() {
    final List<String> houses = [
      'Gryffindor',
      'Slytherin',
      'Ravenclaw',
      'Hufflepuff',
    ];

    final selectedIndex = houses.indexOf(_selectedHouse);
    final controller = FixedExtentScrollController(
      initialItem: selectedIndex >= 0 ? selectedIndex : 0,
    );

    showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) {
        return Container(
          height: 240,
          color: CupertinoColors.systemBackground
              .resolveFrom(popupContext),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: const Text('Done'),
                      onPressed: () {
                        Navigator.pop(popupContext);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 36,
                    scrollController: controller,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedHouse = houses[index];
                      });
                    },
                    children: houses.map((house) {
                      return Center(
                        child: Text(house),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(controller.dispose);
  }

  void _updateHouse(String? newValue) {
    if (newValue == null) return;

    setState(() {
      _selectedHouse = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CSS3344 Mobile App Dev - Lab 02',
        ),
        centerTitle: true,
        backgroundColor:
        Theme.of(context).colorScheme.primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildPortraitView();
          }
          return _buildLandscapeView();
        },
      ),
    );
  }

  // Portrait layout
  Widget _buildPortraitView() {
    return Container(
      color: const Color(0xFFF9F7FF),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const StudentDetailsSection(),
          const TitleSection(
            name: 'University of Technology Sarawak',
            location: 'UTS, Sibu, Sarawak',
            starCount: 41,
          ),
          const LandscapeImageSection(
            imagePath: 'assets/images/herrypotter.png',
          ),
          const SizedBox(height: 16),
          PickerSection(
            selectedDate: _formatDate(_selectedDate),
            selectedHouse: _selectedHouse,
            onMaterialDatePressed: _selectMaterialDate,
            onCupertinoDatePressed: _showCupertinoDatePicker,
            onCupertinoHousePressed: _showCupertinoRolePicker,
            onHouseChanged: _updateHouse,
          ),
        ],
      ),
    );
  }

  // Landscape layout
  Widget _buildLandscapeView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          flex: 2,
          child: Center(
            child: StudentDetailsSection(),
          ),
        ),
        Expanded(
          flex: 3,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const TitleSection(
                name: 'University Technology Sarawak',
                location: 'UTS, Sibu, Sarawak',
                starCount: 41,
              ),
              const TextSection(),

              const LandscapeImageSection(
                imagePath: 'assets/images/herrypotter.png',
              ),
              const SizedBox(height: 16),

              PickerSection(
                selectedDate: _formatDate(_selectedDate),
                selectedHouse: _selectedHouse,
                onMaterialDatePressed: _selectMaterialDate,
                onCupertinoDatePressed: _showCupertinoDatePicker,
                onCupertinoHousePressed: _showCupertinoRolePicker,
                onHouseChanged: _updateHouse,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Student information and profile image
class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF4052B5),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ImageSection(
              imagePath: 'assets/images/Calvin.jpg',
            ),
            const SizedBox(height: 12),
            const Text(
              'CALVIN LEONG YU WEI',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Student ID: BCS24090041',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFDDE2FF),
              ),
            ),
            const Divider(
              height: 24,
              color: Color(0xFF8794E8),
            ),
            const Text(
              'Personal Life Goal / Quote:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '"My dream is to find a low-stress job"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Circular student profile image
class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.indigo,
      backgroundImage: AssetImage(imagePath),
    );
  }
}

// Large rectangular image
class LandscapeImageSection extends StatelessWidget {
  final String imagePath;

  const LandscapeImageSection({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Image.asset(
          imagePath,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const Text(
                'Image not found. Check the asset path.',
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Reusable title section
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}

// Reusable text section
class TextSection extends StatelessWidget {
  const TextSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Life Goal / Quote:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '"My dream is to find a low-stress job"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }
}

// All pickers are presented in this section
class PickerSection extends StatelessWidget {
  final String selectedDate;
  final String selectedHouse;
  final VoidCallback onMaterialDatePressed;
  final VoidCallback onCupertinoDatePressed;
  final VoidCallback onCupertinoHousePressed;
  final ValueChanged<String?> onHouseChanged;

  const PickerSection({
    super.key,
    required this.selectedDate,
    required this.selectedHouse,
    required this.onMaterialDatePressed,
    required this.onCupertinoDatePressed,
    required this.onCupertinoHousePressed,
    required this.onHouseChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive Pickers (Lab 2.2)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            Text('Selected Date: $selectedDate'),
            const SizedBox(height: 4),
            Text(
              'Selected House: $selectedHouse',
              style: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Material Date Picker button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: onMaterialDatePressed,
                child: const Text('Material Date Picker'),
              ),
            ),
            const SizedBox(height: 12),

            // Cupertino Date Picker button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: onCupertinoDatePressed,
                child: const Text('Cupertino Date Picker'),
              ),
            ),
            const SizedBox(height: 20),

            // Material Dropdown
            const Text(
              'Material Dropdown House',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedHouse,
              items: const [
                DropdownMenuItem(
                  value: 'Gryffindor',
                  child: Text('Gryffindor'),
                ),
                DropdownMenuItem(
                  value: 'Slytherin',
                  child: Text('Slytherin'),
                ),
                DropdownMenuItem(
                  value: 'Ravenclaw',
                  child: Text('Ravenclaw'),
                ),
                DropdownMenuItem(
                  value: 'Hufflepuff',
                  child: Text('Hufflepuff'),
                ),
              ],
              onChanged: onHouseChanged,
            ),
            const SizedBox(height: 12),

            // Cupertino House Wheel Picker button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: onCupertinoHousePressed,
                child: const Text(
                  'Cupertino House Wheel Picker',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
