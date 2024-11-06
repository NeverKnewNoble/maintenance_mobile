import 'package:ex_maintenance/frappe_call/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ex_maintenance/components/app_colors.dart';
import 'package:ex_maintenance/frappe_call/ex_work_order_ui.dart';
import 'work_order_details.dart'; // Import the WorkOrderDetails page
import 'package:ex_maintenance/frappe_call/order_details.dart';

class WorkOrderPage extends StatefulWidget {
  const WorkOrderPage({super.key});

  @override
  WorkOrderPageState createState() => WorkOrderPageState();
}

class WorkOrderPageState extends State<WorkOrderPage> {
  List<ExWorkOrder> workOrders = [];
  List<ExWorkOrder> filteredWorkOrders = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();
  final ApiService apiService = ApiService(baseUrl: baseUrl);

  @override
  void initState() {
    super.initState();
    _fetchWorkOrders();
    searchController.addListener(_filterWorkOrders);
  }

  Future<void> _fetchWorkOrders() async {
    try {
      List<ExWorkOrder> fetchedWorkOrders = await fetchExWorkOrders();
      setState(() {
        workOrders = fetchedWorkOrders;
        filteredWorkOrders = fetchedWorkOrders;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (kDebugMode) {
        print("Error fetching work orders: $e");
      }
    }
  }

  void _filterWorkOrders() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredWorkOrders = workOrders.where((order) => order.name.toLowerCase().contains(query)).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ex Work Order',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.coolGreen,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search work orders...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.coolGreen),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildFilterButton(),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredWorkOrders.isEmpty
                          ? const Center(child: Text('No work orders found'))
                          : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredWorkOrders.length,
                              separatorBuilder: (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) => _buildWorkOrderItem(filteredWorkOrders[index]),
                            ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: const Icon(Icons.filter_list),
        onPressed: () {
          // Implement filter functionality
        },
        tooltip: 'Filter work orders',
      ),
    );
  }

  Widget _buildWorkOrderItem(ExWorkOrder workOrder) {
    final StatusData statusData = _getStatusData(workOrder.status);

    return InkWell(
      onTap: () => _navigateToWorkOrderDetails(workOrder.name),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
                    workOrder.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Priority: ${workOrder.priorityLevel}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Date: ${workOrder.date ?? 'Not Available'}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusData.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                statusData.label,
                style: TextStyle(
                  color: statusData.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToWorkOrderDetails(String workOrderName) async {
    setState(() => isLoading = true);

    final response = await apiService.getAllExWorkOrders();
    if (!mounted) return;

    setState(() => isLoading = false);

    if (response.containsKey('data') && response['data'] != null) {
      final workOrderDetails = response['data']['data']
          .firstWhere((workOrder) => workOrder['name'] == workOrderName, orElse: () => null);

      if (workOrderDetails != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WorkOrderDetails(workOrderData: workOrderDetails),
          ),
        );
      } else {
        _showError('Work order details not found.');
      }
    } else {
      _showError(response['error'] ?? 'Failed to load work order details.');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  StatusData _getStatusData(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return StatusData('Open', Colors.black);
      case 'in progress':
        return StatusData('In Progress', Colors.blue);
      case 'completed':
        return StatusData('Completed', Colors.green);
      case 'overdue':
        return StatusData('Overdue', Colors.red);
      default:
        return StatusData('Open', Colors.red);
    }
  }
}

class StatusData {
  final String label;
  final Color color;

  StatusData(this.label, this.color);
}
