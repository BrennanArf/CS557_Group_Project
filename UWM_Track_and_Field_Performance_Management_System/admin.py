from django.contrib import admin

from .models import CustomUser, Athlete, CompetitionResult, FallTesting, PracticeResult

# Register your models here.
admin.site.register(CustomUser)
admin.site.register(Athlete)
admin.site.register(CompetitionResult)
admin.site.register(FallTesting)
admin.site.register(PracticeResult)