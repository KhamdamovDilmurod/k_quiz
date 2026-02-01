import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'writing_event.dart';
part 'writing_state.dart';

class WritingBloc extends Bloc<WritingEvent, WritingState> {
  WritingBloc() : super(WritingInitial()) {
    on<WritingEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
