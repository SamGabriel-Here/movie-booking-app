import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movie_booking_app/main.dart';
import 'package:movie_booking_app/widgets/movie_card.dart';

void main() {
  testWidgets('Home screen shows movie list', (WidgetTester tester) async {
    await tester.pumpWidget(const MovieBookingApp());

    expect(find.text('ShowRush', findRichText: true), findsOneWidget);
    expect(find.byType(MovieCard), findsWidgets);
    expect(find.byType(TextField), findsOneWidget);
  });
}
