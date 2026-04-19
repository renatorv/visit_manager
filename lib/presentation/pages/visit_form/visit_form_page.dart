import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/visit.dart';
import '../../cubits/visit_cubit.dart';
import '../../cubits/visit_state.dart';

class VisitFormPage extends StatelessWidget {
  final Visit? visit;

  const VisitFormPage({super.key, this.visit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VisitCubit>(),
      child: _VisitFormView(visit: visit),
    );
  }
}

class _VisitFormView extends StatefulWidget {
  final Visit? visit;

  const _VisitFormView({this.visit});

  @override
  State<_VisitFormView> createState() => _VisitFormViewState();
}

class _VisitFormViewState extends State<_VisitFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _visitedPersonController;
  late final TextEditingController _visitorController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _nextVisitReasonController;

  DateTime? _visitDate;
  DateTime? _nextVisitDate;
  bool _visitAgain = false;

  bool get _isEditing => widget.visit != null;

  @override
  void initState() {
    super.initState();
    _visitedPersonController = TextEditingController(
      text: widget.visit?.visitedPersonName ?? '',
    );
    _visitorController = TextEditingController(
      text: widget.visit?.visitorName ?? '',
    );
    final initialPhone = widget.visit?.phone ?? '';
    final formattedPhone = _PhoneInputFormatter().formatEditUpdate(
      const TextEditingValue(text: ''),
      TextEditingValue(text: initialPhone),
    ).text;

    _phoneController = TextEditingController(
      text: formattedPhone,
    );
    _addressController = TextEditingController(
      text: widget.visit?.address ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.visit?.description ?? '',
    );
    _nextVisitReasonController = TextEditingController(
      text: widget.visit?.nextVisitReason ?? '',
    );
    _visitDate = widget.visit?.visitDate;
    _nextVisitDate = widget.visit?.nextVisitDate;
    _visitAgain = widget.visit?.visitAgain ?? false;
  }

  @override
  void dispose() {
    _visitedPersonController.dispose();
    _visitorController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _nextVisitReasonController.dispose();
    super.dispose();
  }

  Future<void> _pickVisitDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    DateTime initial = _visitDate ?? today;
    if (initial.isBefore(today)) initial = today;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: DateTime(2100),
      builder: (context, child) => _datePickerTheme(context, child),
    );
    if (picked != null) setState(() => _visitDate = picked);
  }

  Future<void> _pickNextVisitDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    DateTime initial = _nextVisitDate ?? today.add(const Duration(days: 7));
    if (initial.isBefore(today)) initial = today;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: DateTime(2100),
      builder: (context, child) => _datePickerTheme(context, child),
    );
    if (picked != null) setState(() => _nextVisitDate = picked);
  }

  Widget _datePickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppTheme.primaryColor,
          onPrimary: Colors.white,
          surface: Colors.white,
        ),
      ),
      child: child!,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_visitDate == null) {
      _showWarning('Por favor, selecione a data da visita.');
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final vDate = DateTime(_visitDate!.year, _visitDate!.month, _visitDate!.day);
    if (vDate.isBefore(today)) {
      _showWarning('A data da visita não pode ser anterior a hoje.');
      return;
    }

    if (_visitAgain) {
      if (_nextVisitDate == null) {
        _showWarning('Por favor, selecione a data da próxima visita.');
        return;
      }
      final nDate = DateTime(_nextVisitDate!.year, _nextVisitDate!.month, _nextVisitDate!.day);
      if (nDate.isBefore(today)) {
        _showWarning('A data da próxima visita não pode ser anterior a hoje.');
        return;
      }
    }

    final visit = Visit(
      id: widget.visit?.id,
      visitedPersonName: _visitedPersonController.text.trim(),
      visitorName: _visitorController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      visitDate: _visitDate!,
      description: _descriptionController.text.trim(),
      visitAgain: _visitAgain,
      nextVisitDate: _visitAgain ? _nextVisitDate : null,
      nextVisitReason:
          _visitAgain ? _nextVisitReasonController.text.trim() : null,
    );

    if (_isEditing) {
      context.read<VisitCubit>().updateVisit(visit);
    } else {
      context.read<VisitCubit>().addVisit(visit);
    }
  }

  void _showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Visita' : 'Nova Visita'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<VisitCubit, VisitState>(
        listener: (context, state) {
          if (state is VisitOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.pop();
          } else if (state is VisitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _SectionHeader(title: 'Dados da Visita'),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _visitedPersonController,
                  label: 'Nome da pessoa visitada',
                  icon: Icons.person,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Informe o nome da pessoa visitada'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _visitorController,
                  label: 'Nome do visitante',
                  icon: Icons.person_outline,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Informe o nome do visitante'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Telefone',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_PhoneInputFormatter()],
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Informe o telefone'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _addressController,
                  label: 'Endereço',
                  icon: Icons.location_on,
                  maxLines: 2,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Informe o endereço'
                      : null,
                ),
                const SizedBox(height: 16),
                _DatePickerField(
                  label: 'Data da visita',
                  icon: Icons.calendar_today,
                  date: _visitDate,
                  onTap: _pickVisitDate,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Descrição da visita',
                  icon: Icons.description,
                  maxLines: 4,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Informe a descrição da visita'
                      : null,
                ),
                const SizedBox(height: 24),
                const _SectionHeader(title: 'Próxima Visita'),
                const SizedBox(height: 12),
                _VisitAgainToggle(
                  value: _visitAgain,
                  onChanged: (value) {
                    setState(() {
                      _visitAgain = value;
                      if (!_visitAgain) {
                        _nextVisitDate = null;
                        _nextVisitReasonController.clear();
                      }
                    });
                  },
                ),
                if (_visitAgain) ...[
                  const SizedBox(height: 16),
                  _DatePickerField(
                    label: 'Data da próxima visita',
                    icon: Icons.event_repeat,
                    date: _nextVisitDate,
                    onTap: _pickNextVisitDate,
                    accentColor: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _nextVisitReasonController,
                    label: 'Motivo da próxima visita',
                    icon: Icons.note_alt_outlined,
                    maxLines: 3,
                    validator: (v) => (_visitAgain &&
                            (v == null || v.trim().isEmpty))
                        ? 'Informe o motivo da próxima visita'
                        : null,
                  ),
                ],
                const SizedBox(height: 32),
                BlocBuilder<VisitCubit, VisitState>(
                  builder: (context, state) {
                    final isLoading = state is VisitLoading;
                    return SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _isEditing
                                    ? 'Atualizar Visita'
                                    : 'Cadastrar Visita',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets auxiliares
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final IconData icon;
  final DateTime? date;
  final VoidCallback onTap;
  final Color accentColor;

  const _DatePickerField({
    required this.label,
    required this.icon,
    required this.date,
    required this.onTap,
    this.accentColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final formatted =
        date != null ? DateFormat('dd/MM/yyyy').format(date!) : null;

    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: const Icon(
            Icons.calendar_month_outlined,
            color: AppTheme.primaryColor,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
          ),
        ),
        child: Text(
          formatted ?? 'Selecione uma data',
          style: TextStyle(
            fontSize: 16,
            color: date != null ? Colors.black87 : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}

class _VisitAgainToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _VisitAgainToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        border: Border.all(
          color: value ? AppTheme.primaryColor : Colors.grey.shade300,
          width: value ? 2 : 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: value
            ? AppTheme.primaryColor.withValues(alpha: 0.05)
            : Colors.transparent,
      ),
      child: CheckboxListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        title: const Text(
          'Visitar novamente?',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          value
              ? 'Preencha a data e o motivo abaixo'
              : 'Marque para agendar uma nova visita',
          style: TextStyle(
            fontSize: 12,
            color: value ? AppTheme.primaryColor : Colors.grey,
          ),
        ),
        secondary: Icon(
          Icons.event_available,
          color: value ? AppTheme.primaryColor : Colors.grey,
          size: 28,
        ),
        value: value,
        onChanged: (v) => onChanged(v ?? false),
        activeColor: AppTheme.primaryColor,
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }
}

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }
    
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    if (text.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');
      if (i == 3) buffer.write(' ');
      if (i == 7) buffer.write('-');
      
      if (i >= 11) break;
      
      buffer.write(text[i]);
    }
    
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
