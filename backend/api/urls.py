from django.urls import path
from . import views

urlpatterns = [
    path('', views.getRoutes),
    path('tasks/', views.getTarefas),
    path('tasks/create/', views.criarTarefa),
    path('tasks/<str:pk>/update/', views.atualizarTarefa),
    path('tasks/<str:pk>/complete/', views.marcarConcluida),
    path('tasks/<str:pk>/delete/', views.deletarTarefa),
    path('tasks/<str:pk>/', views.getTarefa),
]