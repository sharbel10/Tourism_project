import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../hotel.dart';
import '../hotel_repository.dart';



abstract class HotelDetailsEvent extends Equatable {
  const HotelDetailsEvent();
  // TODO: implement props
  @override
  List<Object?> get props => [];
}

class GetHotelDetailsEvent extends HotelDetailsEvent {
  final int? id;
  const GetHotelDetailsEvent({this.id});
}



abstract class HotelDetailsState extends Equatable {
  const HotelDetailsState();
  @override
  List<Object> get props => [];
}

class HotelDetailsInitial extends HotelDetailsState {
  final int? id;
  const HotelDetailsInitial({this.id});
}

class HotelDetailsLoadingState extends HotelDetailsState {}

class HotelDetailsLoadingDetailsState extends HotelDetailsState {}

class HotelDetailsLoadedState extends HotelDetailsState {
  const HotelDetailsLoadedState({required this.details});
  final Hotel details;

  @override
  List<Object> get props => [details];
}


class HotelDetailsEmptyState extends HotelDetailsState {}

class HotelDetailsLoadingFailedState extends HotelDetailsState {
  const HotelDetailsLoadingFailedState({required this.errorMessage});
  final String errorMessage;
}

class HotelDetailsBloc extends Bloc<HotelDetailsEvent, HotelDetailsState> {
  final HotelRepository hotelRepository;
  HotelDetailsBloc({required this.hotelRepository}) : super(const HotelDetailsInitial()){
    on<GetHotelDetailsEvent>(
            (GetHotelDetailsEvent event, Emitter<HotelDetailsState> emit) async {
          emit(HotelDetailsLoadingState());
          try {
            final Hotel? details = await hotelRepository.getHotelDetails(event.id ?? 9999);
            if (details == null) {
              emit(HotelDetailsEmptyState());
            } else {
              emit(HotelDetailsLoadedState(details: details));
            }
          } catch (e) {
            emit(HotelDetailsLoadingFailedState(errorMessage: e.toString()));
          }
        });
  }

}