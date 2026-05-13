This is a project built to streamline UWM Track and Field data. Contributors include Adaline Powell, Austin Witte, Brennan Arfstrom, Carmel Illunga, and Jersemy De Jesus-Ortiz

HOW TO RUN PROJECT:
To run this project, a clone of the repository is needed. 
  This can be done by clicking the < > code button on the repository and copying the HTTPS web URL. Then the project can be cloned with either the terminal by running commands or using GitHub Desktop

Once cloned, the database needs to be connected. 
  (MySQL needs to be installed on the computer being used)
  This is done by creating a MySQL connection and creating the database by running: CREATE DATABASE UWM_Track_Field_db; in a query tab.

Now the database needs to be connected to the Django project.
  In settings.py from the CS557_Group_Project directory, add your corresponding information to the DATABASES dict from the MySQl connection that was made, 'USER': '<your_username>','PASSWORD': '<your_password>. Also, if PyMySql is not installed, run python -m pip install PyMySQL in the terminal. If Django is not installed, run pip install django as well.

Now that the database is connected,
  you can run python manage.py migrate to migrate all tables into the database. Then run python manage.py import_ahtletes,  manage.py import_competition_results,  manage.py import_fall_testing,  manage.py import_practice_data

Finally, now that the project is cloned, the database is connected, and all data is in the database, 
  you can run the project using pyhton manage.py runserver, and click on the local server http://127.0.0.1:8000/
