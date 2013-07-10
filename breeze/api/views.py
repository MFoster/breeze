from django.shortcuts import render_to_response
from django.http import HttpResponse
from django.core import serializers as cereal
from django.core.context_processors import csrf
import simplejson as json

from .models import Activity

def index(request):
  collection = Activity.objects.all()
  return HttpResponse(cereal.serialize("json", collection))
  
def version(request):
  registry = [{ "version" : "v1", "url" : "/api/v1/activity"}]
  
def activityIndex(request):
  if request.method == "POST":
    return HttpResponse("create")
  
  collection = Activity.objects.all()
  return HttpResponse(cereal.serialize("json", collection))

def activitySave(request, arg):
  if request.method == "PUT":
    modelData = json.loads(request.raw_post_data)
    Activity.objects.filter(id=modelData['id']).update(**modelData)
    return HttpResponse("update")
  elif request.method == "DELETE":
    modelData = json.loads(request.raw_post_data)
    Activity.objects.filter(id=modelData['id']).remove()
    return HttpResponse("delete")
  elif request.method == "GET":
    model = Activity.objects.filter(id=modelData['id'])
    return HttpResponse(cereal.serialize("json", model))

  
def test(request):
  params = { }
  params.update(csrf(request))
  return render_to_response('breeze/api-test.html', params)
  
  
