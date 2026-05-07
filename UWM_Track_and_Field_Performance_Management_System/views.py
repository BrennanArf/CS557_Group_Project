from django.contrib import messages
from django.contrib.auth import authenticate, login, get_user_model
from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import render, redirect
from django.views import View



# Create your views here.
class HomeView(LoginRequiredMixin,View):
    def get(self, request):
        return render(request, 'home.html')


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

        user = User.objects.create_user(
            username=username,
            email=email,
            password=password,
            role=role
        )

        messages.success(request, 'Account created successfully. You can now log in.')
        return redirect('login')
