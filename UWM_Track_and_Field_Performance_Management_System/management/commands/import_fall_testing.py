from django.core.management.base import BaseCommand
from UWM_Track_and_Field_Performance_Management_System.models import Athlete, FallTesting
import csv

def to_float_if_not_null(element):
    return float(element) if element != '' else None

class Command(BaseCommand):
    help = 'Import fall testing data from CSV'

    def handle(self, *args, **kwargs):
        with open('./data/fall_testingCLEAN.csv', newline='') as f:
            reader = csv.reader(f, delimiter=',')
            reader.__next__() # skip title row
            for row in reader:
                new_test = FallTesting(
                    athlete=Athlete.objects.get(pk=row[0]),
                    season=row[1],
                    vertical=to_float_if_not_null(row[2]),
                    slj=to_float_if_not_null(row[3]),
                    stj=to_float_if_not_null(row[4]),
                    sprint_50=to_float_if_not_null(row[5]),
                    ohb=to_float_if_not_null(row[6]),
                    blf=to_float_if_not_null(row[7]),
                    sprint_150=to_float_if_not_null(row[8])
                )
                new_test.save()
        self.stdout.write(self.style.SUCCESS('Import complete'))