import 'package:equatable/equatable.dart';

class InvoiceStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends InvoiceStates {}

class Idle extends InvoiceStates {}
