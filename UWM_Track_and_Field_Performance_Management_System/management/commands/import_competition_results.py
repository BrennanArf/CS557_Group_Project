from django.core.management.base import BaseCommand
from UWM_Track_and_Field_Performance_Management_System.models import Athlete, CompetitionResult
import csv

def to_float_if_not_null(element):
    return float(element) if element != '' else None

class Command(BaseCommand):
    help = 'Import competition data from CSV'

    def handle(self, *args, **kwargs):
        with open('./data/ttfs_scrapedCLEAN.csv', newline='') as f:
            reader = csv.reader(f, delimiter=',')
            reader.__next__() # skip title row
            for row in reader:
                try:
                    new_test = CompetitionResult(
                        athlete=Athlete.objects.get(pk=row[0]),
                        meet_name=row[1],
                        meet_date=row[2],
                        event=row[3],
                        result_distance=to_float_if_not_null(row[4]),
                        result_time=None if row[5] == '' else row[5],
                        wind=to_float_if_not_null(row[6].strip('()+-'))
                    )
                    new_test.save()
                except:
                    continue
        self.stdout.write(self.style.SUCCESS('Import complete'))