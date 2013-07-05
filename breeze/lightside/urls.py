from django.conf.urls import patterns, url

from lightside import views

urlpatterns = patterns('',
	url(r'^$', views.index, name='index'),
	url(r'^run_tests/', views.run_tests, name='run_tests'),
	url(r'^style_samples/', views.style_samples, name='style_samples'),
	url(r'^activity_center', views.activity_center, name='activity_center'),
)