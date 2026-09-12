import 'package:flutter/widgets.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

/// Renders a [FakeEngine] MCQ as its stem, the phase name and one tappable
/// text per option (`Key('fake.option.<i>')`), for `SessionHost` tests.
class FakeRenderer extends ActivityRenderer {
  const FakeRenderer({this.familyId = 'fake_family', this.withExample = false});

  @override
  final String familyId;

  final bool withExample;

  static Key optionKey(int index) => Key('fake.option.$index');
  static const Key exampleKey = Key('fake.example');

  @override
  Widget build(BuildContext context, ActivityRenderContext render) {
    final item = render.item as McqItem;
    return Column(
      children: [
        Text(item.stem.fr),
        Text('phase:${render.phase.name}'),
        Text('feedback:${render.feedback?.correct}'),
        for (final (i, option) in item.options.indexed)
          GestureDetector(
            key: optionKey(i),
            onTap: render.acceptsInput
                ? () => render.onAnswer(Answer.choice(i))
                : null,
            child: Text(option.text!.fr),
          ),
      ],
    );
  }

  @override
  Widget? buildExample(BuildContext context) =>
      withExample ? const Text('example', key: exampleKey) : null;
}
