import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steady_just_study/services/applied_ai_service.dart';

final appliedAIServiceProvider = Provider<AppliedAIService>((ref) {
  return AppliedAIService();
});
