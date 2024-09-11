
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../airport.dart';
import '../../company.dart';
import '../flight.dart';
import '../flight_repository.dart';



abstract class FlightEvent extends Equatable {
  const FlightEvent();
  // TODO: implement props
  @override
  List<Object?> get props => [];
}

class GetFlightEvent extends FlightEvent {}

class GetBookingFlightEvent extends FlightEvent {
  final int startAirportId;
  final int endAirportId;
  final int? companyId;
  final int classId;
  final String adultsNum;
  final String childrenNum;
  final DateTime departureDate;
  final DateTime? returnDate;

  const GetBookingFlightEvent({
    required this.startAirportId,
    required this.endAirportId,
    required this.companyId,
    required this.classId,
    required this.adultsNum,
    required this.childrenNum,
    required this.departureDate,
    required this.returnDate});
}

// states

abstract class FlightState extends Equatable {
  const FlightState();
  @override
  List<Object> get props => [];
}

class FlightInitial extends FlightState {}

class FlightLoadingState extends FlightState {}

class BookingFlightLoadingState extends FlightState {}

class FlightLoadedState extends FlightState {
  const FlightLoadedState({required this.airports,required this.companies});
  final List<Airport> airports;
  final List<Company> companies;
  @override
  List<Object> get props => [airports,companies];
}

class BookingFlightLoadedState extends FlightState {
  const BookingFlightLoadedState({required this.flights});
  final List<Flight> flights;
  @override
  List<Object> get props => [flights];
}

class FlightEmptyState extends FlightState {}

class FlightLoadingFailedState extends FlightState {
  const FlightLoadingFailedState({required this.errorMessage});
  final String errorMessage;
}

// bloc

class FlightBloc extends Bloc<FlightEvent,FlightState>{
  final FlightRepository flightRepository;
  FlightBloc({required this.flightRepository}) : super(FlightInitial()){
    on<GetFlightEvent>(
            (GetFlightEvent event, Emitter<FlightState> emit) async {
          emit(FlightLoadingState());
          try {
            final List<Airport> airports = await flightRepository.getAllAirports();
            final List<Company> companies = await flightRepository.getAllCompanies();
            if (airports.isEmpty && companies.isEmpty) {
              emit(FlightEmptyState());
            } else {
              emit(FlightLoadedState(airports: airports,companies: companies));
            }
          } catch (e) {
            emit(FlightLoadingFailedState(errorMessage: e.toString()));
          }
        });
    on<GetBookingFlightEvent>(
            (GetBookingFlightEvent event, Emitter<FlightState> emit) async {
          emit(BookingFlightLoadingState());
          try {
            final List<Flight> flights =  []; // await flightRepository.getBookingFlights(event.startAirportId,event.endAirportId,event.companyId,event.adultsNum, event.childrenNum, event.classId, event.departureDate,event.returnDate);
            if (flights.isEmpty) {
              emit(FlightEmptyState());
            } else {
              emit(BookingFlightLoadedState(flights: flights));
            }
          } catch (e) {
            emit(FlightLoadingFailedState(errorMessage: e.toString()));
          }
        });
  }

}