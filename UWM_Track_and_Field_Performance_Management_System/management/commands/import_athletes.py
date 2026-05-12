from django.core.management.base import BaseCommand
from UWM_Track_and_Field_Performance_Management_System.models import Athlete
import csv

class Command(BaseCommand):
    help = 'Import athletes from CSV'

    def handle(self, *args, **kwargs):
        with open('./data/athletesCLEAN.csv', newline='') as f:
            reader = csv.reader(f, delimiter=',')
            reader.__next__() # skip title row
            for row in reader:
                try:
                    new_athlete = Athlete(
                        first_name=row[1],
                        last_name=row[2],
                        gender=row[3],
                        event_group=row[4],
                    )
                    new_athlete.save()
                except:
                    continue               
        self.stdout.write(self.style.SUCCESS('Import complete'))
        