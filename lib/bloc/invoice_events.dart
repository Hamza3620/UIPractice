import 'package:equatable/equatable.dart';

class InvoiceEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchInvoice extends InvoiceEvents {}

class TogglePaidValue extends InvoiceEvents {}

class Print extends InvoiceEvents {}

class EditInvoice extends InvoiceEvents {}
