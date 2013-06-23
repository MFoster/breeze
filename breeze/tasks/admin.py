from django.contrib import admin
from tasks.models import Task

class TaskAdmin(admin.ModelAdmin):
    list_display = ('name', 'length', 'slug',)

admin.site.register(Task, TaskAdmin)