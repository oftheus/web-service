import 'package:flutter/material.dart';
import 'package:tarefas_rest/screen/novaTarefa.dart';
import 'package:tarefas_rest/service/apiSevice.dart';
import 'package:tarefas_rest/widget/taskWidget.dart';
import '../model/task.dart';

class MostrarTarefas extends StatefulWidget {
  const MostrarTarefas({super.key});

  @override
  State<MostrarTarefas> createState() => _MostrarTarefasState();
}

class _MostrarTarefasState extends State<MostrarTarefas> {
  late Future<List<Task>> _futureTasks;

  @override
  void initState() {
    super.initState();
    _futureTasks = ApiService.fetchTasks();
  }

  void _refreshTasks() {
    setState(() {
      _futureTasks = ApiService.fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: _futureTasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhuma tarefa encontrada.'));
                } else {
                  List<Task> tasks = snapshot.data!;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      Task task = tasks[index];
                      return TaskWidget(
                        task: task,
                        onTaskModified: _refreshTasks,
                      );
                    },
                  );
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: FilledButton.icon(
                onPressed: () async {
                  bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NovaTarefa()),
                  );
                  if (result == true) {
                    _refreshTasks();
                  }
                },
                icon: Icon(Icons.note_add),
                label: const Text('Criar Tarefa'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
