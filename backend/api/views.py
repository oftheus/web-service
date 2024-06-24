# views.py
from datetime import datetime
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Tarefa
from .serializers import TarefaSerializer

@api_view(['GET'])
def getRoutes(request):
    routes = [
        {
            'Endpoint': '/tasks/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a list of tasks'
        },
        {
            'Endpoint': '/tasks/<int:pk>/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single task object'
        },
        {
            'Endpoint': '/tasks/create/',
            'method': 'POST',
            'body': {'title': '', 'annotation': '', 'date': '', 'color': '', 'isComplete': ''},
            'description': 'Creates a new task with data sent in the request body'
        },
        {
            'Endpoint': '/tasks/<int:pk>/update/',
            'method': 'PUT',
            'body': {'title': '', 'annotation': '', 'date': '', 'color': '', 'isComplete': ''},
            'description': 'Updates an existing task with data sent in the request body'
        },
        {
            'Endpoint': '/tasks/<int:pk>/delete/',
            'method': 'DELETE',
            'body': None,
            'description': 'Deletes an existing task'
        },
        {
            'Endpoint': '/tasks/by-date/',
            'method': 'GET',
            'body': None,
            'description': 'Returns tasks filtered by date'
        },
        {
            'Endpoint': '/tasks/<int:pk>/complete/',
            'method': 'PUT',
            'body': {'isComplete': True},
            'description': 'Marks a task as complete'
        },
    ]
    return Response(routes)

@api_view(['GET'])
def fetchTasks(request):
    tasks = Tarefa.objects.all()
    serializer = TarefaSerializer(tasks, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getTask(request, pk):
    tasks = Tarefa.objects.get(pk=pk)
    serializer = TarefaSerializer(tasks)
    return Response(serializer.data)

@api_view(['POST'])
def createTask(request):
    serializer = TarefaSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)

@api_view(['PUT'])
def updateTask(request, pk):
    task = Tarefa.objects.get(pk=pk)
    serializer = TarefaSerializer(instance=task, data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=400)

@api_view(['DELETE'])
def deleteTask(request, pk):
    task = Tarefa.objects.get(pk=pk)
    task.delete()
    return Response('Task deleted successfully', status=204)

@api_view(['GET'])
def fetchTasksByDate(request):
    date_param = request.query_params.get('date', None)
    date_param = date_param.rstrip('/')
    if date_param:
        _date = datetime.strptime(date_param, '%Y-%m-%d').date()
        tasks = Tarefa.objects.filter(date__date=_date)
    else:
        tasks = Tarefa.objects.all()
    serializer = TarefaSerializer(tasks, many=True)
    return Response(serializer.data)

@api_view(['PUT'])
def markTaskAsComplete(request, pk):
    tarefa = Tarefa.objects.get(id=pk)
    tarefa.isComplete = True
    serializer = TarefaSerializer(tarefa, data=request.data)
    if serializer.is_valid():
        serializer.save()
    tarefa.save()
    return Response(serializer.data)