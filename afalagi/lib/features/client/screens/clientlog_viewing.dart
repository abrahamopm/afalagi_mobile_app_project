import 'package:flutter/material.dart';

class LogViewingScreen extends StatefulWidget {
  const LogViewingScreen({Key? key}) : super(key: key);

  @override
  _LogViewingScreenState createState() => _LogViewingScreenState();
}

class _LogViewingScreenState extends State<LogViewingScreen> {
  String? selectedClient;
  String? selectedProperty;
  int _rating = 0;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  final List<String> _clients = [
    'Dawit Mengistu',
    'Sara Haile',
    'Abebe Yosef',
    'Martha Tadesse',
  ];

  final List<String> _properties = [
    'Bole Atlantis Penthouse',
    'Old Airport Villa',
    'Kazanchis Studio',
    'Summit Apartment'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B365D)),
          onPressed: () {},
        ),
        title: Row(
          children: [
            Icon(Icons.home_work_outlined, color: Color(0xFF1E566E), size: 28),
            const SizedBox(width: 8),
            Text('Afalagi', style: TextStyle(color: Color(0xFF1E566E), fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text('Log a Viewing', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1B365D))),
              const SizedBox(height: 8),
              Text(
                'Record client feedback for a property\nviewing in Addis Ababa.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              const SizedBox(height: 30),
              
              // Select Client
              _buildSection(
                title: 'SELECT CLIENT',
                child: FormField<String>(
                  validator: (value) => selectedClient == null ? 'Please select a client' : null,
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F7FA),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: state.hasError ? Colors.red : Colors.cyan.shade100)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text('Dropdown field data', style: TextStyle(color: Colors.grey, fontSize: 14)),
                              value: selectedClient,
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                              items: _clients.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedClient = newValue;
                                  state.didChange(newValue);
                                });
                              },
                            ),
                          ),
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 12),
                            child: Text(state.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                          ),
                      ],
                    );
                  }
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Property
              _buildSection(
                title: 'PROPERTY',
                child: FormField<String>(
                  validator: (value) => selectedProperty == null ? 'Please select a property' : null,
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: state.hasError ? Colors.red : Colors.grey.shade300)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text('Bole Atlantis', style: TextStyle(color: Colors.grey, fontSize: 14)),
                              value: selectedProperty,
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                              items: _properties.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedProperty = newValue;
                                  state.didChange(newValue);
                                });
                              },
                            ),
                          ),
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 12),
                            child: Text(state.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                          ),
                      ],
                    );
                  }
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Viewing Schedule
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF1B365D)),
                        SizedBox(width: 8),
                        const Text('Viewing Schedule', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B365D), fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FormField<DateTime>(
                      validator: (value) => _selectedDate == null ? 'Please select a date' : null,
                      builder: (state) {
                        return InkWell(
                          onTap: () async {
                            await _selectDate(context);
                            state.didChange(_selectedDate);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: state.hasError ? Colors.red : Colors.transparent),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedDate == null ? 'mm/dd/yyyy' : "${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}",
                                  style: TextStyle(color: _selectedDate == null ? Colors.grey : Colors.black, fontSize: 14),
                                ),
                                const Icon(Icons.arrow_drop_down, color: Colors.grey),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    FormField<TimeOfDay>(
                      validator: (value) => _selectedTime == null ? 'Please select a time' : null,
                      builder: (state) {
                        return InkWell(
                          onTap: () async {
                            await _selectTime(context);
                            state.didChange(_selectedTime);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: state.hasError ? Colors.red : Colors.transparent),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedTime == null ? '-- : -- --' : _selectedTime!.format(context),
                                  style: TextStyle(color: _selectedTime == null ? Colors.grey : Colors.black, fontSize: 14),
                                ),
                                const Icon(Icons.arrow_drop_down, color: Colors.grey),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Initial Interest Score
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text('INITIAL INTEREST SCORE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey[700])),
                    const SizedBox(height: 12),
                    FormField<int>(
                      validator: (value) => _rating == 0 ? 'Please provide a rating' : null,
                      builder: (state) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return IconButton(
                                  icon: Icon(
                                    index < _rating ? Icons.star : Icons.star_border,
                                    color: index < _rating ? Colors.amber : Colors.grey[400],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _rating = index + 1;
                                      state.didChange(_rating);
                                    });
                                  },
                                );
                              }),
                            ),
                            if (state.hasError)
                              Text(state.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                          ],
                        );
                      }
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Agent Notes
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AGENT NOTES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey[700])),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E4E7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Mention specific feedback on\nrooms, price objections, or\nfollow-up actions...',
                          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Please add some notes' : null,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Log Viewing Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Log'),
                            content: const Text('Are you sure you want to log this viewing session?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Back'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Viewing logged successfully!')),
                                  );
                                },
                                child: const Text('Confirm'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B365D),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 5,
                    shadowColor: Colors.black45,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text('Log Viewing', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF1B365D),
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Assuming clients is selected
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.business_outlined), label: 'PROPERTIES'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined), label: 'CLIENTS'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'VIEWINGS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'PROFILE'),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey[700])),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
