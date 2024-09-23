
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/animal.dart';
import 'package:flutter/material.dart';

class AnimalCubit extends Cubit<Animal> {
	AnimalCubit() : super(Animal(name: 'Cat', icon: Icons.access_time));

	void toggleAnimal() {
		if (state.name == 'Cat') {
			emit(Animal(name: 'Dog', icon: Icons.person));
		} else {
			emit(Animal(name: 'Cat', icon: Icons.access_time));
		}
	}
}
