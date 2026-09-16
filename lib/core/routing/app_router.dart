
import 'package:go_router/go_router.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/customer/booking/booking_screen.dart';
import '../../presentation/ai_consultation/ai_consultation_screen.dart';
import '../../presentation/profile/profile_screen.dart';
import '../../presentation/profile/edit_profile_screen.dart';
import '../../presentation/admin/dashboard/admin_dashboard_screen.dart';
import '../../presentation/auth/splash_screen.dart';
import '../../presentation/services/services_list_screen.dart';
import '../../presentation/services/service_detail_screen.dart';
import '../../presentation/customer/home/customer_home_screen.dart';
import '../../domain/entities/service_entity.dart';
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/customer-home',
        builder: (context, state) => const CustomerHomeScreen(),
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) => const BookingScreen(),
      ),
      GoRoute(
        path: '/ai-consultation',
        builder: (context, state) => const AiConsultationScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/services',
        builder: (context, state) => const ServicesListScreen(),
      ),
      GoRoute(
        path: '/service-detail',
        builder: (context, state) {
          if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            return ServiceDetailScreen(
              service: map['service'] as ServiceEntity,
              heroTag: map['heroTag'] as String?,
            );
          }
          final service = state.extra as ServiceEntity;
          return ServiceDetailScreen(service: service);
        },
      ),
    ],
  );
}
