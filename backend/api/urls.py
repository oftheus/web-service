# urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('', views.getRoutes),
    path('tasks/', views.fetchTasks),
    path('tasks/create/', views.createTask),
    path('tasks/<int:pk>/', views.getTask),
    path('tasks/<int:pk>/update/', views.updateTask),
    path('tasks/<int:pk>/delete/', views.deleteTask),
    path('tasks/<int:pk>/complete/', views.markTaskAsComplete),
    path('tasks/by-date/', views.fetchTasksByDate),
]