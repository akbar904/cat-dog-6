
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/animal_cubit.dart';

class AnimalText extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		final animal = context.watch<AnimalCubit>().state;

		return GestureDetector(
			onTap: () {
				context.read<AnimalCubit>().toggleAnimal();
			},
			child: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					Icon(animal.icon),
					SizedBox(width: 8),
					Text(animal.name),
				],
			),
		);
	}
}
