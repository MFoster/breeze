from django.shortcuts import render_to_response

def index(request):
	return render_to_response('lightside/index.html')

def style_samples(request):
	return render_to_response('lightside/tools/style_samples.html')

def run_tests(request):
	return render_to_response('lightside/tools/SpecRunner.html')

def task_form_proto(request):
	return render_to_response('lightside/views/task_form_proto.html')

def task_play_proto(request):
	return render_to_response('lightside/views/task_play_proto.html')