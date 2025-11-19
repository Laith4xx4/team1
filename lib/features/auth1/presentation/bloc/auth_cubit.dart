import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team1/features/auth1/presentation/bloc/auth_state.dart';
import 'package:team1/features/auth1/domain/use_cases/login_user.dart';
import 'package:team1/features/auth1/domain/use_cases/register_user.dart';

/// 🧱 Authlaithshop:
/// مسؤول عن إدارة حالة (State) المصادقة مثل تسجيل الدخول والتسجيل.
/// يستخدم UseCases من طبقة الـ Domain (LoginUser و RegisterUser).
class AuthCubit extends Cubit<AuthState> {
  final LoginUser _loginUser; // حالة الاستخدام لتسجيل الدخول
  final RegisterUser _registerUser; // حالة الاستخدام للتسجيل

  /// الحالة الابتدائية هي AuthInitial
  AuthCubit(this._loginUser, this._registerUser) : super(AuthInitial());

  // ====================== 🔐 تسجيل الدخول ======================
  Future<void> login(String email, String password) async {
    // 🔸 تحقق من أن الحقول غير فارغة
    if (email.isEmpty || password.isEmpty) {
      emit(
        const AuthFailure(error: 'البريد وكلمة المرور لا يمكن أن تكون فارغة.'),
      );
      return; // توقف عن التنفيذ إذا كانت القيم فارغة
    }

    // 🔸 تحقق من صيغة البريد الإلكتروني
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emit(const AuthFailure(error: 'صيغة البريد الإلكتروني غير صحيحة.'));
      return;
    }

    // 🔄 أرسل حالة تحميل أثناء تنفيذ الطلب
    emit(AuthLoading());

    try {
      // 🔸 استدعاء حالة الاستخدام (Use Case) لتسجيل الدخول
      final user = await _loginUser(email, password);

      // ✅ عند النجاح، أرسل الحالة AuthSuccess مع بيانات المستخدم
      emit(AuthSuccess(token: user.token ?? '', user: user));
    } catch (e) {
      // ❌ في حالة حدوث خطأ، أرسل حالة AuthFailure مع رسالة الخطأ
      emit(AuthFailure(error: e.toString()));
    }
  }

  // ====================== 🧾 تسجيل حساب جديد ======================
  Future<void> register(String email, String password, String role) async {
    // 🔸 تحقق من أن الحقول غير فارغة
    if (email.isEmpty || password.isEmpty || role.isEmpty) {
      emit(
        const AuthFailure(
          error: 'البريد وكلمة المرور والدور لا يمكن أن تكون فارغة.',
        ),
      );
      return;
    }

    // 🔸 تحقق من صيغة البريد الإلكتروني
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emit(const AuthFailure(error: 'صيغة البريد الإلكتروني غير صحيحة.'));
      return;
    }

    // 🔄 أرسل حالة تحميل أثناء تنفيذ الطلب
    emit(AuthLoading());

    try {
      // 🔸 استدعاء حالة الاستخدام (Use Case) للتسجيل
      final user = await _registerUser(email, password, role);

      // ✅ عند النجاح، أرسل AuthSuccess مع بيانات المستخدم الجديدة
      emit(AuthSuccess(token: user.token ?? '', user: user));

      // ملاحظة: يمكن إنشاء حالة منفصلة مثل RegisterSuccess إذا رغبت
    } catch (e) {
      // ❌ في حالة الخطأ، أرسل AuthFailure مع نص الخطأ
      emit(AuthFailure(error: e.toString()));
    }
  }

  // ====================== 🚪 تسجيل الخروج ======================
  void logout() async {
    // حذف التوكن من SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    // إعادة الحالة للبداية
    emit(AuthInitial());
  }

}
