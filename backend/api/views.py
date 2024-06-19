from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import TarefaSerializer
from .models import Tarefa

@api_view(['GET'])
def getRoutes(request):

    routes = [
        {
            'Endpoint': '/tarefas/',
            'method': 'GET',
            'body': None,
            'description': 'Returns an array of notes'
        },
        {
            'Endpoint': '/tarefas/id',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single note object'
        },
        {
            'Endpoint': '/tarefas/create/',
            'method': 'POST',
            'body': {'body': ""},
            'description': 'Creates new note with data sent in post request'
        },
        {
            'Endpoint': '/tarefas/id/update/',
            'method': 'PUT',
            'body': {'body': ""},
            'description': 'Creates an existing note with data sent in post request'
        },
        {
            'Endpoint': '/tarefas/id/delete/',
            'method': 'DELETE',
            'body': None,
            'description': 'Deletes and exiting note'
        },
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