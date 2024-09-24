import 'tajweed_rule.dart';
import 'tajweed_subrule.dart';

class TajweedToken implements Comparable<TajweedToken> {
  TajweedRule rule;
  TajweedSubrule? subrule;
  int? subruleSubindex;

  String? matchGroup;
  String text;

  int startIx;
  int endIx;

  TajweedToken(
    this.rule,
    this.subrule,
    this.subruleSubindex,
    this.text,
    this.startIx,
    this.endIx,
    this.matchGroup,
  );

  bool isRule() {
    return rule != TajweedRule.none;
  }

  bool isNotRule() {
    return rule == TajweedRule.none;
  }

  bool get canBreakAfter => text.endsWith(' ');

  @override
  int compareTo(TajweedToken other) {
    if (startIx < other.startIx) {
      return -1;
    } else if (startIx > other.startIx) {
      return 1;
    }

    return 0;
  }

  @override
  String toString() {
    return 'TajweedToken{ from: $startIx to: $endIx group: $rule subrule: $subrule subindex: $subruleSubindex text: \'$text\' matchGroup: $matchGroup }';
  }
}
