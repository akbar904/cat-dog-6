
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animal_toggle_app/main.dart';

class MockAnimalCubit extends MockCubit<Animal> implements AnimalCubit {}

void main() {
	group('Main app widget tests', () {
		testWidgets('MyApp initializes correctly and displays HomeScreen', (WidgetTester tester) async {
			await tester.pumpWidget(MyApp());

			expect(find.byType(HomeScreen), findsOneWidget);
		});
	});

	group('AnimalCubit tests', () {
		late AnimalCubit animalCubit;

		setUp(() {
			animalCubit = MockAnimalCubit();
		});

		blocTest<AnimalCubit, Animal>(
			'emits Animal(name: "Dog", icon: Icons.person) when toggleAnimal is called from initial state',
			build: () => animalCubit,
			act: (cubit) => cubit.toggleAnimal(),
			expect: () => [Animal(name: 'Dog', icon: Icons.person)],
		);

		blocTest<AnimalCubit, Animal>(
			'emits Animal(name: "Cat", icon: Icons.access_time) when toggleAnimal is called from Dog state',
			build: () => animalCubit,
			seed: () => Animal(name: 'Dog', icon: Icons.person),
			act: (cubit) => cubit.toggleAnimal(),
			expect: () => [Animal(name: 'Cat', icon: Icons.access_time)],
		);
	});

	group('HomeScreen widget tests', () {
		testWidgets('HomeScreen displays initial AnimalText as Cat with clock icon', (WidgetTester tester) async {
			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<AnimalCubit>(
						create: (_) => AnimalCubit(),
						child: HomeScreen(),
					),
				),
			);

			expect(find.text('Cat'), findsOneWidget);
			expect(find.byIcon(Icons.access_time), findsOneWidget);
		});

		testWidgets('HomeScreen toggles to Dog with person icon on tap', (WidgetTester tester) async {
			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<AnimalCubit>(
						create: (_) => AnimalCubit(),
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
}
