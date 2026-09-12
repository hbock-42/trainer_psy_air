import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/train/domain/engine/answer.dart';

void main() {
  group('Answer', () {
    const answers = <(Answer, Map<String, Object?>)>[
      (Answer.choice(2), {'kind': 'choice', 'index': 2}),
      (Answer.numeric(4.5), {'kind': 'numeric', 'value': 4.5}),
      (
        Answer.multiSelect([1, 4]),
        {
          'kind': 'multiSelect',
          'indices': [1, 4],
        },
      ),
      (Answer.key('n'), {'kind': 'key', 'key': 'n'}),
      (
        Answer.sequence(['3', '1']),
        {
          'kind': 'sequence',
          'values': ['3', '1'],
        },
      ),
      (Answer.skip(), {'kind': 'skip'}),
      (Answer.timeout(), {'kind': 'timeout'}),
      (
        Answer.raw({'restarts': 2}),
        {
          'kind': 'raw',
          'payload': {'restarts': 2},
        },
      ),
    ];

    for (final (answer, json) in answers) {
      test('${json['kind']} round-trips through JSON', () {
        expect(answer.toJson(), json);
        expect(Answer.fromJson(json), answer);
      });
    }

    test('flags timeout and skip', () {
      expect(const Answer.timeout().isTimeout, isTrue);
      expect(const Answer.timeout().isSkip, isFalse);
      expect(const Answer.skip().isSkip, isTrue);
      expect(const Answer.choice(0).isTimeout, isFalse);
    });
  });
}
