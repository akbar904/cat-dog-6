
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animal_toggle_app/screens/home_screen.dart';
import 'package:animal_toggle_app/cubits/animal_cubit.dart';
import 'package:animal_toggle_app/models/animal.dart';

// Mock Cubit for testing
class MockAnimalCubit extends MockCubit<Animal> implements AnimalCubit {}

void main() {
	group('HomeScreen Widget Tests', () {
		late AnimalCubit animalCubit;

		setUp(() {
			animalCubit = MockAnimalCubit();
			whenListen(
				animalCubit,
				Stream.fromIterable([Animal(name: 'Cat', icon: Icons.pets)]),
				initialState: Animal(name: 'Cat', icon: Icons.pets),
			);
		});

		testWidgets('should display Cat text with pets icon initially', (WidgetTester tester) async {
			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<AnimalCubit>.value(
						value: animalCubit,
						child: HomeScreen(),
					),
				),
			);

			expect(find.text('Cat'), findsOneWidget);
			expect(find.byIcon(Icons.pets), findsOneWidget);
		});

		testWidgets('should display Dog text with person icon after tap', (WidgetTester tester) async {
			whenListen(
				animalCubit,
				Stream.fromIterable([Animal(name: 'Dog', icon: Icons.person)]),
				initialState: Animal(name: 'Cat', icon: Icons.pets),
			);

			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<AnimalCubit>.value(
						value: animalCubit,
						child: HomeScreen(),
					),
				),
			);

			await tester.tap(find.text('Cat'));
			await tester.pump();

			expect(find.text('Dog'), findsOneWidget);
			expect(find.byIcon(Icons.person), findsOneWidget);
		});
	});

	group('AnimalCubit Tests', () {
		late AnimalCubit animalCubit;

		setUp(() {
			animalCubit = AnimalCubit();
		});

		blocTest<AnimalCubit, Animal>(
			'initial state is Cat',
			build: () => animalCubit,
			verify: (cubit) => expect(cubit.state, Animal(name: 'Cat', icon: Icons.pets)),
		);

		blocTest<AnimalCubit, Animal>(
			'emits Dog state when toggled from Cat',
			build: () => animalCubit,
			act: (cubit) => cubit.toggleAnimal(),
			expect: () => [Animal(name: 'Dog', icon: Icons.person)],
		);

		blocTest<AnimalCubit, Animal>(
			'emits Cat state when toggled from Dog',
			build: () => animalCubit,
			seed: () => Animal(name: 'Dog', icon: Icons.person),
			act: (cubit) => cubit.toggleAnimal(),
			expect: () => [Animal(name: 'Cat', icon: Icons.pets)],
		);
	});
}
