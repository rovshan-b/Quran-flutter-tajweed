import 'tajweed_rule.dart';

import 'tajweed_subrule.dart';

class TajweedToken implements Comparable<TajweedToken> {
  final TajweedRule rule;
  final TajweedSubrule? subrule;
  final int? subruleSubindex;

  final String? matchGroup;
  final String text;

  final int startIx;
  final int endIx;

  const TajweedToken(
    this.rule,
    this.subrule,
    this.subruleSubindex,
    this.text,
    this.startIx,
    this.endIx,
    this.matchGroup,
  );

  /// The part of this token from [from] to [to] (offsets in its text), with
  /// the same rule.
  TajweedToken piece(int from, int to) => TajweedToken(
    rule,
    subrule,
    subruleSubindex,
    text.substring(from, to),
    startIx + from,
    startIx + to,
    matchGroup,
  );

  /// This token [by] characters further on in the aya.
  TajweedToken moved(int by) => by == 0
      ? this
      : TajweedToken(
          rule,
          subrule,
          subruleSubindex,
          text,
          startIx + by,
          endIx + by,
          matchGroup,
        );

  bool isRule() {
    return rule != TajweedRule.none;
  }

  bool isNotRule() {
    return rule == TajweedRule.none;
  }

  ///whether can break into parts after this rule
  ///for displaying in Tajweed view
  // bool get canBreakAfter =>
  //     text.endsWith(' ') &&
  //     text != ' ' &&
  //     (isNotRule() ||
  //         (rule == TajweedRule.iqlab ||
  //             rule == TajweedRule.qalqala ||
  //             (subrule != null &&
  //                 (subrule == TajweedSubrule.byTwo ||
  //                     subrule == TajweedSubrule.lin ||
  //                     subrule == TajweedSubrule.ivad ||
  //                     subrule == TajweedSubrule.muttasil))));
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

  String toCode() {
    //return "TajweedToken(${rule.toString()}, ${subrule != null ? subrule.toString() : 'null'}, ${subruleSubindex != null ? subruleSubindex.toString() : 'null'},'${text.replaceAll("'", "\\'")}', $startIx, $endIx, ${matchGroup != null ? "'${matchGroup!.replaceAll("'", "\\'")}'" : 'null'})";

    //keep matchGroup null for now as it is not used during display
    return "TajweedToken(${rule.toString()}, ${subrule != null ? subrule.toString() : 'null'}, ${subruleSubindex != null ? subruleSubindex.toString() : 'null'},'${text.replaceAll("'", "\\'")}', $startIx, $endIx, null)";
  }
}
