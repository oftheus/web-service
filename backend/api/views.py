from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import TarefaSerializer
from .models import Tarefa

@api_view(['GET'])
def getRoutes(request):

    routes = [
        {
            'Endpoint': 'tasks/',
            'method': 'GET',
            'body': None,
            'description': 'Returns an array of notes'
        },
        {
            'Endpoint': '/tasks/id',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single note object'
        },
        {
            'Endpoint': '/tasks/create/',
            'method': 'POST',
            'body': {'body': ""},
            'description': 'Creates new note with data sent in post request'
        },
        {
            'Endpoint': '/tasks/id/update/',
            'method': 'PUT',
            'body': {'body': ""},
            'description': 'Creates an existing note with data sent in post request'
        },
        {
            'Endpoint': '/tasks/id/delete/',
            'method': 'DELETE',
            'body': None,
            'description': 'Deletes and exiting note'
        },
        {
            'Endpoint': '/tasks/id/complete/',
            'method': 'PUT',
            'body': None,
            'description': 'Completa uma tarefa'
        }
    ]
    return Response(routes)

@api_view(['GET'])
def getTarefas(request):
    tarefas = Tarefa.objects.all()
    serializer = TarefaSerializer(tarefas, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getTarefa(request, pk):
    tarefa = Tarefa.objects.get(id=pk)
    serializer = TarefaSerializer(tarefa, many=False)
    return Response(serializer.data)

@api_view(['POST'])
def criarTarefa(request):
    data = request.data
    tarefa = Tarefa.objects.create(
        body=data['body']
    )
    serializer = TarefaSerializer(tarefa, many=False)
    return Response(serializer.data)

@api_view(['PUT'])
def atualizarTarefa(request, pk):
    data = request.data
    tarefa = Tarefa.objects.get(id=pk)
    serializer = TarefaSerializer(tarefa, data=request.data)
    if serializer.is_valid():
        serializer.save()
    return Response(serializer.data)

@api_view(['DELETE'])
def deletarTarefa(request, pk):
    tarefa = Tarefa.objects.get(id=pk)
    tarefa.delete()
    return Response('Tarefa foi apagada!')

@api_view(['PUT'])
def marcarConcluida(request, pk):
    tarefa = Tarefa.objects.get(id=pk)
    tarefa.isComplete = True
    serializer = TarefaSerializer(tarefa, data=request.data)
    if serializer.is_valid():
        serializer.save()
    return Response(serializer.data)