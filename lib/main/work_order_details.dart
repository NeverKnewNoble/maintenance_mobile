// import 'package:ex_maintenance/frappe_call/config.dart';
// import 'package:ex_maintenance/frappe_call/order_details.dart';
// import 'package:flutter/material.dart';
// import 'package:ex_maintenance/components/app_colors.dart';
// import 'package:ex_maintenance/frappe_call/api_service.dart';

// class WorkOrderDetails extends StatefulWidget {
//   final Map<String, dynamic> workOrderData;

//   const WorkOrderDetails({super.key, required this.workOrderData});

//   @override
//   WorkOrderDetailsState createState() => WorkOrderDetailsState();
// }

// class WorkOrderDetailsState extends State<WorkOrderDetails> {
//   bool isTeamChecked = false;
//   bool isIndividualChecked = false;

//   // Default values for dropdown selections
//   late String selectedPriority;
//   late String selectedStatus;

//   // Controllers for text fields
//   late TextEditingController nameController;
//   late TextEditingController locationController;
//   late TextEditingController requestCodeController;
//   late TextEditingController roomNumberController;
//   late TextEditingController otherController;
//   late TextEditingController dateController;
//   late TextEditingController timeController;
//   late TextEditingController furtherInfoController;
//   late TextEditingController deadlineDateController;
//   late TextEditingController deadlineTimeController;

//   // List to hold assign task rows
//   List<Map<String, dynamic>> assignTasks = [];

//   @override
//   void initState() {
//     super.initState();
//     isTeamChecked = widget.workOrderData['is_a_team'] == 1;
//     isIndividualChecked = widget.workOrderData['is_an_individual'] == 1;
//     selectedPriority = widget.workOrderData['priority_level'] ?? 'Low';
//     selectedStatus = widget.workOrderData['status'] ?? 'Open';

//     // Initialize controllers
//     nameController = TextEditingController(text: widget.workOrderData['name'] ?? '');
//     locationController = TextEditingController(text: widget.workOrderData['location'] ?? '');
//     requestCodeController = TextEditingController(text: widget.workOrderData['request_code'] ?? '');
//     roomNumberController = TextEditingController(text: widget.workOrderData['room_number'] ?? '');
//     otherController = TextEditingController(text: widget.workOrderData['other'] ?? '');
//     dateController = TextEditingController(text: widget.workOrderData['date'] ?? '');
//     timeController = TextEditingController(text: widget.workOrderData['time'] ?? '');
//     furtherInfoController = TextEditingController(text: widget.workOrderData['further_information'] ?? '');
//     deadlineDateController = TextEditingController(text: widget.workOrderData['deadline_date'] ?? '');
//     deadlineTimeController = TextEditingController(text: widget.workOrderData['deadline_time'] ?? '');

//     // Initialize assignTasks with existing data if available
//     assignTasks = (widget.workOrderData['assign_task'] as List<dynamic>?)
//             ?.map((task) => Map<String, dynamic>.from(task))
//             .toList() ??
//         [];
//   }

//   @override
//   void dispose() {
//     // Dispose controllers
//     nameController.dispose();
//     locationController.dispose();
//     requestCodeController.dispose();
//     roomNumberController.dispose();
//     otherController.dispose();
//     dateController.dispose();
//     timeController.dispose();
//     furtherInfoController.dispose();
//     deadlineDateController.dispose();
//     deadlineTimeController.dispose();
//     super.dispose();
//   }

//   void _updateDocument() async {
//     final apiService = ApiService();

//     // Prepare the data to send to the API
//     Map<String, dynamic> requestData = {
//       'name': widget.workOrderData['name'],
//       'priority_level': selectedPriority,
//       'status': selectedStatus,
//       'is_a_team': isTeamChecked ? 1 : 0,
//       'is_an_individual': isIndividualChecked ? 1 : 0,
//       'deadline_date': deadlineDateController.text,
//       'deadline_time': deadlineTimeController.text,
//       'assign_task': assignTasks,
//       'team_descriptioninstructions': widget.workOrderData['team_descriptioninstructions'],
//       'status_change_logs': widget.workOrderData['status_change_logs'],
//     };

//     final result = await apiService.updateExWorkOrder(requestData);

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result["status"] == "success" ? result["message"] : "Error: ${result["message"]}")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Work Order Details',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
//         ),
//         backgroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             _buildSection(
//               title: 'Request Details',
//               content: [
//                 _buildTextField(label: 'Name', controller: nameController),
//                 _buildTextField(label: 'Location', controller: locationController),
//                 _buildTextField(label: 'Request Code', controller: requestCodeController),
//                 _buildTextField(label: 'Room Number', controller: roomNumberController),
//                 _buildTextField(label: 'Other', controller: otherController),
//                 _buildImageField(label: 'Image', imageUrl: widget.workOrderData['image']),
//                 _buildTextField(label: 'Date', controller: dateController),
//                 _buildTextField(label: 'Time', controller: timeController),
//                 _buildTextField(label: 'Further Information', controller: furtherInfoController, maxLines: 3),
//                 _buildStyledIssueTable(widget.workOrderData['issues'] ?? []),
//               ],
//             ),
//             const SizedBox(height: 30),
//             _buildSection(
//               title: 'Management',
//               content: [
//                 _buildDropdownField(
//                   label: 'Priority Level',
//                   value: selectedPriority,
//                   options: ['Low', 'Medium', 'High', 'Urgent'],
//                   onChanged: (String? newValue) {
//                     if (newValue != null) {
//                       setState(() => selectedPriority = newValue);
//                     }
//                   },
//                 ),
//                 _buildDropdownField(
//                   label: 'Status',
//                   value: selectedStatus,
//                   options: ['Open', 'In Progress', 'Completed', 'Overdue'],
//                   onChanged: (String? newValue) {
//                     if (newValue != null) {
//                       setState(() => selectedStatus = newValue);
//                     }
//                   },
//                 ),
//                 _buildDateField(label: 'Deadline Date', controller: deadlineDateController),
//                 _buildTimeField(label: 'Deadline Time', controller: deadlineTimeController),
//                 _buildCheckboxField(label: 'To The Team', value: isTeamChecked, onChanged: (val) => setState(() => isTeamChecked = val)),
//                 if (isTeamChecked)
//                   _buildTextField(label: 'Team Description/Instructions', controller: TextEditingController(text: widget.workOrderData['team_descriptioninstructions'] ?? ''), maxLines: 2),
//                 _buildCheckboxField(label: 'To An Individual', value: isIndividualChecked, onChanged: (val) => setState(() => isIndividualChecked = val)),
//                 if (isIndividualChecked)
//                   _buildAssignTaskTable(),
//               ],
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: _updateDocument,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.coolGreen,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               child: const Text('Update Document', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSection({required String title, required List<Widget> content}) {
//     return Card(
//       elevation: 4,
//       margin: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
//             ),
//             const SizedBox(height: 12),
//             Column(
//               children: content.map((field) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 6.0),
//                 child: field,
//               )).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({required String label, required TextEditingController controller, int maxLines = 1, bool readOnly = false}) {
//     return TextFormField(
//       maxLines: maxLines,
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//       readOnly: readOnly,
//     );
//   }

//   Widget _buildImageField({required String label, required String? imageUrl}) {
//       final fullImageUrl = imageUrl != null && imageUrl.isNotEmpty
//           ? (imageUrl.startsWith('http') ? imageUrl : '$baseUrl$imageUrl')
//           : null;

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 9),
//           if (fullImageUrl != null)
//             Container(
//               height: 500,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   fullImageUrl,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.error, color: Colors.red),
//                           SizedBox(height: 8),
//                           Text('Failed to load image'),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             )
//           else
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade300),
//                 color: Colors.grey[200],
//               ),
//               alignment: Alignment.center,
//               child: const Text('No Image Available', style: TextStyle(color: Colors.grey)),
//             ),
//         ],
//       );
//     }


//   Widget _buildStyledIssueTable(List issues) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Issues', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(8.0),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey.shade300),
//             boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 6, offset: const Offset(0, 3))],
//           ),
//           child: DataTable(
//             headingRowHeight: 40,
//             headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
//             columnSpacing: 20,
//             columns: const [
//               DataColumn(label: Text('No.', style: TextStyle(fontWeight: FontWeight.bold))),
//               DataColumn(label: Text('Issue Type', style: TextStyle(fontWeight: FontWeight.bold))),
//               DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
//             ],
//             rows: issues.map<DataRow>((issue) {
//               return DataRow(
//                 cells: [
//                   DataCell(Text(issue['idx'].toString())),
//                   DataCell(Text(issue['issue_type'] ?? '')),
//                   DataCell(Text(issue['description'] ?? '')),
//                 ],
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDropdownField({required String label, required String value, required List<String> options, required ValueChanged<String?> onChanged}) {
//     return InputDecorator(
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value,
//           items: options.map((option) {
//             return DropdownMenuItem(value: option, child: Text(option));
//           }).toList(),
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }

//   Widget _buildCheckboxField({required String label, required bool value, required Function(bool) onChanged}) {
//     return Row(
//       children: [
//         Checkbox(
//           value: value,
//           activeColor: AppColors.coolGreen,
//           onChanged: (bool? newValue) {
//             if (newValue != null) onChanged(newValue);
//           },
//         ),
//         Text(label, style: const TextStyle(fontSize: 16)),
//       ],
//     );
//   }

//   Widget _buildDateField({required String label, required TextEditingController controller}) {
//     return GestureDetector(
//       onTap: () async {
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(2000),
//           lastDate: DateTime(2101),
//         );
//         if (pickedDate != null) {
//           setState(() {
//             controller.text = "${pickedDate.toLocal()}".split(' ')[0];
//           });
//         }
//       },
//       child: AbsorbPointer(
//         child: TextFormField(
//           controller: controller,
//           decoration: InputDecoration(
//             labelText: label,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//             suffixIcon: const Icon(Icons.calendar_today, size: 20),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           ),
//           readOnly: true,
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeField({required String label, required TextEditingController controller}) {
//     return GestureDetector(
//       onTap: () async {
//         TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
//         if (pickedTime != null) {
//           setState(() {
//             controller.text = pickedTime.format(context);
//           });
//         }
//       },
//       child: AbsorbPointer(
//         child: TextFormField(
//           controller: controller,
//           decoration: InputDecoration(
//             labelText: label,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//             suffixIcon: const Icon(Icons.access_time, size: 20),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           ),
//           readOnly: true,
//         ),
//       ),
//     );
//   }

//   Widget _buildAssignTaskTable() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Assign Task', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         Column(
//           children: assignTasks.map<Widget>((task) {
//             return Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     initialValue: task['employee'] ?? '',
//                     decoration: const InputDecoration(labelText: 'Employee'),
//                     onChanged: (value) => setState(() => task['employee'] = value),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextFormField(
//                     initialValue: task['instructions'] ?? '',
//                     decoration: const InputDecoration(labelText: 'Instructions'),
//                     onChanged: (value) => setState(() => task['instructions'] = value),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete),
//                   onPressed: () => setState(() {
//                     assignTasks.remove(task);
//                   }),
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//         TextButton(
//           style: TextButton.styleFrom(backgroundColor: AppColors.coolGreen),
//           onPressed: () => setState(() {
//             assignTasks.add({'employee': '', 'instructions': ''});
//           }),
//           child: const Text('Add Task', style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }
// }










import 'package:flutter/material.dart';
import 'package:ex_maintenance/frappe_call/config.dart';
import 'package:ex_maintenance/components/app_colors.dart';
import 'package:ex_maintenance/frappe_call/api_service.dart';

class WorkOrderDetails extends StatefulWidget {
  final Map<String, dynamic> workOrderData;

  const WorkOrderDetails({super.key, required this.workOrderData});

  @override
  WorkOrderDetailsState createState() => WorkOrderDetailsState();
}

class WorkOrderDetailsState extends State<WorkOrderDetails> {
  bool isTeamChecked = false;
  bool isIndividualChecked = false;

  // Default values for dropdown selections
  late String selectedPriority;
  late String selectedStatus;

  // Controllers for text fields
  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController requestCodeController;
  late TextEditingController roomNumberController;
  late TextEditingController otherController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController furtherInfoController;
  late TextEditingController deadlineDateController;
  late TextEditingController deadlineTimeController;

  // List to hold assign task rows
  List<Map<String, dynamic>> assignTasks = [];

  @override
  void initState() {
    super.initState();
    // Initialize state from widget data
    isTeamChecked = widget.workOrderData['is_a_team'] == 1;
    isIndividualChecked = widget.workOrderData['is_an_individual'] == 1;
    selectedPriority = widget.workOrderData['priority_level'] ?? 'Low';
    selectedStatus = widget.workOrderData['status'] ?? 'Open';

    // Initialize controllers with existing data
    nameController = TextEditingController(text: widget.workOrderData['name'] ?? '');
    locationController = TextEditingController(text: widget.workOrderData['location'] ?? '');
    requestCodeController = TextEditingController(text: widget.workOrderData['request_code'] ?? '');
    roomNumberController = TextEditingController(text: widget.workOrderData['room_number'] ?? '');
    otherController = TextEditingController(text: widget.workOrderData['other'] ?? '');
    dateController = TextEditingController(text: widget.workOrderData['date'] ?? '');
    timeController = TextEditingController(text: widget.workOrderData['time'] ?? '');
    furtherInfoController = TextEditingController(text: widget.workOrderData['further_information'] ?? '');
    deadlineDateController = TextEditingController(text: widget.workOrderData['deadline_date'] ?? '');
    deadlineTimeController = TextEditingController(text: widget.workOrderData['deadline_time'] ?? '');

    // Populate assignTasks if available
    assignTasks = (widget.workOrderData['assign_task'] as List<dynamic>?)
            ?.map((task) => Map<String, dynamic>.from(task))
            .toList() ?? [];
  }

  @override
  void dispose() {
    // Dispose controllers
    nameController.dispose();
    locationController.dispose();
    requestCodeController.dispose();
    roomNumberController.dispose();
    otherController.dispose();
    dateController.dispose();
    timeController.dispose();
    furtherInfoController.dispose();
    deadlineDateController.dispose();
    deadlineTimeController.dispose();
    super.dispose();
  }

  void _updateDocument() async {
    // Prepare data for API request
    Map<String, dynamic> requestData = {
      'name': widget.workOrderData['name'],
      'priority_level': selectedPriority,
      'status': selectedStatus,
      'is_a_team': isTeamChecked ? 1 : 0,
      'is_an_individual': isIndividualChecked ? 1 : 0,
      'deadline_date': deadlineDateController.text,
      'deadline_time': deadlineTimeController.text,
      'assign_task': assignTasks,
      'team_descriptioninstructions': widget.workOrderData['team_descriptioninstructions'],
      'status_change_logs': widget.workOrderData['status_change_logs'],
    };

    // Call API
    final result = await updateExWorkOrder(requestData);

    // Show result
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["status"] == "success" ? result["message"] : "Error: ${result["message"]}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Work Order Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSection(
              title: 'Request Details',
              content: [
                _buildTextField(label: 'Name', controller: nameController),
                _buildTextField(label: 'Location', controller: locationController),
                _buildTextField(label: 'Request Code', controller: requestCodeController),
                _buildTextField(label: 'Room Number', controller: roomNumberController),
                _buildTextField(label: 'Other', controller: otherController),
                _buildImageField(label: 'Image', imageUrl: widget.workOrderData['image']),
                _buildTextField(label: 'Date', controller: dateController),
                _buildTextField(label: 'Time', controller: timeController),
                _buildTextField(label: 'Further Information', controller: furtherInfoController, maxLines: 3),
                _buildStyledIssueTable(widget.workOrderData['issues'] ?? []),
              ],
            ),
            const SizedBox(height: 30),
            _buildSection(
              title: 'Management',
              content: [
                _buildDropdownField(
                  label: 'Priority Level',
                  value: selectedPriority,
                  options: ['Low', 'Medium', 'High', 'Urgent'],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => selectedPriority = newValue);
                    }
                  },
                ),
                _buildDropdownField(
                  label: 'Status',
                  value: selectedStatus,
                  options: ['Open', 'In Progress', 'Completed', 'Overdue'],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => selectedStatus = newValue);
                    }
                  },
                ),
                _buildDateField(label: 'Deadline Date', controller: deadlineDateController),
                _buildTimeField(label: 'Deadline Time', controller: deadlineTimeController),
                _buildCheckboxField(
                  label: 'To The Team', 
                  value: isTeamChecked, 
                  onChanged: (val) => setState(() => isTeamChecked = val),
                ),
                _buildCheckboxField(
                  label: 'To An Individual', 
                  value: isIndividualChecked, 
                  onChanged: (val) => setState(() => isIndividualChecked = val),
                ),

              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updateDocument,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coolGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Update Document', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> content}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
            ),
            const SizedBox(height: 12),
            Column(
              children: content.map((field) => Padding(padding: const EdgeInsets.symmetric(vertical: 6.0), child: field)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, int maxLines = 1, bool readOnly = false}) {
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      readOnly: readOnly,
    );
  }

  Widget _buildImageField({required String label, required String? imageUrl}) {
    final fullImageUrl = imageUrl != null && imageUrl.isNotEmpty
        ? (imageUrl.startsWith('http') ? imageUrl : '$baseUrl$imageUrl')
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 9),
        if (fullImageUrl != null)
          Container(
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                fullImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Text('Failed to load image', style: TextStyle(color: Colors.red)),
                ),
              ),
            ),
          )
        else
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            alignment: Alignment.center,
            child: const Text('No Image Available', style: TextStyle(color: Colors.grey)),
          ),
      ],
    );
  }

  Widget _buildStyledIssueTable(List issues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Issues', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DataTable(
          columns: const [
            DataColumn(label: Text('No.')),
            DataColumn(label: Text('Issue Type')),
            DataColumn(label: Text('Description')),
          ],
          rows: issues.map((issue) => DataRow(cells: [
            DataCell(Text(issue['idx'].toString())),
            DataCell(Text(issue['issue_type'] ?? '')),
            DataCell(Text(issue['description'] ?? '')),
          ])).toList(),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label, required String value, required List<String> options, required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildCheckboxField({required String label, required bool value, required Function(bool) onChanged}) {
    return Row(
      children: [
        Checkbox(
          value: value,
          activeColor: AppColors.coolGreen,
          onChanged: (bool? newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }


  Widget _buildDateField({required String label, required TextEditingController controller}) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          setState(() => controller.text = "${pickedDate.toLocal()}".split(' ')[0]);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label, suffixIcon: const Icon(Icons.calendar_today)),
          readOnly: true,
        ),
      ),
    );
  }

  Widget _buildTimeField({required String label, required TextEditingController controller}) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
        if (pickedTime != null) {
          setState(() => controller.text = pickedTime.format(context));
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label, suffixIcon: const Icon(Icons.access_time)),
          readOnly: true,
        ),
      ),
    );
  }

  Widget _buildAssignTaskTable() {
    return Column(
      children: assignTasks.map((task) {
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: task['employee'] ?? '',
                decoration: const InputDecoration(labelText: 'Employee'),
                onChanged: (value) => setState(() => task['employee'] = value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                initialValue: task['instructions'] ?? '',
                decoration: const InputDecoration(labelText: 'Instructions'),
                onChanged: (value) => setState(() => task['instructions'] = value),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => setState(() => assignTasks.remove(task)),
            ),
          ],
        );
      }).toList()
        ..add(
          TextButton(
            onPressed: () => setState(() => assignTasks.add({'employee': '', 'instructions': ''})),
            child: const Text('Add Task', style: TextStyle(color: Colors.white)),
          ) as Row,
        ),
    );
  }
}



















