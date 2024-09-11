import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../country.dart';
import '../country_repository.dart';


abstract class CountryEvent extends Equatable {
  const CountryEvent();
  // TODO: implement props
  @override
  List<Object?> get props => [];
}

class GetCountryEvent extends CountryEvent {}

class GetCountryDetailsEvent extends CountryEvent {}

abstract class CountryState extends Equatable {
  const CountryState();
  @override
  List<Object> get props => [];
}

class CountryInitial extends CountryState {}

class CountryLoadingState extends CountryState {}

class CountryLoadingDetailsState extends CountryState {}

class CountryLoadedState extends CountryState {
  const CountryLoadedState({required this.countries});
  final List<Country> countries;

  @override
  List<Object> get props => [countries];
}


class CountryEmptyState extends CountryState {}

class CountryLoadingFailedState extends CountryState {
  const CountryLoadingFailedState({required this.errorMessage});
  final String errorMessage;
}

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final CountryRepository countryRepository;
  CountryBloc({required this.countryRepository}) : super(CountryInitial()) {
    on<GetCountryEvent>(
            (GetCountryEvent event, Emitter<CountryState> emit) async {
          emit(CountryLoadingState());
          try {
            final countries = await countryRepository.getCountries();
            if (countries.isEmpty) {
              emit(CountryEmptyState());
            } else {
              emit(CountryLoadedState(countries: countries));
            }
          } catch (e) {
            print("object");
            emit(CountryLoadingFailedState(errorMessage: e.toString()));
          }
        });
  }

}