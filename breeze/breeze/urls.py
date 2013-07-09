from django.conf.urls import patterns, include, url
from tasks.views import TaskCreate, TaskUpdate, TaskDetailView

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    
    url(r'^$', 'breeze.views.home', name='home'),
    # url(r'^breeze/', include('breeze.foo.urls')),

    url(r'^task/add/$', TaskCreate.as_view(), name='task_add'),
    url(r'^task/update/(?P<slug>[-_\w]+)/$', TaskUpdate.as_view(), name='task_update'),
	url(r'^task/(?P<slug>[-_\w]+)/$', TaskDetailView.as_view(), name='task_detail'),

    # URLs for the main person viewable pages
    url(r'^lightside/', include('lightside.urls')),
    
    url(r'^api/', include('api.urls')),

    #url(r'task/delete/(?P<slug>[-_\w]+)/$$', TaskDelete.as_view(), name='task_delete'),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
)