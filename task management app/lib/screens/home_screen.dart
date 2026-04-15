import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/progress_header.dart';
import 'analytics_screen.dart';

import '../services/biometric_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedFilter = 'All';
  bool _isAuthenticated = true; // Temporarily bypassed for testing/emulator
  final BiometricService _biometricService = BiometricService();

  @override
  void initState() {
    super.initState();
    // _authenticate(); // Disabled for emulator testing
  }

  Future<void> _authenticate() async {
    if (kIsWeb) {
      // Biometrics not supported on web - skip authentication
      setState(() => _isAuthenticated = true);
      return;
    }
    final bool authenticated = await _biometricService.authenticate();
    setState(() {
      _isAuthenticated = authenticated;
    });
  }

  final List<String> _filters = ['All', 'Work', 'Personal', 'Shopping', 'Health', 'Finance'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),
              const Text(
                'Task Manager Locked',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Unlock with Biometrics'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isAuthenticated = true; // Bypass for testing/emulator
                  });
                },
                child: const Text('Skip for now (Testing Only)',
                    style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      );
    }

    final taskProvider = Provider.of<TaskProvider>(context);
    final String todayDate = DateFormat('EEEE, d MMM').format(DateTime.now());

    // Filter tasks based on selected category
    final tasks = _selectedFilter == 'All'
        ? taskProvider.tasks
        : taskProvider.tasks.where((t) => t.category == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF141416)
          : const Color(0xFFF8F9FE),
      body: _selectedIndex == 1
          ? const AnalyticsScreen()
          : IndexedStack(
              index: 0,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        // Header and Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Task Manager Pro',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  todayDate,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            // User Profile Avatar (Mock)
                            const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.blueAccent,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Progress Widget
                        const ProgressHeader(),
                        const SizedBox(height: 30),
                        // Category Filters
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filters.length,
                            itemBuilder: (context, index) {
                              final isSelected = _selectedFilter == _filters[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: ChoiceChip(
                                  label: Text(_filters[index]),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedFilter = _filters[index];
                                      });
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        // List of Tasks
                        Expanded(
                          child: taskProvider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : tasks.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.inventory_2_outlined,
                                              size: 64, color: Colors.grey.shade300),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No tasks found for "$_selectedFilter"',
                                            style: TextStyle(
                                                color: Colors.grey.shade400, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: tasks.length,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      itemBuilder: (context, index) {
                                        final task = tasks[index];
                                        return TaskCard(
                                          task: task,
                                          onToggle: () =>
                                              taskProvider.toggleTaskStatus(task.id),
                                          onDelete: () => taskProvider.deleteTask(task.id),
                                        );
                                      },
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Analytics',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  builder: (context) => AddTaskBottomSheet(onAddTask: (task) {
                    taskProvider.addTask(task);
                  }),
                );
              },
              backgroundColor: Colors.blueAccent,
              elevation: 4,
              child: const Icon(Icons.add, size: 28, color: Colors.white),
            )
          : null,
    );
  }
}
