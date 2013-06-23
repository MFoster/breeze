from django.db import models

class Task(models.Model):
    SHORT = '5'
    MEDIUM = '20'
    LONG = '50'
    LENGTH_CHOICES = (
        (SHORT, '5 Minutes'),
        (MEDIUM, '20 Minutes'),
        (LONG, '50 Minutes'),
    )
    name = models.CharField(max_length=50)
    length = models.CharField(max_length=2, choices=LENGTH_CHOICES, default=MEDIUM)
    slug = models.SlugField()

    def __unicode__(self):
        return self.name

    def get_absolute_url(self):
        return "/task/%s/" % self.slug
 