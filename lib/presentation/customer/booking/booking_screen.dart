import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/service_provider.dart';
import '../../../core/providers/stylist_provider.dart';
import '../../../domain/entities/service_entity.dart';
import '../../../domain/entities/stylist_entity.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  int _currentStep = 0;
  ServiceEntity? _selectedService;
  StylistEntity? _selectedStylist;
  String? _selectedTime;

  // Form keys and controllers for Customer Details
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.goldAccent,
            surface: AppColors.background,
          ),
        ),
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep == 0) {
              if (!_formKey.currentState!.validate()) {
                return; // Stop if form is invalid
              }
            }
            if (_currentStep < 4) {
              setState(() => _currentStep += 1);
            } else {
              _confirmBooking();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 4 ? 'CONFIRM' : 'CONTINUE'),
                  ),
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('BACK', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Your Details'),
              content: _buildCustomerDetailsForm(),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Select Service'),
              content: _buildServiceSelection(),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Select Stylist'),
              content: _buildStylistSelection(),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Select Date & Time'),
              content: _buildDateTimeSelection(),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Review Booking'),
              content: _buildReview(),
              isActive: _currentStep >= 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerDetailsForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Full Name *',
              labelStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number *',
              labelStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Please enter your phone number';
              if (value.length < 10) return 'Please enter a valid 10-digit number';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address (Optional)',
              labelStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Special Requests / Notes',
              labelStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSelection() {
    final servicesAsync = ref.watch(servicesProvider);
    return servicesAsync.when(
      data: (services) => Column(
        children: services.map((service) {
          final isSelected = _selectedService?.id == service.id;
          return Card(
            color: isSelected ? AppColors.surfaceLight : AppColors.surface,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: isSelected ? AppColors.goldAccent : Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () => setState(() => _selectedService = service),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: service.imageUrl.startsWith('http')
                    ? Image.network(service.imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image))
                    : Image.asset(service.imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image)),
              ),
              title: Text(service.name, style: const TextStyle(color: AppColors.textPrimary)),
              subtitle: Text('₹${service.price} • ${service.durationMinutes} min', style: const TextStyle(color: AppColors.textSecondary)),
              trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.goldAccent) : null,
            ),
          );
        }).toList(),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }

  Widget _buildStylistSelection() {
    final stylistsAsync = ref.watch(stylistsProvider);
    return stylistsAsync.when(
      data: (stylists) => Column(
        children: stylists.map((stylist) {
          final isSelected = _selectedStylist?.id == stylist.id;
          return Card(
            color: isSelected ? AppColors.surfaceLight : AppColors.surface,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: isSelected ? AppColors.goldAccent : Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () => setState(() => _selectedStylist = stylist),
              leading: CircleAvatar(
                backgroundImage: AssetImage(stylist.imageUrl),
                onBackgroundImageError: (e, s) => {},
                child: const Icon(Icons.person, color: AppColors.surface),
              ),
              title: Text(stylist.name, style: const TextStyle(color: AppColors.textPrimary)),
              subtitle: Text('${stylist.specialization}\n⭐ ${stylist.rating}', style: const TextStyle(color: AppColors.textSecondary)),
              isThreeLine: true,
              trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.goldAccent) : null,
            ),
          );
        }).toList(),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }

  Widget _buildDateTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Today, 12th August', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ['10:00 AM', '11:30 AM', '02:00 PM', '04:30 PM'].map((time) {
            final isSelected = _selectedTime == time;
            return ChoiceChip(
              label: Text(time),
              selected: isSelected,
              onSelected: (selected) => setState(() => _selectedTime = selected ? time : null),
              selectedColor: AppColors.goldAccent,
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(color: isSelected ? AppColors.background : AppColors.textPrimary),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReview() {
    if (_selectedService == null || _selectedStylist == null || _selectedTime == null) {
      return const Text('Please complete all previous steps', style: TextStyle(color: AppColors.error));
    }
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Details', style: const TextStyle(color: AppColors.goldAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Name: ${_nameController.text}', style: const TextStyle(color: AppColors.textPrimary)),
            Text('Phone: ${_phoneController.text}', style: const TextStyle(color: AppColors.textPrimary)),
            if (_emailController.text.isNotEmpty)
              Text('Email: ${_emailController.text}', style: const TextStyle(color: AppColors.textPrimary)),
            const Divider(color: AppColors.textSecondary, height: 32),
            Text('Appointment Details', style: const TextStyle(color: AppColors.goldAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Service: ${_selectedService!.name}', style: const TextStyle(color: AppColors.textPrimary)),
            Text('Stylist: ${_selectedStylist!.name}', style: const TextStyle(color: AppColors.textPrimary)),
            Text('Time: Today, $_selectedTime', style: const TextStyle(color: AppColors.textPrimary)),
            const Divider(color: AppColors.textSecondary, height: 32),
            Text('Total Amount: ₹${_selectedService!.price}', style: const TextStyle(color: AppColors.goldAccent, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _confirmBooking() {
    if (_selectedService != null && _selectedStylist != null && _selectedTime != null && _formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment Booked Successfully!'), backgroundColor: Colors.green),
      );
      context.go('/customer-home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields'), backgroundColor: Colors.redAccent),
      );
    }
  }
}
