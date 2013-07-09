from django.shortcuts import render_to_response
from django.http import HttpResponse
from django.core import serializers as cereal

from .models import Activity

def index(request):
  collection = Activity.objects.all()
  return HttpResponse(cereal.serialize("json", collection))