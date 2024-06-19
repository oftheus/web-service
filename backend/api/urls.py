from django.urls import path
from . import views

urlpatterns = [
    path('', views.getRoutes),
    path('tarefas/', views.getTarefas),
    path('tarefas/create/', views.criarTarefa),
    path('tarefas/<str:pk>/update/', views.atualizarTarefa),
    path('tarefas/<str:pk>/delete/', views.deletarTarefa),
    path('tarefas/<str:pk>/', views.getTarefa),
]