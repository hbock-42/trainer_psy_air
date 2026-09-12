import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/engines/spatial_overlay/domain/overlay_algebra.dart';

void main() {
  group('combineCoverage', () {
    test('uncovered is none', () {
      expect(combineCoverage(coverCount: 0, greyCount: 0), CellColour.none);
    });

    test('navy + navy = navy', () {
      expect(combineCoverage(coverCount: 2, greyCount: 0), CellColour.navy);
    });

    test('navy alone = navy', () {
      expect(combineCoverage(coverCount: 1, greyCount: 0), CellColour.navy);
    });

    test('navy + grey = grey', () {
      expect(combineCoverage(coverCount: 2, greyCount: 1), CellColour.grey);
    });

    test('grey + grey = navy', () {
      expect(combineCoverage(coverCount: 2, greyCount: 2), CellColour.navy);
    });

    test('grey alone = grey', () {
      expect(combineCoverage(coverCount: 1, greyCount: 1), CellColour.grey);
    });

    test('an odd number of greys is always grey, an even number always navy '
        '(any cover count)', () {
      for (var cover = 1; cover <= 6; cover++) {
        for (var grey = 0; grey <= cover; grey++) {
          final result = combineCoverage(coverCount: cover, greyCount: grey);
          expect(
            result,
            grey.isOdd ? CellColour.grey : CellColour.navy,
            reason: 'cover=$cover grey=$grey',
          );
        }
      }
    });
  });

  group('TargetCell.matches', () {
    test('navy matches only navy', () {
      expect(TargetCell.navy.matches(CellColour.navy), isTrue);
      expect(TargetCell.navy.matches(CellColour.grey), isFalse);
      expect(TargetCell.navy.matches(CellColour.none), isFalse);
    });

    test('grey matches only grey', () {
      expect(TargetCell.grey.matches(CellColour.grey), isTrue);
      expect(TargetCell.grey.matches(CellColour.navy), isFalse);
      expect(TargetCell.grey.matches(CellColour.none), isFalse);
    });

    test('empty and black both require none', () {
      expect(TargetCell.empty.matches(CellColour.none), isTrue);
      expect(TargetCell.empty.matches(CellColour.navy), isFalse);
      expect(TargetCell.black.matches(CellColour.none), isTrue);
      expect(TargetCell.black.matches(CellColour.grey), isFalse);
    });

    test('mustStayUncovered is true only for empty and black', () {
      expect(TargetCell.empty.mustStayUncovered, isTrue);
      expect(TargetCell.black.mustStayUncovered, isTrue);
      expect(TargetCell.navy.mustStayUncovered, isFalse);
      expect(TargetCell.grey.mustStayUncovered, isFalse);
    });
  });
}
