enum TajweedSubrule {
  noonSakinAndTanweens,
  meemSakin,
  // The letter-pair idghams give way to the more specific shamsiyya and
  // noon-sakin labels when both match the same letter (same colour either way).
  misleyn(101),
  mutajaniseyn(101),
  mutagaribeyn(101),
  shamsiyya,
  gamariyya,

  //prolonging
  byTwo,
  muttasil(1),
  munfasil(2),
  lazim,
  lin,
  ivad;

  const TajweedSubrule([this.priority = 100]);

  final int priority;
}
