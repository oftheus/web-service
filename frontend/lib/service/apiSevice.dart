import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tarefas_rest/model/task.dart';

class ApiService {

  ApiService();

  static final String baseUrl = 'http://127.0.0.1:8000';

  // Método para buscar todas as tarefas
  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks/'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      List<Task> tasks = body.map((dynamic item) => Task.fromJson(item)).toList();
      return tasks;
    } else {
      throw Exception('Fail');
    }
  }

  // Método para criar uma nova tarefa
  static Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/create/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Fail');
    }
  }

  // Método para atualizar uma tarefa existente
  static Future<Task> updateTask(int id, Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$id/update/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Fail');
    }
  }

  // Método para deletar uma tarefa
  static Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tasks/$id/delete/'));

    if (response.statusCode != 204) {
      throw Exception('Fail');
    }
  }

  // Método para buscar tarefas pela data (CALENDARIO)
  static Future<List<Task>> fetchTasksByDate(DateTime date) async {
    final String formattedDate = date.toIso8601String().split('T').first;
    final response = await http.get(Uri.parse('$baseUrl/tasks/by-date/?date=$formattedDate'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      List<Task> tasks = body.map((dynamic item) => Task.fromJson(item)).toList();
      return tasks;
    } else {
      throw Exception('Fail');
    }
  }

  //Metodo para marcar como concluida
  static Future<void> markTaskAsComplete(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$id/complete/'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'isComplete': true}),
    );
    if (response.statusCode == 200) {
      //return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Fail');
    }
  }
}
