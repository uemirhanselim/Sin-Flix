import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthToken extends HomeEvent {}

class GetMoviesEvent extends HomeEvent {
  final int page;

  const GetMoviesEvent({required this.page});

  @override
  List<Object> get props => [page];
}
