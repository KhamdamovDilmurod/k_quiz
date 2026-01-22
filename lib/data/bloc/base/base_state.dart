import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BaseState extends Equatable {
  @override
  List<Object?> get props => [UniqueKey()];
}

class InitialState extends BaseState {
  @override
  List<Object?> get props => [UniqueKey()];
}

class ShowLoadingState extends BaseState {
  final bool show;

  ShowLoadingState(this.show);

  @override
  List<Object?> get props => [UniqueKey()];
}

class SuccessLoadState extends BaseState {
  @override
  List<Object?> get props => [UniqueKey()];
}

class ShowErrorMessage extends BaseState {
  final String message;

  ShowErrorMessage(this.message);

  @override
  List<Object?> get props => [UniqueKey()];
}

class UpdateFieldState extends BaseState {
  @override
  List<Object?> get props => [UniqueKey()];
}

class SuccessSubmitState extends BaseState {
  @override
  List<Object?> get props => [UniqueKey()];
}

class ShowSubmitLoadingState extends BaseState {
  final bool show;

  ShowSubmitLoadingState(this.show);

  @override
  List<Object?> get props => [UniqueKey()];
}

class LoadedState<T> extends BaseState {
  final T loadedData;

  LoadedState(this.loadedData);

  @override
  List<Object?> get props => [UniqueKey()];
}