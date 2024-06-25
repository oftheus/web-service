import 'package:flutter/material.dart';
import 'package:tarefas_rest/service/apiSevice.dart';
import '../model/task.dart';
import '../screen/novaTarefa.dart';

class TaskWidget extends StatefulWidget {
  final Task task;
  final VoidCallback onTaskModified;

  const TaskWidget({super.key, required this.task, required this.onTaskModified});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
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
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorsList[widget.task.color],
          borderRadius: BorderRadius.circular(20.0), // Borda arredondada
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: screenSize.height * 0.018,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.task.date.day}/${widget.task.date.month}/${widget.task.date.year}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Icon(
                      Icons.alarm,
                      size: screenSize.height * 0.018,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.task.date.hour.toString().padLeft(2, '0')}:${widget.task.date.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                !widget.task.isComplete
                    ? Row(
                        children: [
                          Icon(
                            Icons.hourglass_empty_rounded,
                            size: screenSize.height * 0.018,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Pendente',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.done_outline_sharp,
                            size: screenSize.height * 0.018,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Concluída',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
            const SizedBox(height: 7),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ANOTAÇÃO:'),
                  Text(widget.task.annotation),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          await ApiService.deleteTask(widget.task.id);
                          _showSnackbar('Tarefa apagada');
                          widget.onTaskModified();
                        },
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 5),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      bool? result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NovaTarefa(task: widget.task)),
                      );
                      if (result == true) {
                        widget.onTaskModified();
                      }
                    },
                    icon: const Icon(Icons.edit_outlined),
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 5),
                !widget.task.isComplete
                    ? Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                await ApiService.markTaskAsComplete(widget.task.id);
                                _showSnackbar('Tarefa concluída');
                                widget.onTaskModified();
                              },
                              icon: const Icon(Icons.done_all),
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Marcar como concluído',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
