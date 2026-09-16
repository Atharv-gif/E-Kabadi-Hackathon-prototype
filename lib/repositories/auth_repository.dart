import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> loginWithPhone(String phone);
  Future<UserModel> verifyOtp(String phone, String otp);
  Future<UserModel> selectRole(UserRole role);
  Future<UserModel?> getCurrentUser();
  Future<void> logout();
}

class MockAuthRepository implements AuthRepository {
  UserModel? _currentUser = const UserModel(
    id: 'USR-7890',
    name: 'Aarav Sharma',
    phone: '+91 98765 12345',
    email: 'aarav.sharma@example.com',
    role: UserRole.citizen,
    address: 'Flat 402, Green Valley Apts, Sector 62, Noida, UP',
    rating: 4.9,
    isVerified: true,
    ecoPoints: 840,
    ecoCoins: 1250,
  );

  @override
  Future<UserModel> loginWithPhone(String phone) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _currentUser ??
        UserModel(
          id: 'USR-7890',
          name: 'Aarav Sharma',
          phone: phone,
          email: 'aarav@example.com',
          role: UserRole.citizen,
          address: 'Sector 62, Noida',
        );
  }

  @override
  Future<UserModel> verifyOtp(String phone, String otp) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _currentUser ??
        UserModel(
          id: 'USR-7890',
          name: 'Aarav Sharma',
          phone: phone,
          email: 'aarav@example.com',
          role: UserRole.citizen,
          address: 'Sector 62, Noida',
        );
  }

  @override
  Future<UserModel> selectRole(UserRole role) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final baseUser = _currentUser ??
        const UserModel(
          id: 'USR-7890',
          name: 'Aarav Sharma',
          phone: '+91 98765 12345',
          email: 'aarav@example.com',
          role: UserRole.citizen,
          address: 'Sector 62, Noida',
        );
    
    // Set specific mock data per role if needed
    if (role == UserRole.collector) {
      _currentUser = baseUser.copyWith(
        role: role,
        name: 'Ramesh Kumar (Collector)',
        address: 'Service Area: Sector 62 & 63, Noida',
      );
    } else {
      _currentUser = baseUser.copyWith(
        role: role,
        name: 'Aarav Sharma',
      );
    }
    return _currentUser!;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }
}
