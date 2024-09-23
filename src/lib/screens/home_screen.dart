
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/animal_cubit.dart';
import '../widgets/animal_text.dart';

class HomeScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('Animal Toggle App'),
			),
			body: Center(
				child: GestureDetector(
					onTap: () => context.read<AnimalCubit>().toggleAnimal(),
					child: AnimalText(),
				),
			),
		);
	}
}
