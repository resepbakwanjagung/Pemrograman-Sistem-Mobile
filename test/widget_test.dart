import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokokita/main.dart';
import 'package:tokokita/widgets/product_card.dart';

void main() {
  testWidgets('TokoKita Pertemuan 3 Widget Test', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const MyApp());

    // Verify main app title and product cards rendering
    expect(find.text('TokoKita - Pertemuan 3'), findsOneWidget);
    expect(find.byType(ProductCard), findsWidgets);

    // Verify favorite icon interaction
    final favoriteButton = find.byIcon(Icons.favorite_border).first;
    expect(favoriteButton, findsOneWidget);

    await tester.tap(favoriteButton);
    await tester.pump();

    // Verify favorite icon changed to filled red favorite icon
    expect(find.byIcon(Icons.favorite), findsWidgets);
  });
}
