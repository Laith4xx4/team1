// استيراد كلاس User من مجلد الـ domain entities
import 'package:team1/features/auth1/domain/entities/user.dart';

// تعريف واجهة (abstract class) لمستودع المصادقة
abstract class AuthRepository {
  // دالة لتسجيل دخول المستخدم
  // تأخذ البريد الإلكتروني وكلمة المرور كمعاملات
  // تعيد Future يحتوي على كائن User عند نجاح تسجيل الدخول
  Future<User> login(String email, String password);

  // دالة لتسجيل مستخدم جديد
  // تأخذ البريد الإلكتروني وكلمة المرور والدور (role) كمعاملات
  // تعيد Future يحتوي على كائن User عند نجاح التسجيل
  Future<User> register(String email, String password, String role);
}
