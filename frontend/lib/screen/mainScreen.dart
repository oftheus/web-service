import 'package:flutter/material.dart';
import 'package:tarefas_rest/screen/calendario.dart';
import 'package:tarefas_rest/screen/mostrarTarefas.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
    int indexPage = 0;
  final pages = [
    const MostrarTarefas(),
    const Calendario(),
  ];
  final titles = [
    'Tarefas',
    'Calendário',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: indexPage == 0 
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Text(titles[indexPage]),
              centerTitle: true,
            )
          : null,
      body: pages[indexPage],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        child: NavigationBar(
          selectedIndex: indexPage,
          onDestinationSelected: (value) {
            setState(() {
              indexPage = value;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.list_outlined),
              label: 'Tarefas',
              selectedIcon: Icon(Icons.list),
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Calendário',
              selectedIcon: Icon(Icons.calendar_month),
            ),
          ],
        ),
      ),
    );
  }
}