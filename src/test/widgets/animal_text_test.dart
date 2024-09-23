
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'animal_text.dart';
import '../cubits/animal_cubit.dart';

// Mock AnimalCubit
class MockAnimalCubit extends MockCubit<Animal> implements AnimalCubit {}

void main() {
	group('AnimalText Widget Tests', () {
		late AnimalCubit animalCubit;

		setUp(() {
			animalCubit = MockAnimalCubit();
		});

		testWidgets('Displays Cat with clock icon initially', (WidgetTester tester) async {
			when(() => animalCubit.state).thenReturn(Animal(name: 'Cat', icon: Icons.access_time));

			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<AnimalCubit>.value(
						value: animalCubit,
						child: AnimalText(),
					),
				),
			);

			expect(find.text('Cat'), findsOneWidget);
			expect(find.byIcon(Icons.access_time), findsOneWidget);
		});

		testWidgets('Displays Dog with person icon after state change', (WidgetTester tester) async {
			whenListen(
				animalCubit,
				Stream.fromIterable([Animal(name: 'Dog', icon: Icons.person)]),
			);
			when(() => animalCubit.state).thenReturn(Animal(name: 'Dog', icon: Icons.person));

			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<AnimalCubit>.value(
						value: animalCubit,
						child: AnimalText(),
					),
				),
			);

			await tester.pump(); // Rebuild the widget

			expect(find.text('Dog'), findsOneWidget);
			expect(find.byIcon(Icons.person), findsOneWidget);
		});

		testWidgets('Toggles animal on tap', (WidgetTester tester) async {
			when(() => animalCubit.state).thenReturn(Animal(name: 'Cat', icon: Icons.access_time));

			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<AnimalCubit>.value(
						value: animalCubit,
						child: AnimalText(),
					),
				),
			);

			await tester.tap(find.text('Cat'));
			await tester.pump();

			verify(() => animalCubit.toggleAnimal()).called(1);
		});
	});
}
