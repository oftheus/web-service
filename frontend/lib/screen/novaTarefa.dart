import 'package:flutter/material.dart';
import 'package:tarefas_rest/screen/mainScreen.dart';
import '../model/task.dart';
import '../service/apiSevice.dart';

class NovaTarefa extends StatefulWidget {
  final Task? task;

  const NovaTarefa({super.key, this.task});

  @override
  State<NovaTarefa> createState() => _NovaTarefaState();
}

class _NovaTarefaState extends State<NovaTarefa> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _annotationController = TextEditingController();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late Color _selectedColor;
  List<Color> colorsList = [
    const Color(0xFFD7423D),
    const Color(0xFFFFE066),
    const Color(0xFFFFBA59),
    const Color(0xFFFF8C8C),
    const Color(0xFFFF99E5),
    const Color(0xFFC3A6FF),
    const Color(0xFF9FBCF5),
    const Color(0xFF8CE2FF),
    const Color(0xFF87F5B5),
    const Color(0xFFBCF593),
    const Color(0xFFE2F587),
    const Color(0xFFD9BCAD),
  ];
  int _selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.task == null) {
      _selectedColor = colorsList[0];
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    } else {
      _titleController.text = widget.task!.title;
      _annotationController.text = widget.task!.annotation;
      _selectedColorIndex = widget.task!.color;
      _selectedColor = colorsList[_selectedColorIndex];
      _selectedDate = widget.task!.date;
      _selectedTime = TimeOfDay(hour: _selectedDate.hour, minute: _selectedDate.minute);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(message, style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            )),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar/Editar Tarefa'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título da Tarefa',
                ),
              ),
              TextFormField(
                controller: _annotationController,
                decoration: const InputDecoration(
                  labelText: 'Anotação',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              const Text(
                "Escolher cor:",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: List.generate(colorsList.length, (index) {
                    Color color = colorsList[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                          _selectedColorIndex = index; // Atualiza o índice da cor selecionada
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedColor == color ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: color,
                          radius: 20,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Data:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hora:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectTime(context),
                          child: Text(
                            '${_selectedTime.hour}:${_selectedTime.minute}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_titleController.text.isEmpty || _annotationController.text.isEmpty) {
                      _showSnackbar('Por favor, preencha todos os campos.');
                      return;
                    }

                    final DateTime combinedDateTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );

                    Task editedTask = Task(
                      id: widget.task?.id ?? Task.generateUniqueId(),
                      title: _titleController.text,
                      annotation: _annotationController.text,
                      date: combinedDateTime,
                      color: _selectedColorIndex,
                      isComplete: widget.task?.isComplete ?? false,
                    );

                    if (widget.task == null) {
                      // Cria uma nova tarefa
                      await ApiService.createTask(editedTask);
                      _showSnackbar('Nova tarefa criada!');
                      print('Nova tarefa criada: $editedTask');
                    } else {
                      // Edita uma tarefa existente
                      await ApiService.updateTask(widget.task!.id, editedTask);
                      _showSnackbar('Tarefa editada!');
                      print('Tarefa editada: ${editedTask.toString()}');
                    }
                    Navigator.pop(context, true);
                  },
                  child: const Text('Salvar Tarefa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
