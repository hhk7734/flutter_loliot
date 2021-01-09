import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'react_grid_view_state.dart';

class ReactGridViewCubit extends Cubit<ReactGridViewState> {
  ReactGridViewCubit() : super(ReactGridViewInitial());
}
