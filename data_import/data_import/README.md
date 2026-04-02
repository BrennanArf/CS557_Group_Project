CS557_Group_Project/
│
├── README.md
├── manage.py
├── requirements.txt
│
├── cs557_group_project/          # Django project settings
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   ├── wsgi.py
│   └── asgi.py
│
├── apps/                         # All Django apps live here
│   ├── athletes/
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   ├── admin.py
│   │   ├── serializers.py
│   │   └── tests.py
│   │
│   ├── meets/
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   ├── admin.py
│   │   ├── serializers.py
│   │   └── tests.py
│   │
│   ├── practice/
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   ├── admin.py
│   │   ├── serializers.py
│   │   └── tests.py
│   │
│   ├── fall_testing/
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   ├── admin.py
│   │   ├── serializers.py
│   │   └── tests.py
│   │
│   └── authentication/
│       ├── models.py
│       ├── views.py
│       ├── urls.py
│       ├── admin.py
│       ├── serializers.py
│       └── tests.py
│
├── data_import/                  # ⭐ Your main responsibility
│   ├── tfrrs_import.py
│   ├── fall_testing_import.py
│   ├── practice_metrics_import.py
│   ├── utils.py                  # shared cleaning functions
│   └── README.md                 # explains how to run imports
│
├── sample_data/                  # For testing imports
│   ├── fall_testing_2023.xlsx
│   ├── practice_metrics_example.xlsx
│   └── tfrrs_sample.html
│
├── docs/                         # Project documentation
│   ├── proposal.pdf
│   ├── erd.png
│   ├── api_endpoints.md
│   ├── data_dictionary.md
│   └── sprint_plan.md
│
├── templates/                    # HTML templates
│   └── base.html
│
└── static/                       # CSS, JS, images
    ├── css/
    ├── js/
    └── images/
