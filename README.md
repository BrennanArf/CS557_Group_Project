This is a project built to streamline UWM Track and Field data. Contributors include Adaline Powell, Austin Witte, Brennan Arfstrom, Carmel Illunga, and Jersemy De Jesus-Ortiz. 

# Instructions
---
## Cloning the repository
To run this project, a clone of the repository is needed. 
  This can be done by clicking the < > code button on the repository and copying the HTTPS web URL. Then the project can be cloned with either the terminal by running commands or using GitHub Desktop

## Dependencies
Python 3.13 or later is recommended, and can be installed using the official installer from the [Python website](https://www.python.org/downloads/). You may want to create a virtual environment to manage package versions. To do so, you can enter the project folder and run the following commands in a terminal:

```python -m venv .\venv\```

```.\venv\Scripts\activate```

**Note:** You will need to run the activate script every time you wish to run the application in a new PowerShell/Terminal.

Regardless of whether you decide to use a virtual environment, run:

```python -m pip install django```

```python -m pip install mysqlclient```

```python -m pip install PyMySQL```
  
## Database Creation
Once cloned, the database needs to be connected. 
  (MySQL needs to be installed on the computer being used)
  This is done by creating a MySQL connection and creating the database by running
  ```CREATE DATABASE UWM_Track_Field_db;```
  in a query tab.

## Database Connection
Now the database needs to be connected to the Django project.
  In settings.py from the CS557_Group_Project directory, add your corresponding information to the DATABASES dictionary from the MySQl connection that was made, 'USER': '<your_username>','PASSWORD': '<your_password>, under the 'DEFAULT' field.

## Performing Migrations
Now that the database is connected, run 

```python manage.py makemigrations```

```python manage.py migrate``` 

to migrate all tables into the database. 

**Note:** If this throws an error, you may need to restart from scratch. Drop the database and empty the migrations folder in the UWM_Track_and_Field_Performance_Management_System folder. Then try running the following commands in order:

```python manage.py makemigrations UWM_Track_and_Field_Performance_Management_System```

```python manage.py migrate UWM_Track_and_Field_Performance_Management_System```

```python manage.py makemigrations```

```python manage.py migrate``` 

This will ensure the custom authentication system is used by the project instead of Django's default.
  
## Importing Data  
Data can be imported using the respective CSV files in the data directory. 
  
  ```python manage.py import_athletes```  
  
  ```python manage.py import_competition_results```
  
  ```python manage.py import_fall_testing```
  
  ```python manage.py import_practice_data.```

## Running the Server
Finally, now that the project is cloned, the database is connected, and all data is in the database, 
  you can run the project using 
  
  ```python manage.py runserver``` 
  
  and ctrl+click on the local server http://127.0.0.1:8000/ or copy the url into your browser window.
