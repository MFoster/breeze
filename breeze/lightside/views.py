from django.shortcuts import render_to_response
from django.http import HttpResponse

def index(request):
	return render_to_response('lightside/index.html')

def style_samples(request):
	return render_to_response('lightside/tools/style_samples.html')

def run_tests(request):
	return render_to_response('lightside/tools/SpecRunner.html')

def activity_center(request):
	return render_to_response('lightside/views/activity_center.html')
	
