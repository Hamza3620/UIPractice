import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout_widgets/bloc/invoice_events.dart';
import 'package:layout_widgets/bloc/invoice_states.dart';
import 'package:layout_widgets/model.dart';

class InvoiceBloc extends Bloc<InvoiceEvents, InvoiceStates> {
  bool _isPaid = false;
  get getPaidValue => _isPaid;

  double _subtotal = 0;
  get getSubtotal => _subtotal;

  double _commission = 0;
  get getCommission => _commission;
  double _gst = 0;
  get getGst => _gst;

  double _total = 0;
  get getTotal => _total;

  List<ItemDetails> _items = [
    ItemDetails("Paint", 2, 100),
    ItemDetails("Wood", 10, 200),
    ItemDetails("Door", 4, 250),
  ];
  get getItems => _items;

  InvoiceBloc(super.initialState) {
    on<FetchInvoice>(
      (event, emit) async {
        emit(Loading());
        // Logic goes here
        for (int i = 0; i < _items.length; i++) {
          _subtotal += _items[i].count * _items[i].price;
        }

        _commission = _subtotal * 0.1;
        _gst = _subtotal * 0.1;

        _total = _subtotal + _commission + _gst;
        emit(Idle());
      },
    );
    on<TogglePaidValue>(
      (event, emit) async {
        emit(Loading());
        _isPaid = !_isPaid;

        // Logic goes here
        emit(Idle());
      },
    );
    on<Print>(
      (event, emit) async {
        emit(Loading());
        // Logic goes here
        emit(Idle());
      },
    );
    on<EditInvoice>(
      (event, emit) async {
        emit(Loading());
        // Logic goes here
        emit(Idle());
      },
    );
  }
}
