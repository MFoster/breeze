from django.conf.urls import patterns, url

from lightside import views

urlpatterns = patterns('',
	url(r'^$', views.index, name='index'),
	url(r'^run_tests/', views.run_tests, name='run_tests'),
	url(r'^style_samples/', views.style_samples, name='style_samples'),
	url(r'^task_form', views.task_form_proto, name='task_form'),
	url(r'^task_play', views.task_play_proto, name='task_play'),
)