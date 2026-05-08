from django.db import models

# Create your models here.
from django.contrib.auth.models import AbstractUser
from django.db import models
class Athlete(models.Model):
    athlete_id = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=45, null=True)
    last_name = models.CharField(max_length=45)
    gender = models.CharField(max_length=10)
    event_group = models.CharField(max_length=45, null=True)
    tfrrs_url = models.CharField(max_length=255, null=True)

class CompetitionResult(models.Model):
    result_id = models.AutoField(primary_key=True)
    # Django foreign key automatically appends "_id"
    # to field name, so this is athlete_id in db
    athlete = models.ForeignKey(Athlete, on_delete=models.CASCADE)
    meet_name = models.CharField(max_length=150)
    meet_date = models.DateField()
    event = models.CharField(max_length=45)
    result_distance = models.DecimalField(max_digits=6, decimal_places=2, null=True)
    result_time = models.CharField(max_length=20, null=True)
    wind = models.DecimalField(max_digits=6, decimal_places=2, null=True)

class FallTesting(models.Model):
    test_id = models.AutoField(primary_key=True)
    athlete = models.ForeignKey(Athlete, on_delete=models.CASCADE)
    season = models.CharField(max_length=10, null=True)
    vertical = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    slj = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    stj = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    sprint_50 = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    ohb = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    blf = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    sprint_150 = models.DecimalField(max_digits=5, decimal_places=2, null=True)

class PracticeResult(models.Model):
    practice_id = models.AutoField(primary_key=True)
    athlete = models.ForeignKey(Athlete, on_delete=models.CASCADE)
    practice_date = models.DateField(null=True)
    event = models.CharField(max_length=45, null=True)
    approach = models.CharField(max_length=45, null=True)
    gear = models.CharField(max_length=45, null=True)
    mark_meters = models.DecimalField(max_digits=6, decimal_places=2, null=True)
    mark_raw = models.DecimalField(max_digits=6, decimal_places=2, null=True)
    season = models.CharField(max_length=10, null=True)

class CustomUser(AbstractUser):
    role = models.CharField(max_length=50)
    athlete = models.ForeignKey(Athlete, on_delete=models.DO_NOTHING, null=True)