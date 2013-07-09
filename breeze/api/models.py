from django.db import models

class Activity(models.Model):
    text              = models.CharField(max_length=255)
    type              = models.CharField(max_length=100)
    description       = models.TextField()
    scheduled         = models.BooleanField()
    originalDuration  = models.PositiveIntegerField()
    currentDuration   = models.PositiveIntegerField()
    remainingDuration = models.PositiveIntegerField()
    currentComplete   = models.PositiveIntegerField()
    created           = models.DateTimeField()
    available         = models.DateTimeField()
    due               = models.DateTimeField()
    completed         = models.DateTimeField()
    