import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../hotel_repository.dart';
import '../hotel.dart';


abstract class HotelEvent extends Equatable {
  const HotelEvent();
  // TODO: implement props
  @override
  List<Object?> get props => [];
}

class GetHotelEvent extends HotelEvent {}

// states

abstract class HotelState extends Equatable {
  const HotelState();
  @override
  List<Object> get props => [];
}

class HotelInitial extends HotelState {}

class HotelLoadingState extends HotelState {}

class HotelLoadedState extends HotelState {
  const HotelLoadedState({required this.homeHotels,required this.allHotels});
  final List<Hotel> homeHotels;
  final List<Hotel> allHotels;
  @override
  List<Object> get props => [homeHotels,allHotels];
}

class HotelEmptyState extends HotelState {}

class HotelLoadingFailedState extends HotelState {
  const HotelLoadingFailedState({required this.errorMessage});
  final String errorMessage;
}

// bloc

class HotelBloc extends Bloc<HotelEvent,HotelState>{
  final HotelRepository hotelRepository;
  HotelBloc({required this.hotelRepository}) : super(HotelInitial()){
    on<GetHotelEvent>(
            (GetHotelEvent event, Emitter<HotelState> emit) async {
          emit(HotelLoadingState());
          try {
            final Map<String,List<Hotel>> hotels = await hotelRepository.getHomeHotels();
            if (hotels["home_hotels"]!.isEmpty && hotels["home_hotels"]!.isEmpty) {
              emit(HotelEmptyState());
            } else {
              emit(HotelLoadedState(homeHotels: hotels["home_hotels"]!,allHotels: hotels["all_hotels"]!));
            }
          } catch (e) {
            emit(HotelLoadingFailedState(errorMessage: e.toString()));
          }
        });
  }

}