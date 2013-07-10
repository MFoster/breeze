from django.conf.urls import patterns, url

from api import views

urlpatterns = patterns('',
	url(r'^$', views.index, name='api_index'),
    url(r'^v1/activity/(\d+)$', views.activitySave, name="activity_save"),
	url(r'^v1/activity', views.index, name="activity_index"),	
	url(r'^test$', views.test, name='api_test')
)