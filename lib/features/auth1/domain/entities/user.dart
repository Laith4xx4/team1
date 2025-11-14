// تعريف كلاس User الذي يمثل المستخدم داخل التطبيق
class User {
  // معرف فريد للمستخدم
  final String id;

  // البريد الإلكتروني للمستخدم
  final String email;

  // دور المستخدم (مثل "admin" أو "user")
  final String role;

  // توكن المصادقة، قد يكون null لبعض العمليات
  final String? token;

  // الكونستركتور لإنشاء كائن User
  // الحقول id, email, role مطلوبة، أما token فهو اختياري
  User({required this.id, required this.email, required this.role, this.token});

  // إعادة تعريف عامل المساواة == لمقارنة كائنات User
  @override
  bool operator ==(Object other) {
    // إذا كان نفس المرجع، فهو متساوي
    if (identical(this, other)) return true;

    // مقارنة القيم الفعلية للحقل id, email, role, token
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.role == role &&
        other.token == token;
  }

  // إعادة تعريف hashCode لدعم الاستخدام في الـ collections مثل Set أو Map
  @override
  int get hashCode {
    // استخدام XOR بين hashCode الخاص بكل حقل لضمان تمييز الكائنات
    return id.hashCode ^ email.hashCode ^ role.hashCode ^ token.hashCode;
  }
}
