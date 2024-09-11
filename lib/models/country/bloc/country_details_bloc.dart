import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../region.dart';
import '../country_repository.dart';


abstract class CountryDetailsEvent extends Equatable {
  const CountryDetailsEvent();
  // TODO: implement props
  @override
  List<Object?> get props => [];
}

class GetCountryDetailsEvent extends CountryDetailsEvent {
  final int? id;
  const GetCountryDetailsEvent({this.id});
}



abstract class CountryDetailsState extends Equatable {
  const CountryDetailsState();
  @override
  List<Object> get props => [];
}

class CountryDetailsInitial extends CountryDetailsState {
  final int? id;
  const CountryDetailsInitial({this.id});
}

class CountryDetailsLoadingState extends CountryDetailsState {}

class CountryDetailsLoadingDetailsState extends CountryDetailsState {}

class CountryDetailsLoadedState extends CountryDetailsState {
  const CountryDetailsLoadedState({required this.details});
  final Region details;

  @override
  List<Object> get props => [details];
}


class CountryDetailsEmptyState extends CountryDetailsState {}

class CountryDetailsLoadingFailedState extends CountryDetailsState {
  const CountryDetailsLoadingFailedState({required this.errorMessage});
  final String errorMessage;
}

class CountryDetailsBloc extends Bloc<CountryDetailsEvent, CountryDetailsState> {
  final CountryRepository countryRepository;
  CountryDetailsBloc({required this.countryRepository}) : super(const CountryDetailsInitial()){
    on<GetCountryDetailsEvent>(
            (GetCountryDetailsEvent event, Emitter<CountryDetailsState> emit) async {
          emit(CountryDetailsLoadingState());
          try {
            final Region? details = await countryRepository.getCountryDetails(event.id ?? 9999);
            if (details == null) {
              emit(CountryDetailsEmptyState());
            } else {
              emit(CountryDetailsLoadedState(details: details));
            }
          } catch (e) {
            emit(CountryDetailsLoadingFailedState(errorMessage: e.toString()));
          }
        });
  }
  void getCountryDetails(int id){

  }

}