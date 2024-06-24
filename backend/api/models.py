# models.py
from django.db import models

class Tarefa(models.Model):
    title = models.CharField(max_length=100)
    annotation = models.TextField(null=True, blank=True)
    date = models.DateTimeField()
    color = models.IntegerField()
    isComplete = models.BooleanField(default=False)

    def __str__(self):
        return self.title
