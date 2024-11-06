import 'package:ex_maintenance/main/work_order.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ex_maintenance/components/app_colors.dart';
import 'package:ex_maintenance/components/left_navigation.dart';
import 'package:ex_maintenance/frappe_call/cards.dart';
import 'package:ex_maintenance/frappe_call/requests.dart'; // Import requests API

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isDrawerOpen = false;

  // State variables to hold fetched data
  String averageResponseTime = '';
  int openCount = 0;
  int completedCount = 0;
  List<ExRequest> exRequests = []; // State variable to hold ExRequest documents
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the widget initializes
  }

  Future<void> _fetchData() async {
    try {
      // Fetch work order data for the cards
      WorkOrderCount data = await fetchWorkOrderCount();
      // Fetch ExRequest documents
      List<ExRequest> fetchedRequests = await fetchExRequests();

      setState(() {
        averageResponseTime = data.averageResponseTime;
        openCount = data.openCount;
        completedCount = data.completedCount;
        exRequests = fetchedRequests; // Set fetched requests
        isLoading = false;
      });
    } catch (e) {
      // Handle errors here
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print("Error fetching data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: AppColors.coolGreen,
          onPressed: () {
            setState(() {
              _isDrawerOpen = !_isDrawerOpen;
            });
          },
        ),
      ),
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: _buildMainContent(context),
          ),
          // Overlay when drawer is open
          if (_isDrawerOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isDrawerOpen = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          // Left Navigation
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _isDrawerOpen ? 0 : -250,
            top: 0,
            bottom: 0,
            width: 250,
            child: LeftNavigation(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                  _isDrawerOpen = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent(context);
      case 1:
        return const WorkOrderPage(); // Placeholder for work order page
      default:
        return _buildHomeContent(context);
    }
  }

  Widget _buildHomeContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return _buildWideLayout(context);
        } else {
          return _buildNarrowLayout(context);
        }
      },
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.coolGreen,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCard(context, 'Average Response Time', isLoading ? 'Loading...' : averageResponseTime),
                _buildCard(context, 'Open Maintenance', isLoading ? 'Loading...' : openCount.toString()),
                _buildCard(context, 'Completed Maintenance', isLoading ? 'Loading...' : completedCount.toString()),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Requests',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.coolGreen,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: exRequests.length, // Use the length of fetched requests
                itemBuilder: (context, index) {
                  return _buildDocumentItem(context, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Home',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.coolGreen,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCard(context, 'Average Response Time', isLoading ? 'Loading...' : averageResponseTime),
                  _buildCard(context, 'Open Maintenance', isLoading ? 'Loading...' : openCount.toString()),
                  _buildCard(context, 'Completed Maintenance', isLoading ? 'Loading...' : completedCount.toString()),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Requests',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.coolGreen,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: exRequests.length, // Use the length of fetched requests
                itemBuilder: (context, index) {
                  return _buildDocumentItem(context, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String description) {
    IconData getIconForTitle(String title) {
      if (title.contains('Response')) {
        return Icons.timer_outlined;
      } else if (title.contains('Open')) {
        return Icons.home_repair_service_outlined;
      } else if (title.contains('Completed')) {
        return Icons.task_alt_outlined;
      }
      return Icons.analytics_outlined;
    }

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        color: AppColors.lightGreen,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Background Icon (decorative)
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                getIconForTitle(title),
                size: 120,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            // Main Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon and Title Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          getIconForTitle(title),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    description,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 40,
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

  Widget _buildDocumentItem(BuildContext context, int index) {
    // Ensure exRequests is not empty
    if (index >= exRequests.length) return const SizedBox.shrink();

    final exRequest = exRequests[index];

    return InkWell(
      onTap: () {
        if (kDebugMode) {
          print('Document ${exRequest.name} tapped');
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.description,
              color: AppColors.coolGreen,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exRequest.name, // Display the name of the request
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Created on: ${exRequest.creation.toLocal().toString().split('.')[0]}', // Display the creation date
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
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
