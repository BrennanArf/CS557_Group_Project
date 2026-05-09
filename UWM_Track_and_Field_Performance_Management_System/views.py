from django.contrib import messages
from django.contrib.auth import authenticate, login, get_user_model, logout
from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import render, redirect
from django.views import View

from UWM_Track_and_Field_Performance_Management_System.models import Athlete, CompetitionResult, FallTesting, \
    PracticeResult


# Create your views here.
class HomeView(LoginRequiredMixin,View):
    def get(self, request):
        return render(request, 'home.html')

class AthleteView(LoginRequiredMixin,View):
    def get(self, request):
        if request.user.role == "Student":
            athletes = Athlete.objects.filter(athlete_id=request.user.athlete_id)
            context = {'athletes': athletes}
        else:
            athletes = Athlete.objects.all()
            editing_id = request.GET.get('edit')
            context = {'athletes': athletes, 'editing_id':int(editing_id) if editing_id else None}
    
        return render(request, 'athletes.html', context)
    
    def post(self, request):
        method = request.POST.get('_method', '')
        print(method)
        if method == 'put':
            return self.put(request)
        elif method == 'delete':
            return self.delete(request)
        else:
            # POST, create
            name = request.POST.get('name', '').split(' ')
            first_name, last_name = name[0], name[1]
            gender = request.POST.get('gender', '')
            event_group = request.POST.get('event_group', '')
            athlete = Athlete.objects.create(
            first_name=first_name, 
            last_name=last_name, 
            gender=gender,
            event_group=event_group if event_group else None)
            athlete.save()

            return redirect('/home/athletes')
        
    
    def put(self, request):
        athlete = Athlete.objects.get(athlete_id=request.POST.get('athlete_id', ''))

        first_name, last_name = request.POST.get('name', '').split(' ')
        athlete.first_name = first_name
        athlete.last_name = last_name
        athlete.gender = request.POST.get('gender', '')
        athlete.event_group = request.POST.get('event_group', '')
        athlete.save()

        return redirect('/home/athletes')
    
    def delete(self, request):
        athlete = Athlete.objects.get(athlete_id=request.POST.get('athlete_id', ''))
        athlete.delete()
        
        return redirect('/home/athletes')

class CompetitionResultsView(LoginRequiredMixin, View):
    def get(self, request):
        if request.user.role == "Student":
            comp_results = CompetitionResult.objects.filter(athlete_id=request.user.athlete_id)
        else:
            comp_results = CompetitionResult.objects.all()
        context = {'comp_results': comp_results}
        return render(request, 'competition_results.html', context)

class FallTestingView(LoginRequiredMixin, View):
    def get(self, request):
        if request.user.role == "Student":
            fall_testing = FallTesting.objects.filter(athlete_id=request.user.athlete_id)
        else:
            fall_testing = FallTesting.objects.all()   
        context = {'fall_testing': fall_testing}
        return render(request, 'fall_testing.html', context)

class PracticeResultView(LoginRequiredMixin, View):
    def get(self, request):
        if request.user.role == "Student":
            practice_results = PracticeResult.objects.filter(athlete_id=request.user.athlete_id)
        else:
            practice_results = PracticeResult.objects.all()
        context = {'practice_results': practice_results}
        return render(request, 'practice.html', context)


class LoginView(View):
    def get(self, request):
        return render(request, 'login.html')

    def post(self, request):
        username = request.POST.get('username', '').strip()
        password = request.POST.get('password', '').strip()

        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('home')
        else:
            messages.error(request, "Invalid username or password.")
            return redirect('login')

User = get_user_model()
class SignUpView(View):
    def get(self, request):
        return render(request, 'signup.html')

    def post(self, request):
        username = request.POST.get('username', '').strip()
        email = request.POST.get('email', '').strip()
        password = request.POST.get('password', '').strip()
        role = request.POST.get('role', '').strip()

        if not username or not email or not password:
            messages.error(request, 'Username and password are required.')
            return redirect('signup')

        if User.objects.filter(username=username).exists():
            messages.error(request, 'Username already taken.')
            return redirect('signup')

        if role == "Student":
            first_name = request.POST.get('fname', '').strip()
            last_name = request.POST.get('lname', '').strip()
            gender = request.POST.get('gender', '').strip()

            user = User.objects.create_user(
                username=username,
                email=email,
                password=password,
                role=role,
                athlete=Athlete.objects.get_or_create(first_name=first_name, last_name=last_name, gender=gender)[0]
            )
        else:
            user = User.objects.create_user(
                username=username,
                email=email,
                password=password,
                role=role,
                athlete=None
            )

        messages.success(request, 'Account created successfully. You can now log in.')
        return redirect('login')

def LogoutView(request):
        if request.method == 'POST':
            logout(request)
            return redirect('login')


