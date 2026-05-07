"""
URL configuration for CS557_Group_Project project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/6.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from django.contrib.auth import views as auth_views
from UWM_Track_and_Field_Performance_Management_System.views import HomeView, SignUpView, LogoutView, AthleteView, \
    CompetitionResultsView, FallTestingView, PracticeResultView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('home/admin/', admin.site.urls),
    path('', auth_views.LoginView.as_view(template_name='login.html'), name='login'),
    path('home/', HomeView.as_view(), name='home'),
    path('signup/', SignUpView.as_view(), name='signup'),
    path('logout/', LogoutView, name='logout'),
    path('home/athletes/', AthleteView.as_view(), name='athletes'),
    path('home/competition_results/', CompetitionResultsView.as_view(), name='comp_results'),
    path('home/fall_testing/', FallTestingView.as_view(), name='fall_testing'),
    path('home/practice/', PracticeResultView.as_view(), name='practice'),
]
