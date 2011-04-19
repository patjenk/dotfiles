import IPython.ipapi
ip = IPython.ipapi.get()
import os

def load_django_models():
    """Load all of our django models. Taken from django snippsets. 
    http://djangosnippets.org/snippets/549/"""
    try:
        from django.db.models import Q
        from django.db.models.loading import get_models
        for m in get_models():
            ip.ex("from %s import %s" % (m.__module__, m.__name__))
        print 'INFO: Loaded Django models.'
    except ImportError as e:
        print e
        pass

def main():
    load_django_models()

main()
