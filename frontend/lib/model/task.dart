import 'dart:convert';
import 'dart:math';

class Task {
  final int id;
  final String title;
  final String annotation;
  final DateTime date;
  final int color;
  final bool isComplete;

  Task({
    required this.id,
    required this.title,
    required this.annotation,
    required this.date,
    required this.color,
    required this.isComplete,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      annotation: json['annotation'],
      date: DateTime.parse(json['date']),
      color: json['color'],
      isComplete: json['isComplete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'annotation': annotation,
      'date': date.toIso8601String(),
      'color': color,
      'isComplete': isComplete,
    };
  }

  static int generateUniqueId() {
    final random = Random();
    int randomNumber = random.nextInt(99);

    int timestamp = DateTime.now().millisecondsSinceEpoch;

    int uniqueId = int.parse('$timestamp$randomNumber');

    return uniqueId;
  }

  static Future<List<Task>> mockTasks() async {
    await Future.delayed(const Duration(milliseconds: 10));
    List<Task> tasks = [];

    for (int i = 1; i <= 5; i++) {
      tasks.add(Task(
        id: generateUniqueId(),
        title: 'Tarefa $i',
        annotation: 'Anotação da Tarefa $i',
        date: DateTime.now().add(Duration(days: i)),
        color: Random().nextInt(12),
        isComplete: i % 2 == 0, // Define a completude alternadamente
      ));
    }

    return tasks;
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, annotation: $annotation, date: $date, color: $color, isComplete: $isComplete}';
  }
}