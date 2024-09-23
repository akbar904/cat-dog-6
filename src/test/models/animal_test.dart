
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:com.walturn/models/animal.dart';

void main() {
	group('Animal Model', () {
		test('Animal model should serialize correctly', () {
			final animal = Animal(name: 'Cat', icon: Icons.pets);
			final json = animal.toJson();
			expect(json, {'name': 'Cat', 'icon': Icons.pets.codePoint});
		});

		test('Animal model should deserialize correctly', () {
			final json = {'name': 'Dog', 'icon': Icons.person.codePoint};
			final animal = Animal.fromJson(json);
			expect(animal.name, 'Dog');
			expect(animal.icon, Icons.person);
		});
	});
}

class MockAnimal extends Mock implements Animal {}

extension on Animal {
	Map<String, dynamic> toJson() {
		return {
			'name': name,
			'icon': icon.codePoint,
		};
	}

	static Animal fromJson(Map<String, dynamic> json) {
		return Animal(
			name: json['name'] as String,
			icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
		);
	}
}
