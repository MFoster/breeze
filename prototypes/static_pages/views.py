from django.shortcuts import render_to_response

def index(request):
	return render_to_response('static_pages/index.html')

def style_samples(request):
	return render_to_response('static_pages/general/style_samples.html')

def run_tests(request):
	return render_to_response('static_pages/general/SpecRunner.html')

def task_form_proto(request):
	return render_to_response('static_pages/prototypes/task_form_proto.html')

def task_play_proto(request):
	return render_to_response('static_pages/prototypes/task_play_proto.html')