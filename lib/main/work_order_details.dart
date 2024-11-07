// import 'package:ex_maintenance/frappe_call/config.dart';
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
//   late TextEditingController teamDescriptionController;

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
//     teamDescriptionController = TextEditingController(text: widget.workOrderData['team_descriptioninstructions'] ?? '');

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
//     teamDescriptionController.dispose();
//     super.dispose();
//   }


//   void _updateDocument() async {
//     // Convert bool to int for Frappe compatibility
//     int isATeamValue = isTeamChecked ? 1 : 0;
//     int isAnIndividualValue = isIndividualChecked ? 1 : 0;

//     // Prepare the data to send to the API
//     Map<String, dynamic> requestData = {
//       'name': nameController.text,
//       'priority_level': selectedPriority,
//       'status': selectedStatus,
//       'is_a_team': isATeamValue, // Ensure correct int value for Frappe
//       'is_an_indvidual': isAnIndividualValue, // Ensure correct int value for Frappe
//       'deadline_date': deadlineDateController.text,
//       'deadline_time': deadlineTimeController.text,
//       'assign_task': assignTasks.map((task) => {
//             "employee": task['employee'].toString(),
//             "instructions": task['instructions'].toString()
//           }).toList(),
//       'team_descriptioninstructions': teamDescriptionController.text,
//     };

//     // Call API
//     final result = await updateAndAssignExWorkOrder(
//       docName: requestData['name'],
//       priorityLevel: requestData['priority_level'],
//       status: requestData['status'],
//       isATeam: isATeamValue,
//       teamDescriptionInstructions: requestData['team_descriptioninstructions'],
//       isAnIndividual: isAnIndividualValue,
//       deadlineDate: requestData['deadline_date'],
//       deadlineTime: requestData['deadline_time'],
//       assignTask: List<Map<String, String>>.from(requestData['assign_task']),
//     );

//     // Display result message
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
//                   _buildTextField(
//                     label: 'Team Description/Instructions',
//                     controller: teamDescriptionController,
//                     maxLines: 2,
//                   ),
//                 _buildCheckboxField(label: 'To An Individual', value: isIndividualChecked, onChanged: (val) => setState(() => isIndividualChecked = val)),
//                 if (isIndividualChecked) _buildAssignTaskTable(),
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
//     final fullImageUrl = imageUrl != null && imageUrl.isNotEmpty
//         ? (imageUrl.startsWith('http') ? imageUrl : '$baseUrl$imageUrl')
//         : null;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 9),
//         if (fullImageUrl != null)
//           Container(
//             height: 500,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 fullImageUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.error, color: Colors.red),
//                         SizedBox(height: 8),
//                         Text('Failed to load image'),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           )
//         else
//           Container(
//             height: 200,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey.shade300),
//               color: Colors.grey[200],
//             ),
//             alignment: Alignment.center,
//             child: const Text('No Image Available', style: TextStyle(color: Colors.grey)),
//           ),
//       ],
//     );
//   }

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
//           setState(() => controller.text = "${pickedDate.toLocal()}".split(' ')[0]);
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
//           setState(() => controller.text = pickedTime.format(context));
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
//                   onPressed: () => setState(() => assignTasks.remove(task)),
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//         TextButton(
//           style: TextButton.styleFrom(backgroundColor: AppColors.coolGreen),
//           onPressed: () => setState(() => assignTasks.add({'employee': '', 'instructions': ''})),
//           child: const Text('Add Task', style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }
// }
























// import 'package:ex_maintenance/frappe_call/config.dart';
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
//   late TextEditingController teamDescriptionController;

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
//     teamDescriptionController = TextEditingController(text: widget.workOrderData['team_descriptioninstructions'] ?? '');

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
//     teamDescriptionController.dispose();
//     super.dispose();
//   }

//   void _updateDocument() async {
//     // Convert bool to int for Frappe compatibility
//     int isATeamValue = isTeamChecked ? 1 : 0;
//     int isAnIndividualValue = isIndividualChecked ? 1 : 0;

//     // Prepare the data to send to the API
//     Map<String, dynamic> requestData = {
//       'name': nameController.text,
//       'priority_level': selectedPriority,
//       'status': selectedStatus,
//       'is_a_team': isATeamValue, // Ensure correct int value for Frappe
//       'is_an_indvidual': isAnIndividualValue, // Ensure correct int value for Frappe
//       'deadline_date': deadlineDateController.text,
//       'deadline_time': deadlineTimeController.text,
//       'assign_task': assignTasks.map((task) => {
//             "employee": task['employee'].toString(),
//             "instructions": task['instructions'].toString()
//           }).toList(),
//       'team_descriptioninstructions': teamDescriptionController.text,
//     };

//     // Call API
//     final result = await updateAndAssignExWorkOrder(
//       docName: requestData['name'],
//       priorityLevel: requestData['priority_level'],
//       status: requestData['status'],
//       isATeam: isATeamValue,
//       teamDescriptionInstructions: requestData['team_descriptioninstructions'],
//       isAnIndividual: isAnIndividualValue,
//       deadlineDate: requestData['deadline_date'],
//       deadlineTime: requestData['deadline_time'],
//       assignTask: List<Map<String, String>>.from(requestData['assign_task']),
//     );

//     // Display result message
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
//                 _buildTextField(label: 'Name', controller: nameController, readOnly: true),
//                 _buildTextField(label: 'Location', controller: locationController, readOnly: true),
//                 _buildTextField(label: 'Request Code', controller: requestCodeController, readOnly: true),
//                 _buildTextField(label: 'Room Number', controller: roomNumberController, readOnly: true),
//                 _buildTextField(label: 'Other', controller: otherController, readOnly: true),
//                 _buildImageField(label: 'Image', imageUrl: widget.workOrderData['image']),
//                 _buildTextField(label: 'Date', controller: dateController, readOnly: true),
//                 _buildTextField(label: 'Time', controller: timeController, readOnly: true),
//                 _buildTextField(label: 'Further Information', controller: furtherInfoController, maxLines: 3, readOnly: true),
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
//                   _buildTextField(
//                     label: 'Team Description/Instructions',
//                     controller: teamDescriptionController,
//                     maxLines: 2,
//                   ),
//                 _buildCheckboxField(label: 'To An Individual', value: isIndividualChecked, onChanged: (val) => setState(() => isIndividualChecked = val)),
//                 if (isIndividualChecked) _buildAssignTaskTable(),
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
//     final fullImageUrl = imageUrl != null && imageUrl.isNotEmpty
//         ? (imageUrl.startsWith('http') ? imageUrl : '$baseUrl$imageUrl')
//         : null;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 9),
//         if (fullImageUrl != null)
//           Container(
//             height: 500,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 fullImageUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.error, color: Colors.red),
//                         SizedBox(height: 8),
//                         Text('Failed to load image'),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           )
//         else
//           Container(
//             height: 200,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey.shade300),
//               color: Colors.grey[200],
//             ),
//             alignment: Alignment.center,
//             child: const Text('No Image Available', style: TextStyle(color: Colors.grey)),
//           ),
//       ],
//     );
//   }

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
//           setState(() => controller.text = "${pickedDate.toLocal()}".split(' ')[0]);
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
//           setState(() => controller.text = pickedTime.format(context));
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
//                   onPressed: () => setState(() => assignTasks.remove(task)),
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//         TextButton(
//           style: TextButton.styleFrom(backgroundColor: AppColors.coolGreen),
//           onPressed: () => setState(() => assignTasks.add({'employee': '', 'instructions': ''})),
//           child: const Text('Add Task', style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }
// }


















import 'package:ex_maintenance/frappe_call/config.dart';
import 'package:ex_maintenance/frappe_call/users_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  late TextEditingController teamDescriptionController;

  // List to hold assign task rows
  List<Map<String, dynamic>> assignTasks = [];
  List<String> allEmails = [];
  bool isLoadingEmails = true;
  final Map<int, TextEditingController> _employeeControllers = {}; // Store controllers by index
// Use a single filtered email list

  Future<void> _fetchEmails() async {
    try {
      allEmails = await fetchUserEmails();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching emails: $e');
      }
    }
    setState(() {
      isLoadingEmails = false;
    });
  }


  @override
  void initState() {
    super.initState();
    isTeamChecked = widget.workOrderData['is_a_team'] == 1;
    isIndividualChecked = widget.workOrderData['is_an_individual'] == 1;
    selectedPriority = widget.workOrderData['priority_level'] ?? 'Low';
    selectedStatus = widget.workOrderData['status'] ?? 'Open';
    _fetchEmails();

    // Initialize controllers
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
    teamDescriptionController = TextEditingController(text: widget.workOrderData['team_descriptioninstructions'] ?? '');

    // Initialize assignTasks with existing data if available
    assignTasks = (widget.workOrderData['assign_task'] as List<dynamic>?)
            ?.map((task) => Map<String, dynamic>.from(task))
            .toList() ??
        [];
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
    teamDescriptionController.dispose();
    super.dispose();
  }

  void _updateDocument() async {
    // Convert bool to int for Frappe compatibility
    int isATeamValue = isTeamChecked ? 1 : 0;
    int isAnIndividualValue = isIndividualChecked ? 1 : 0;

    // Prepare the data to send to the API
    Map<String, dynamic> requestData = {
      'name': nameController.text,
      'priority_level': selectedPriority,
      'status': selectedStatus,
      'is_a_team': isATeamValue, // Ensure correct int value for Frappe
      'is_an_indvidual': isAnIndividualValue, // Ensure correct int value for Frappe
      'deadline_date': deadlineDateController.text,
      'deadline_time': deadlineTimeController.text,
      'assign_task': assignTasks.map((task) => {
            "employee": task['employee'].toString(),
            "instructions": task['instructions'].toString()
          }).toList(),
      'team_descriptioninstructions': teamDescriptionController.text,
    };

    // Call API
    final result = await updateAndAssignExWorkOrder(
      docName: requestData['name'],
      priorityLevel: requestData['priority_level'],
      status: requestData['status'],
      isATeam: isATeamValue,
      teamDescriptionInstructions: requestData['team_descriptioninstructions'],
      isAnIndividual: isAnIndividualValue,
      deadlineDate: requestData['deadline_date'],
      deadlineTime: requestData['deadline_time'],
      assignTask: List<Map<String, String>>.from(requestData['assign_task']),
    );

    // Display result message
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
                _buildTextField(label: 'Name', controller: nameController, readOnly: true),
                _buildTextField(label: 'Location', controller: locationController, readOnly: true),
                _buildTextField(label: 'Request Code', controller: requestCodeController, readOnly: true),
                _buildTextField(label: 'Room Number', controller: roomNumberController, readOnly: true),
                _buildTextField(label: 'Other', controller: otherController, readOnly: true),
                _buildImageField(label: 'Image', imageUrl: widget.workOrderData['image']),
                _buildTextField(label: 'Date', controller: dateController, readOnly: true),
                _buildTextField(label: 'Time', controller: timeController, readOnly: true),
                _buildTextField(label: 'Further Information', controller: furtherInfoController, maxLines: 3, readOnly: true),
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
                _buildCheckboxField(label: 'To The Team', value: isTeamChecked, onChanged: (val) => setState(() => isTeamChecked = val)),
                if (isTeamChecked)
                  _buildTextField(
                    label: 'Team Description/Instructions',
                    controller: teamDescriptionController,
                    maxLines: 2,
                  ),
                _buildCheckboxField(label: 'To An Individual', value: isIndividualChecked, onChanged: (val) => setState(() => isIndividualChecked = val)),
                if (isIndividualChecked) _buildAssignTaskTable(),
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
              children: content.map((field) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: field,
              )).toList(),
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
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        SizedBox(height: 8),
                        Text('Failed to load image'),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        else
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 6, offset: const Offset(0, 3))],
          ),
          child: DataTable(
            headingRowHeight: 40,
            headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
            columnSpacing: 20,
            columns: const [
              DataColumn(label: Text('No.', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Issue Type', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: issues.map<DataRow>((issue) {
              return DataRow(
                cells: [
                  DataCell(Text(issue['idx'].toString())),
                  DataCell(Text(issue['issue_type'] ?? '')),
                  DataCell(Text(issue['description'] ?? '')),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label, required String value, required List<String> options, required ValueChanged<String?> onChanged}) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: options.map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
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
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
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
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: const Icon(Icons.access_time, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          readOnly: true,
        ),
      ),
    );
  }

  void _onEmployeeChanged(int index, String input) {
    setState(() {
      assignTasks[index]['filteredEmails'] = allEmails
          .where((email) => email.toLowerCase().contains(input.toLowerCase()))
          .take(4) // Limit to top 4 suggestions
          .toList();
      assignTasks[index]['employee'] = input; // Update the task's employee value
    });
  }


  Widget _buildAssignTaskTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Assign Task', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Column(
          children: assignTasks.asMap().entries.map<Widget>((entry) {
            int index = entry.key;
            Map<String, dynamic> task = entry.value;

            // Assign a controller if not already assigned
            _employeeControllers[index] ??= TextEditingController(text: task['employee'] ?? '');

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            setState(() => task['filteredEmails'] = []);
                          }
                        },
                        child: TextFormField(
                          controller: _employeeControllers[index],
                          decoration: const InputDecoration(labelText: 'Employee'),
                          onChanged: (value) => _onEmployeeChanged(index, value),
                        ),
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
                      onPressed: () => setState(() {
                        assignTasks.removeAt(index);
                        _employeeControllers.remove(index);
                      }),
                    ),
                  ],
                ),
                // Display email suggestions if available
                if (task['filteredEmails'] != null && task['filteredEmails'].isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: task['filteredEmails'].map<Widget>((email) {
                        return ListTile(
                          title: Text(email),
                          onTap: () {
                            setState(() {
                              _employeeControllers[index]!.text = email;
                              task['employee'] = email;
                              task['filteredEmails'] = [];
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: AppColors.coolGreen),
          onPressed: () => setState(() => assignTasks.add({'employee': '', 'instructions': '', 'filteredEmails': []})),
          child: const Text('Add Task', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}