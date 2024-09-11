import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:comeback/Localization/Cubit/Locale_State.dart';
import 'package:comeback/Localization/LanguageCachHelper.dart';
import 'package:meta/meta.dart';
class Locale_cubit extends Cubit<ChangedLocalState>{
  Locale_cubit() : super (ChangedLocalState(locale: 'en'));
   Future <void> getSavedLanguage() async {
     final String cachedLanguageCode = await LanguageCacheHelper().getCachedLanguageCode();
     emit(ChangedLocalState(locale: cachedLanguageCode));
  }
  Future<void> changelanguage(String languagecode)async{
     await LanguageCacheHelper().cacheLanguageCode(languagecode);
     emit(ChangedLocalState(locale: languagecode));
  }
}