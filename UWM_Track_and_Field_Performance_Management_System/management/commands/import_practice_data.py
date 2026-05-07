from django.core.management.base import BaseCommand
from UWM_Track_and_Field_Performance_Management_System.models import Athlete, PracticeResult
import csv

def to_float_if_not_null(element):
    return float(element) if element != '' else None

def if_not_null(element):
    return element if element != '' else None

class Command(BaseCommand):
    help = 'Import competition data from CSV'

    def handle(self, *args, **kwargs):
        with open('./data/practice_dataCLEAN.csv', newline='') as f:
            reader = csv.reader(f, delimiter=',')
            reader.__next__() # skip title row
            for row in reader:
                new_test = PracticeResult(
                    athlete=Athlete.objects.get(pk=row[0]),
                    practice_date=if_not_null(row[1]),
                    event=if_not_null(row[2]),
                    approach=if_not_null(row[3]),
                    gear=if_not_null(row[4]),
                    mark_meters=to_float_if_not_null(row[5]),
                    mark_raw=to_float_if_not_null(row[6].strip('"').replace("'", ".")),
                    season=if_not_null(row[7])
                )
                new_test.save()
        self.stdout.write(self.style.SUCCESS('Import complete'))