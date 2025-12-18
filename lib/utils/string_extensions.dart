import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/logic/setting/setting_cubit.dart';
import 'package:toptenbalitour_app/logic/setting/setting_state.dart';
import 'translations.dart';

extension TranslationExtension on String {
  String tr(BuildContext context) {
    final language = context.watch<SettingCubit>().state.language;
    return AppTranslations.translate(this, language);
  }
  
  String trStatic(String language) {
    return AppTranslations.translate(this, language);
  }
}
