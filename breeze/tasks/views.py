from django.views.generic.edit import CreateView, UpdateView, DeleteView
from django.views.generic.detail import DetailView
from django.core.urlresolvers import reverse_lazy
from .models import Task

class TaskDetailView(DetailView):
    model = Task

class TaskCreate(CreateView):
    model = Task
    fields = ['name']
    template_name_suffix = '_add_form'
    success_url = reverse_lazy('task_play')

class TaskUpdate(UpdateView):
    model = Task
    fields = ['name']
    template_name_suffix = '_update_form'

#class TaskDelete(DeleteView):
#    model = Task
#    success_url = reverse_lazy('task-list')