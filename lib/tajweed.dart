import 'tajweed_rule.dart';
import 'tajweed_subrule.dart';
import 'tajweed_token.dart';
import 'tajweed_word.dart';

class Tajweed {
  static const LAFZATULLAH =
      r'(?<LAFZATULLAH>(\u0627|\u0671)?\u0644\p{M}*\u0644\u0651\p{M}*\u0647\p{M}*(' +
      smallHighLetters +
      r'?\u0020|$))';

  // Pause marks ۖ ۗ ۘ ۙ ۚ ۛ (U+06D6 to U+06DB).
  static const pauseMarks = r'[\u06D6-\u06DB]';

  static const smallHighLetters = r'(' + pauseMarks + r'|\u06E2|\u06ED)';
  static const optionalSmallHighLetters = '$smallHighLetters?';
  static const smallHighLettersBetweenWords = smallHighLetters + r'?\u0020*';

  // The pause marks where the text is coloured as read stopping: must stop ۘ
  // and stopping preferred ۗ. The reader stops there and starts the next word
  // afresh, so each stretch between them is coloured as an aya of its own
  // (tokenize): what the aya's end and start have, they have. Everywhere else
  // the text is coloured as read joining, as the mark advises: either ۚ,
  // joining preferred ۖ, do not stop ۙ, the paired ۛ. One reading per word:
  // stopping and joining are never both heard (a tanween is said only when
  // joining, a stopping qalqala only comes with the stop's sukun).
  static const stopMarks = r'[\u06D8\u06D7]';
  static final _readingBreak = RegExp('(?<=$stopMarks)\u0020');
  static const fathaKasraDammaWithoutTanvin = r'(\u064F|\u064E|\u0650)';

  static const fathaKasraDammaWithTanvin =
      r'(\u064B|\u064C|\u064D|\u08F0|\u08F1|\u08F2)';

  static const fathaKasraDammaWithOrWithoutTanvin =
      r'(' +
      fathaKasraDammaWithoutTanvin +
      r'|' +
      fathaKasraDammaWithTanvin +
      r')';

  static const shadda = r'\u0651';

  // A tanween on a hamza written over a tatweel comes after the hamza mark
  // (شَیۡـࣰٔا: tatweel, U+0654, tanween): the noon rules skip it.
  static const hamzaAboveBeforeTanween = r'\u0654?';

  static const fathaKasraDammaWithTanvinWithOptionalShadda =
      r'(\u0651?' + fathaKasraDammaWithTanvin + r'\u0651?)';

  // Alif (also with the silent mark: ٱمۡرُؤٌا۟), Ya or Vav
  static const nonReadingCharactersAtEndOfWord =
      r'(\u0627\u06DF?|\u0648|\u0649|\u06E5)?';

  static const higherOrLowerMeem = r'(\u06E2|\u06ED)';

  static const sukoonWithoutGrouping = r'\u0652|\u06E1|\u06DF';
  static const sukoon = '($sukoonWithoutGrouping)';
  static const optionalSukoon = r'(\u0652|\u06E1)?';
  static const noonWithOptionalSukoon = r'(\u0646' + optionalSukoon + r')';

  static const meemWithOptionalSukoon = r'(\u0645' + optionalSukoon + r')';

  // The bare hamza (U+0621) is a throat letter too (2:49), and so is a hamza
  // written on a tatweel (وَیَنۡـَٔوۡنَ, 6:26).
  static const throatLettersWithoutExtensionAlef =
      r'(\u062D|\u062E|\u0639|\u063A|\u0627\p{M}*\p{L}|\u0621|\u0623|\u0625|\u0647|\u0640\p{M}*\u0654)';

  /*
  Ghunna - Nasalistaion

  The quality of ghunna is present in the letters م  and ن.
  So whenever we pronounce these letters the sound will go into the nose which is known as ghunna.

  Whenever the letter م  or ن has a shadda we pronounce the letter with a strong ghunna.
  This means we will hold the sound in our nose for 2 counts.
  */
  // Not on the aya's first letter, also after the rub el hizb sign ۞ (۞ مَّثَلُ,
  // 13:35): its shadda comes from joining the aya before (مَّا, 2:105), and
  // the reader starts afresh.
  static const ghunna =
      r'(?<!^(\u06DE\u0020)?)(?<ghunna>(\u0645|\u0646)\u0651\p{M}*)';

  /*
  8-ci dərs
  ƏL-İXFƏ
  “İxfə” sözünün lüğəti mənası gizlətmək deməkdir.
  “Nun-i sakin” və ya “tənvin”lərdən sonra aşağıda sadalanan on
  beş hərfdən biri gələrsə, bu zaman “Nun-i sakin” və ya “tənvin”-
  lərdə olan “n” səsi “xayşum”dan (burun boşluğundan) çıxacaqdır.
  İxfə hərfləri bunlardır:

  ظ|ف|ق|ك|ت|ث|ج|د|ذ|ز|س|ش|ص|ض|ط
  */

  static const ikhfaaLetters =
      r'(\u0638|\u0641|\u0642|\u0643|\u062A|\u062B|\u062C|\u062F|\u0630|\u0632|\u0633|\u0634|\u0635|\u0636|\u0637)\p{M}*';

  static const ikhfaa_noonSakinAndTanweens =
      r'((?<ikhfaa_noonSakinAndTanweens>' +
      noonWithOptionalSukoon +
      r'|(\p{L}' +
      hamzaAboveBeforeTanween +
      fathaKasraDammaWithTanvinWithOptionalShadda +
      r'))' +
      nonReadingCharactersAtEndOfWord +
      smallHighLettersBetweenWords +
      ikhfaaLetters +
      r')';

  /*
  10-cu dərs
  İXFƏ-UL MİM ƏS SƏKİNƏH
  Əgər sükunlu mimdən sonra “bə” hərfi gələrsə, mim hərfi “bə”
  hərfinin içərisində gizlənəcəkdir. Bu zaman səs “xayşun”dan
  (burun boşluğundan) çıxmalıdır.

  تَرۡمِیهِم بِحِجَارَةࣲ مِّن سِجِّیلࣲ
  */
  static const ikhfaa_meemSakin =
      r'(?<ikhfaa_meemSakin>' +
      meemWithOptionalSukoon +
      smallHighLettersBetweenWords +
      r'\u0628\p{M}*)';

  static const ikhfaa = '$ikhfaa_noonSakinAndTanweens|$ikhfaa_meemSakin';

  /*
  4-cü dərs
  ƏL-İDĞAM
  İdğam sözünün lüğəti mənası bir şeyi digər bir şeyə daxil
  etmək deməkdir.
  “Nun-i sakin” və ya “tənvin”lərdən sonra bu altı hərf gələrsə,
  (ye) (ra) (mim) (lem) (vav) (nun)
  bu zaman birinci hərf oxunmayacaq, ikinci hərf isə şəddələnə-
  cəkdir.
  Bu hərflər “yərməlun” 8 en sözündə cəmləşmişdir.
  Əl-idğam iki qismə bölünür.
  1. Əl-İdğam mə”al-ğunnə
  2. Əl-İdğam bilə ğunnə

  5-ci ders.
  ƏL-İDĞAM MƏ”AL-ĞUNNƏ
  “Nun-i sakin” və ya “tənvin”lərdən sonra bu dörd hərf gələrsə
  ي|م|ن|و
  bu zaman “nun-i sakin” və ya “tənvin”lər bu hərflərə daxil olur
  və səs burundan çıxır:
  فَمَن یَعۡمَلۡ
   خَیۡرࣰا یَرَهُۥ

  Qur”ani-Kərimdə dörd söz vardır ki, bunlarda “idğam” baş verməz.
  */
  static const idghamWithGhunna_noonSakinAndTanweens =
      r'(?<idghamWithGhunna_noonSakinAndTanweens>(' +
      noonWithOptionalSukoon +
      r'|(\p{L}' +
      hamzaAboveBeforeTanween +
      fathaKasraDammaWithTanvinWithOptionalShadda +
      nonReadingCharactersAtEndOfWord +
      r'))' +
      smallHighLettersBetweenWords +
      r'(\u064A|\u06CC|\u0645|\u0646|\u0648)\p{M}*)';

  /*
  9-cu ders.

  MİM SAKİNİN HÖKMLƏRİ
  “Mim sakin”in üç hökmü mövcuddur.
  1. İdğam-ul mim əs səkinəh
  2. İxfə-ul mim əs səkinəh
  3. İzhar-ul mim əs səkinəh

  İDĞAM-UL MİM ƏS SƏKİNƏH
  Əgər sözün sonunda sükunlu “mim” gələrsə və bundan sonra
  gələn sözün əvvəli də “mim”lə başlayarsa, bu zaman “mim” hərfi
  idğam olunur, yəni birinci “mim” oxunmur, ikinci “mim” isə
  şəddələnir. Bu qaydaya “İdğam misleyin” də deyilir:

   أَطۡعَمَهُم مِّن
  */
  static const idghamWithGhunna_meemSakin =
      r'(?<idghamWithGhunna_meemSakin>(' +
      meemWithOptionalSukoon +
      smallHighLettersBetweenWords +
      r'\u0645\p{M}*\u0651\p{M}*))';

  static const idghamWithGhunna =
      '$idghamWithGhunna_noonSakinAndTanweens|$idghamWithGhunna_meemSakin';

  /*
  6-ci ders.
  ƏL-İDĞAM BİLƏ ĞUNNƏ
  “Nun-i sakin” və ya “tənvin”lərdən sonra bu iki hərf gələrsə,
  ل , ر bu zaman “nun-i sakin” və ya “tənvin”lər bu hərflərə
  daxil olar və səs ağız boşluğundan çıxar:

  وَیۡلࣱ لِّكُلِّ هُمَزَةࣲ لُّمَزَةٍ
  */
  static const idghamWithoutGhunna_noonSakinAndTanweens =
      r'((?<idghamWithoutGhunna_noonSakinAndTanweens>((\u0646(\u0652|\u06E1)?)|\p{L}' +
      hamzaAboveBeforeTanween +
      fathaKasraDammaWithTanvinWithOptionalShadda +
      nonReadingCharactersAtEndOfWord +
      r'))' +
      smallHighLettersBetweenWords +
      r'(\u0644|\u0631)\p{M}*)';

  /*
  15-с1 dərs.
  IDGAM ŞƏMSİYYƏ
  EL artiklndan sonra bu on dörd hərf gələrsə (...),
  bu zaman idğam şəmsiyyə baş verər, yəni EL artiklında olan Lem
  hərfi oxunmaz, bu hərflərdən biri isə şəddələnər.
  */
  static const idghamWithoutGhunna_shamsiyya =
      r'((\u0627|\u0671)(?<idghamWithoutGhunna_shamsiyya>\u0644)\p{L}\u0651\p{M}*)';

  // After the preposition li- the article's alif is not written
  // (لِلطَّاۤىِٕفِینَ). A rule of its own: one pattern cannot name a group twice.
  static const idghamWithoutGhunna_shamsiyyaAfterLi =
      r'((?<=\u0644\u0650)(?<idghamWithoutGhunna_shamsiyya>\u0644)\p{L}\u0651\p{M}*)';

  /*
  12-ci dərs
  İDĞAM MİSLEYİN
  Misleyin sözünün lüğəti mənası iki eyni və ya mislində olan bir
  şey deməkdir. İstilahi mənası isə iki eyni və həmcins olan hərflərin
  bir-biri ilə qarşılaşması zamanı yaranan idğam növüdür:

  فَمَا رَبِحَت تِّجَـٰرَتُهُمۡ
  */
  static const idghamWithoutGhunna_misleyn =
      r'(?<idghamWithoutGhunna_misleyn>(?:(?!\u0645)(\p{L})))\u0020*\2\u0651'; //exclude (meem) as it has its own rule.

  /*
    13-cü dərs
  İDGĞAM MUTƏCƏNİSEYN
  Formaca müxtəlif, lakin məxrəc etibarilə eyni olan hərflərin
  bir-birinə rast gəlməsi zamanı yaranan idğam növünə idğam
  mutəcəniseyn deyilir. Yəni məxrəcləri bir, sifətləri isə ayrı-ayrı
  olan iki hərf yan-yana gələrsə, bu zaman birinci hərf oxunmaya-
  caq, ikinci hərf isə şəddələnəcəkdir.
  Bu hərflər üç qismdə cəmləşmişdir:
  1. (ta) (del) (te): عَبَدتّمْ, قدْ تَّبَيَّنّ
  2. (za) (zel) (se)
  3. (mim) (be)
  */
  static const idghamWithoutGhunna_mutajaniseyn_1 =
      r'(?<idghamWithoutGhunna_mutajaniseyn_1>[\u0637\u062F\u062A]' +
      optionalSukoon +
      optionalSmallHighLetters +
      r')\u0020*(?!\1)([\u0637\u062F\u062A]' +
      shadda +
      r')';
  static const idghamWithoutGhunna_mutajaniseyn_2 =
      r'(?<idghamWithoutGhunna_mutajaniseyn_2>[\u0638\u0630\u062B]' +
      optionalSukoon +
      optionalSmallHighLetters +
      r')\u0020*(?!\1)([\u0638\u0630\u062B]' +
      shadda +
      r')';
  static const idghamWithoutGhunna_mutajaniseyn_3 =
      r'(?<idghamWithoutGhunna_mutajaniseyn_3>[\u0628\u0645]' +
      optionalSukoon +
      optionalSmallHighLetters +
      r')\u0020*(?!\1)([\u0628\u0645]' +
      shadda +
      r')';

  /*
  14-cü dərs
  -
  İDĞAM MTƏQARİBEYN
  Formaca müxtəlif, lakin məxrəc etibarilə yaxın olan hərflərin
  bir-birinə rast gəlməsi zamanı yaranan idğam növünə idğam
  mutəqaribeyn deyilir. Yəni məxrəcləri və sifətləri yaxın olan iki
  hərf bir-birinə rast gələrsə, birinci hərf oxunmayacaq, ikinci hərf
  isə şəddələnəcəkdir.
  Bu hərflər iki qrupda cəmləşmişdir:
  1. (qaf) (ke)
  2. (nun) (lem) (ra)
   */

  static const idghamWithoutGhunna_mutagaribeyn_1 =
      r'(?<idghamWithoutGhunna_mutagaribeyn_1>[\u0642\u0643]' +
      optionalSukoon +
      optionalSmallHighLetters +
      r')\u0020*(?!\1)([\u0642\u0643]' +
      shadda +
      r')';
  static const idghamWithoutGhunna_mutagaribeyn_2 =
      r'(?<idghamWithoutGhunna_mutagaribeyn_2>[\u0646\u0644\u0631]' +
      optionalSukoon +
      optionalSmallHighLetters +
      r')\u0020*(?!\1)([\u0646\u0644\u0631]' +
      shadda +
      r')';

  //other sub-rules have backreferences so putting as separate entries
  //below in array
  static const idghamWithoutGhunna =
      '$idghamWithoutGhunna_noonSakinAndTanweens|$idghamWithoutGhunna_shamsiyya';

  /*
  7-ci dərs
  ƏL-İQLƏB
  “İqləb” sözünün lüğəti mənası çevirmək deməkdir. Həmçinin, bu
  sözü bir haldan digər bir hala çevirmək kimi də başa düşmək olar.
  “Nun-i sakin” və ya “tənvin”lərdən sonra “bə” hərfi
  gələrsə, bu zaman “Nun-i sakin” və ya “tənvin”lər “mim” hərfi
  kimi tələffüz olunacaqdır. Bəzi Qur”an çaplarında “İqləb”
  qaydasını bildirmək üçün “Nun-i sakin” və ya “tənvin”lərin
  üzərində kiçik “mim” işarəsi qoyulur.
  */
  // static const iqlab_noonSakinAndTanweens_1 =
  //     r'((((?<iqlab_noonSakinAndTanweens_1>(\u0646(\u0652|\u06E1)?' +
  //         higherOrLowerMeem +
  //         r')|(\p{L}' +
  //         fathaKasraDammaWithOrWithoutTanvin +
  //         higherOrLowerMeem +
  //         r'))' +
  //         nonReadingCharactersAtEndOfWord +
  //         r'))' +
  //         smallHighLettersBetweenWords +
  //         r'\u0020*\u06D8?\u0628\p{M}*)';

  // //(Bə) hərfi növbəti ayənin əvvəlində olarsa
  // static const iqlab_noonSakinAndTanweens_2 =
  //     r'((((?<iqlab_noonSakinAndTanweens_2>(\u0646(\u0652|\u06E1)?' +
  //         higherOrLowerMeem +
  //         r')|(\p{L}' +
  //         fathaKasraDammaWithoutTanvin +
  //         higherOrLowerMeem +
  //         r'))' +
  //         nonReadingCharactersAtEndOfWord +
  //         r'$)))';

  // static const iqlab_noonSakinAndTanweens =
  //     '$iqlab_noonSakinAndTanweens_1|$iqlab_noonSakinAndTanweens_2';
  // Not at the aya end: the reader stops there and says no tanween (أَحَدٌۢ,
  // 112:4, keeps its qalqala), also before a silent alif (تَكۡبِیرَۢا).
  static const iqlab_noonSakinAndTanweens =
      r'(?<iqlab_noonSakinAndTanweens>\p{L}\p{M}*(\u06E2|\u06ED))'
      r'(?!\p{M}*\u0627?\p{M}*(\u0020\u06E9)?$)';

  /*
    3-cu ders
    ƏL-İZHAR
  İzhar sözünün lüğəti mənası bəyan etmək deməkdir. İstilahi
  mənada isə “nun-i sakin”i və ya “tənvin”i açıq şəkildə və
  “ğunnə”siz (burundan çıxan səs) oxumağa deyilir.
  “Nun-i sakin” və ya “tənvin”lərdən sonra bu altı hərf gələrsə (hah) (xa) (ayn) (ğayn) (elif) (heh),
  bu zaman “nun-i sakin” və “tənvin”lər aydın şəkildə tələffüz olu-
  nur. Bu hərflərə, həmçinin, boğaz hərfləri də deyilir.
  */
  // As the other noon rules: a shadda may come before the tanween (غَنِیٌّ),
  // the silent alif or ya written after it and a pause mark may stand before
  // the next word (رَغَدًا حَیۡثُ, قَرِیبٌۖ أُجِیبُ). A meem or noon with a
  // shadda keeps its ghunna (مُّسَمًّى عِندَهُۥ).
  static const izhar_noonSakinAndTanweens =
      r'((?<izhar_noonSakinAndTanweens>' +
      noonWithOptionalSukoon +
      r'|((?![\u0645\u0646]\p{M}?\u0651)\p{L}' +
      hamzaAboveBeforeTanween +
      fathaKasraDammaWithTanvinWithOptionalShadda +
      r'))' +
      nonReadingCharactersAtEndOfWord +
      smallHighLettersBetweenWords +
      throatLettersWithoutExtensionAlef +
      r')';

  /*
  11-ci dərs
  İZHAR-UL MİM ƏS SƏKİNƏH
  Sükunlu mim yerdə qalan 26 hərfə rast gələrsə, açıq-aydın bir
  şəkildə oxunacaqdır.
  */
  //static const izhar_meemSakin = r'(?<izhar_meemSakin>\u0645(\u0652|\u06E1))';

  /*
  16-cı dərs
  IZHAR QAMARİYYƏ
  EL artiklından sonra bu on dörd hərf gələrsə, (...)
  bu zaman izhar qamariyyə baş verər.
  Qamariyyə sözünün mənası aylı gecədə ulduzların aydın görünməsi
  misalındadır. Yəni, Lem hərfi açıq-aydın şəkildə oxunacaqdır.
  */
  // static const izhar_gamariyya =
  //     r'(\u0627|\u0671)(?<izhar_gamariyya>\u0644' + sukoon + r')';

  /*
  17-ci dərs
  QALQALƏ
  Qalqalə sözünün mənası əks-səda deməkdir.
  Qalqalə hərfləri beşdir: (del) (cim) (be) (ta) (qaf)
  Bu hərflər “Qutbucəd” sözündə cəmləşmişdir. Qalqalə iki qismə
  bölünür.
  1. Böyük qalqalə.
  2. Kiçik qalqalə.

  Əgər bu beş hərfdən biri sükunlu olaraq sözün sonunda gələrsə, bu zaman böyük qalqalə baş verər.
  Əgər bu beş hərfdən biri sükunlu olaraq gələrsə, bu zaman kiçik qalqalə baş verər.
  */
  static const qalqala =
      r'(?<qalqala>((\u0642|\u0637|\u0628|\u062C|\u062F)\u0651?(\u0652|\u06E1|(' +
      fathaKasraDammaWithOrWithoutTanvin +
      r'?' +
      // an iqlab meem and a stop mark may both follow (ۢ ۗ)
      smallHighLetters +
      r'{0,2}' +
      // the aya end (also before the sajda sign, never colouring it: وَٱقۡتَرِب ۩)
      // or a stop mark, which ends its stretch (tokenize)
      r')(?=(\u0020\u06E9)?$))))';

  /*
  19-cu dərs
  MƏDD (UZATMA)
  MƏDD HƏRFLƏRİ
  Mədd sözünün lüğəti mənası uzatmaq deməkdir. Yəni hərfin
  saitinin uzadılmasıdır. Ərəb dilində üç mədd hərfi уагди: (ye) (vav) (elif)
  1. Əgər əlif sakin olarsa (üzərində heç bir hərəkə olmazsa) və
  özündən əvvəl gələn hərfin hərəkəsi fəthə (ə) olarsa, bu zaman
  fəthə iki hərəkə miqdarında uzadılacaqdır.
  2. Əgər vav sakin olarsa (üzərində heç bir hərəkə olmazsa) və
  özündən əvvəl gələn hərfin hərəkəsi damma (u) olarsa, bu zaman
  damma iki hərəkə miqdarında uzadılacaqdır.
  3, Əgər yə sakin olarsa (üzərində heç bir hərəkə olmazsa) və
  özündən əvvəl gələn hərfin hərəkəsi kəsrə olarsa, bu zaman
  kəsrə iki hərəkə miqdarında uzadılacaqdır.


  23-cü dərs
  MƏDD-UL-ARİD LİS-SUKUN
  Mədd-ul-arid mədd hərfindən sonra gələn hərfin üzərində da-
  yanmaqdır. Uzatma miqdarı isə iki, dörd və ya altı hərəkədir.
  */
  static const followingExtensionByTwo =
      '$smallHighLetters?'
      r'((?!(\p{M}|\u0020\u0671)))';
  //Aleef
  static const prolonging_byTwo_1_1 =
      r'(\u064E(?<prolonging_byTwo_1_1>\u0627)' +
      followingExtensionByTwo +
      r')';
  // A waw, or a ya with a letter after its dagger alif (never the final ىٰ of
  // عَلَىٰ, which is the long vowel itself), followed by a dagger alif. Not the
  // ya after the imala mark U+065C (مَجۡر۪ىٰهَا, 11:41, read with imala).
  static const daggerAlifSeat =
      r'(\u0648(?=\u0670)|(?<!\u065C)[\u0649\u064A\u06CC](?=\u0670\p{M}*\p{L}))';

  //Tatweel + Aleef
  //Not on a waw, or a ya inside a word, carrying the dagger alif: that letter
  //is only its seat (a silent letter) and the dagger alif alone is read.
  static const prolonging_byTwo_1_2 =
      r'(\u064E(?<prolonging_byTwo_1_2>(?!' +
      daggerAlifSeat +
      r')\p{L}\u0670)' +
      followingExtensionByTwo +
      r')';

  //The dagger alif on such a seat (ٱلصَّلَوٰةَ, وَلَّىٰهُمۡ).
  static const prolonging_byTwo_1_4 =
      r'(\u064E' +
      daggerAlifSeat +
      r'(?<prolonging_byTwo_1_4>\u0670)' +
      followingExtensionByTwo +
      r')';

  //Alef with word joiners
  static const prolonging_byTwo_1_3 =
      r'(\u064E(?<prolonging_byTwo_1_3>\u200A?\u0670\u2060?)' +
      followingExtensionByTwo +
      r')';

  //Vav
  static const prolonging_byTwo_2 =
      r'(\u064F(?<prolonging_byTwo_2>(\u0648|\u06E5))' +
      followingExtensionByTwo +
      r')';

  //Ye
  static const prolonging_byTwo_3_1 =
      r'(\u0650(?<prolonging_byTwo_3_1>(\u064A|\u06CC|\u06E6|\u06E7))' +
      followingExtensionByTwo +
      r')';
  //Tatweel + small high Ye. Surat Al Baqara 61. (ٱلنَّبِیِّـۧنَ)
  static const prolonging_byTwo_3_2 =
      r'((?<prolonging_byTwo_3_2>\u0640\u06E7)' +
      followingExtensionByTwo +
      r')';
  static const prolonging_byTwo_3 =
      '$prolonging_byTwo_3_1|$prolonging_byTwo_3_2';

  /*
  24-cü dərs
  MƏDD-UL-LİN
  Lin sözünün lüğəti mənası uzatmaq və ya dartmaq deməkdir.
  İstilahi mənada isə sözün sonuncu hərfindən əvvəl (vav) yaxud (ye)
  hərflərinin sükunlu gəlməsinə deyilir. Bu mədd növündə şərtdir
  ki, sükunlu (vav) yaxud (ye) hərflərindən əvvəl gələn hərfin hərəkəsi
  fəthə olsun. Uzatma miqdarı iki, dörd və ya altı hərəkədir.
  Bu mədd növü sözün sonunda dayandığımız zaman istifadə olunmalıdır.
  */
  static const prolonging_lin =
      r'(\u064E(?<prolonging_lin>(\u0648|\u06E5\u064A|\u06CC)' +
      optionalSukoon +
      r')\p{L}\p{M}*' +
      smallHighLetters +
      r'?$)';

  /*
  25-ci dərs
  MƏDD-UL-İVAD
  İvad sözünün lüğəti mənası əvəz etmək deməkdir. Bu mədd
  növü sözün sonunda olan yalnız tənvin fəthənin (ən) vəqf
  (dayanmaq) zamanı fəthə (ə) ilə əvəz olunmasına deyilir. Uzatma
  miqdarı iki hərəkədir.
  */
  //putting small high letters together withing same group as ending Alef.
  //because currently flutter does not support coloring diacritics separately.
  // Only where the reader stops: the aya end or a stop mark, which ends its
  // stretch (tokenize). Joined to the next word the alif is not read (رَغَدًا
  // حَیۡثُ).
  static const prolonging_ivad =
      r'((\u064B|\u08F0|\u0654\u06E2|\u064E\u06E2)(?<prolonging_ivad>\u0627' +
      stopMarks +
      r'?(?=(\u0020\u06E9)?$)))';

  static const extensionByTwo =
      '$prolonging_byTwo_1_1|$prolonging_byTwo_1_2|$prolonging_byTwo_1_3|$prolonging_byTwo_1_4|$prolonging_byTwo_2|$prolonging_byTwo_3|$prolonging_lin|$prolonging_ivad';

  /*
  20-ci dərs
  MƏDD-UL-MUTTASIL
  Muttasıl sözünün lüğəti mənası bitşən deməkdir. Əgər mədd
  hərfindən sonra həmzə ء gələrsə və bu həmzə eyni sözdə olarsa,
  bu zaman mədd-ul-muttasıl əş verər.
  */
  // U+08F3, the small high waw, once: لِیَسُـࣳۤـُٔوا۟ (17:7).
  // A seat under the dagger alif is not part of the madd (ٱلرِّبَوٰۤا۟).
  static const maddLetters =
      r'(((?!' +
      daggerAlifSeat +
      r')\p{L})?\u200A?\u0670|\u0627|\u0622|\u0648|\u06E5|\u064A|\u06CC|\u06E6|\u06E7|\u08F3)';
  static const hamza = r'\u0621';
  static const hamzaVariations =
      r'(\u0621|\u0623|\u0624|\u0625|\u0626|\u0649\u0655|\u0648\u0654|\u0627\u0654|\u0654|\u0655)';

  // A madd letter carrying the hamza mark itself is only its seat
  // (ٱللُّؤۡلُوِٕ). The joiners around a dagger alif come in either order
  // (بُرَءَ ٰۤ ؤُا۟, 60:4).
  static const prolonging_muttasil =
      r'((?<prolonging_muttasil>' +
      maddLetters +
      r'(?![\u0654\u0655])\u2060?\u06E4?\u2060?)'
          r'\u200A?\u0640?'
          '$hamzaVariations[^$sukoonWithoutGrouping]' //burada sukun gelerse uzatma olur ya yox. mes: Beqere 72
          r')';

  /*
  21-ci dərs
  MƏDD-UL-MUNFASIL
  Munfasıl sözünün lüğəti mənası iki şeyin biri-birindən ayrı ol-
  ması deməkdir. Əgər mədd hərfindən sonra gələn həmzə ء ayrı-
  ayrı kəlmələrdə olarsa, bu zaman mədd-ul-munfasıl baş verər.
  Mədd-ul-munfasılın uzadılması caizdir, yəni iki, dörd, beş hərəkə uzadıla bilər.
  */
  // Never the silent alif written after fathatan (هُودًا أَوۡ): nothing is
  // lengthened there. The plural's silent alif may carry a pause mark before
  // the next word (تَعۡتَدُوۤا۟ۚ إِنَّ).
  static const prolonging_munfasil_1 =
      r'((?<![\u064B\u08F0])(?<prolonging_munfasil_1>' +
      maddLetters +
      r'\u06E4?' +
      smallHighLetters +
      r'?)(\u0627' +
      sukoon +
      smallHighLetters +
      r'?)?\u0020' +
      hamzaVariations +
      r')';

  //A madd letter with the madda sign at the aya end (the next aya starts with a
  //hamza) or at a stop mark: the reader stops, so it is a natural madd (also
  //after the plural's silent alif: ضَلُّوۤا۟, 20:92).
  static const prolonging_byTwo_5 =
      r'((?<prolonging_byTwo_5>' +
      maddLetters +
      r'\u06E4)(\u0627' +
      sukoon +
      r')?' +
      stopMarks +
      r'?$)';

  static const prolonging_munfasil =
      '$prolonging_munfasil_1|$prolonging_byTwo_5';

  /*
  22-ci dərs
  MƏDD-UL-LƏZİM
  Adından göründüyü kimi, bu, elə bir mədd növüdür ki, uzadıl-
  ması lazımdır. Mədd hərfindən sonra məddə səbəb olan amillər-
  dən biri, yəni sükun gələrsə, bu zaman mədd-ul-ləzim baş verər.
  Mədd-ul-ləzimin uzadılması vacibdir və bu, altı hərəkədir.

  Mədd-ul-ləzim dörd qismə bölünür:
  1. Mədd-ul-ləzim kəlimi musaqqal (şəddəli kəlmə) (uzatma herfinden sonra shedde gelerse)
  2. Mədd-ul-ləzim kəlimi muxaffəf (sükunlu kəlmə). Bu mədd növü Qur”ani-Kərimdə yalnız Yunus surəsinin 51 və 91-ci ayələrində keçir.
  3. Mədd-ul-ləzim hərfi musaqqal (şəddəli hərf). Bu mədd növü Qur”ani-Kərimdə bəzi surələrin başlığında olan müəyyən hərflərdir.
     Yəni uzadılan hərfin sonu özündən sonrakı hərfin başlığı ilə eyni olur: الۤمۤ
  4. Mədd-ul-ləzim hərfi muxaffəf (sükunlu hərf). Bu mədd növü Qur”ani-Kərimdə bəzi surələrin başlığında olan müəyyən hərflərdir.
  */
  static const prolonging_lazim_1 =
      r'((?<prolonging_lazim_1>' +
      maddLetters +
      r'\u06E4?)\p{L}' +
      shadda +
      r')';

  // The madd of difference: before an article with a sukun (ءَاۤلۡـَٔـٰنَ) or
  // one merged into the next letter (ءَاۤلذَّكَرَیۡنِ, ءَاۤللَّهُ).
  static const prolonging_lazim_2 =
      r'(\u0621\u064E(?<prolonging_lazim_2>\u0627\u06E4)\u0644(\u06E1|\u0652|\p{L}\u0651))';

  //apply to Muqatta letters only. Include sub rules 3 and 4
  static const prolonging_lazim_3 = r'(?<prolonging_lazim_3>\p{L}\u06E4)';

  static const extensionBySix = '$prolonging_lazim_1|$prolonging_lazim_2';

  // The alif after a plural waw (alif tafriq: ءَامَنُوا۟), a silent letter with
  // its sukun and a pause mark it carries.
  static const silentAlifAfterWaw =
      r'(((\u0648|\u06E5)\p{M}*)(?<silentLetter>\u0627' +
      sukoon +
      smallHighLetters +
      r'?))';

  // Not where the reading starts: an aya's (or a stretch's, tokenize) first
  // letter, also after the hizb quarter sign (37:22 ۞ ٱحۡشُرُوا۟), is said.
  static const hamzatulWasli =
      r'((?<!^|^\u06DE\u0020)(?<hamzatulWasli>\u0671))';

  // Letters written but not read: marked with the small round zero
  // (أُو۟لَـٰۤىِٕكَ; the alif after a plural waw is matched by silentAlifAfterWaw too,
  // with its pause mark), or the seat of a dagger alif. Lowest priority: it only
  // fills letters no other rule colours.
  static const silentLetter =
      r'(?<silentLetter>\p{L}\u06DF|' + daggerAlifSeat + r')';

  static const allRules = [
    LAFZATULLAH,
    izhar_noonSakinAndTanweens,
    ikhfaa,
    idghamWithGhunna,
    iqlab_noonSakinAndTanweens,
    qalqala,
    ghunna,
    idghamWithoutGhunna,
    idghamWithoutGhunna_shamsiyyaAfterLi,
    idghamWithoutGhunna_misleyn,
    idghamWithoutGhunna_mutajaniseyn_1,
    idghamWithoutGhunna_mutajaniseyn_2,
    idghamWithoutGhunna_mutajaniseyn_3,
    idghamWithoutGhunna_mutagaribeyn_1,
    idghamWithoutGhunna_mutagaribeyn_2,
    //izhar_meemSakin,
    //izhar_gamariyya,
    prolonging_muttasil,
    prolonging_munfasil,
    extensionBySix,
    extensionByTwo,
    silentAlifAfterWaw,
    hamzatulWasli,
    silentLetter,
  ];

  static List<TajweedWord> tokenizeAsWords(String AyaText, int sura, int aya) {
    return tokensToWords(tokenize(AyaText, sura, aya));
  }

  static final _rules = [for (final r in allRules) RegExp(r, unicode: true)];
  static final _muqattaRule = RegExp(prolonging_lazim_3, unicode: true);

  static List<TajweedToken> tokenize(String AyaText, int sura, int aya) {
    List<TajweedToken> results = [];
    // Each stretch between stop marks is read, so coloured, as an aya of its
    // own: no rule joins it to the next, its end is read stopping and the next
    // starts afresh (stopMarks). The space after the mark belongs to neither.
    var from = 0;
    for (final end in [
      ..._readingBreak.allMatches(AyaText).map((m) => m.start),
      AyaText.length,
    ]) {
      final stretch = AyaText.substring(from, end);
      for (final regexp in _rules) {
        for (final t in tokenizeByRule(regexp, stretch)) {
          results.add(t.moved(from));
        }
      }
      from = end + 1;
    }

    final muqattaEnd = isMuqattaAya(sura, aya);
    if (muqattaEnd > -1) {
      results.addAll(
        tokenizeByRule(
          _muqattaRule,
          muqattaEnd == 0 ? AyaText : AyaText.substring(0, muqattaEnd),
        ),
      );
    }

    applyIzharMutlaq(AyaText, sura, aya, results);

    if (results.isEmpty) return [plainAya(AyaText)];

    // Tokens starting at the same letter are ordered by the priority that
    // settles their overlap below, so which one is kept does not depend on how
    // the sort happens to order equal elements (it is not stable).
    results.sort(_byStartThenPriority);

    bool hasDeletions = true;
    while (hasDeletions) {
      hasDeletions = false;
      for (int i = results.length - 1; i > 0; --i) {
        final item = results[i];
        final prevItem = results[i - 1];

        bool overlapping = prevItem.endIx > item.startIx;
        if (overlapping) {
          var priorityCurr = item.rule.priority;
          var priorityPrev = prevItem.rule.priority;
          if (item.rule == prevItem.rule &&
              item.subrule != null &&
              prevItem.subrule != null) {
            priorityCurr = item.subrule!.priority;
            priorityPrev = prevItem.subrule!.priority;
          }
          if (priorityCurr < priorityPrev) {
            results.removeAt(i - 1);
          } else {
            results.removeAt(i);
          }
          hasDeletions = true;
        }
      }
    }

    results = withoutPauseMarks(results);
    if (results.isEmpty) return [plainAya(AyaText)];

    List<TajweedToken> nonTajweed = [];
    final first = results.first;
    if (first.startIx > 0) {
      nonTajweed.add(
        TajweedToken(
          TajweedRule.none,
          null,
          null,
          AyaText.substring(0, first.startIx),
          0,
          first.startIx,
          null,
        ),
      );
    }
    for (int i = 0; i < results.length - 1; ++i) {
      final item = results[i];
      final next = results[i + 1];
      if (next.startIx - item.endIx > 0) {
        nonTajweed.add(
          TajweedToken(
            TajweedRule.none,
            null,
            null,
            AyaText.substring(item.endIx, next.startIx),
            item.endIx,
            next.startIx,
            null,
          ),
        );
      }
    }
    final last = results.last;
    if (last.endIx < AyaText.length) {
      nonTajweed.add(
        TajweedToken(
          TajweedRule.none,
          null,
          null,
          AyaText.substring(last.endIx, AyaText.length),
          last.endIx,
          AyaText.length,
          null,
        ),
      );
    }

    if (nonTajweed.isNotEmpty) {
      results.addAll(nonTajweed);
      results.sort();
    }

    return results;
  }

  static TajweedToken plainAya(String AyaText) => TajweedToken(
    TajweedRule.none,
    null,
    null,
    AyaText,
    0,
    AyaText.length,
    null,
  );

  static int _byStartThenPriority(TajweedToken a, TajweedToken b) {
    var c = a.startIx.compareTo(b.startIx);
    if (c != 0) return c;
    c = a.rule.priority.compareTo(b.rule.priority);
    if (c != 0 || a.rule != b.rule) return c;
    c = (a.subrule?.priority ?? 100).compareTo(b.subrule?.priority ?? 100);
    if (c != 0) return c;
    c = (a.subrule?.index ?? -1).compareTo(b.subrule?.index ?? -1);
    if (c != 0) return c;
    c = (a.subruleSubindex ?? 0).compareTo(b.subruleSubindex ?? 0);
    if (c != 0) return c;
    return b.endIx.compareTo(a.endIx);
  }

  static List<TajweedWord> tokensToWords(List<TajweedToken> tokens) {
    final space = RegExp('\u0020', unicode: true);
    //re-tokenize at word boundaries
    final list = <TajweedToken>[];
    for (final token in tokens) {
      final parts = token.text.split(space);
      var atIx = token.startIx;
      for (int i = 0; i < parts.length; ++i) {
        var part = parts[i];
        final from = atIx - token.startIx;
        list.add(token.piece(from, from + part.length));
        if (i < parts.length - 1) {
          list.add(
            TajweedToken(
              TajweedRule.none,
              null,
              null,
              ' ',
              atIx + part.length,
              atIx + part.length + 1,
              null,
            ),
          );
          atIx += part.length + 1;
        } else {
          atIx += part.length;
        }
      }
    }

    final results = <TajweedWord>[];
    var word = TajweedWord();
    for (final token in list) {
      if (token.text == '\u0020') {
        results.add(word);
        word = TajweedWord();
        continue;
      } else {
        word.tokens.add(token);
      }
    }
    if (word.tokens.isNotEmpty) {
      results.add(word);
    }

    return results;
  }

  static List<TajweedToken> tokenizeByRule(RegExp regexp, String Aya) {
    final results = <TajweedToken>[];

    var matches = regexp.allMatches(Aya).toList(growable: false);

    for (int i = 0; i < matches.length; ++i) {
      final m = matches[i];
      String part;

      final groupNames = m.groupNames.toList(growable: false);
      for (int k = 0; k < groupNames.length; ++k) {
        final groupName = groupNames[k];
        final groupValue = m.namedGroup(groupName);
        if (groupValue == null) {
          continue;
        }

        var matchStart = m.start;
        var matchEnd = m.start + groupValue.length;

        //these rules match either in the middle or at the end.
        //and dart regexp does not provide group start and end indexes
        if (groupName == "ikhfaa_meemSakin" ||
            groupName == "izhar_gamariyya" ||
            groupName == "idghamWithoutGhunna_shamsiyya" ||
            groupName == "prolonging_byTwo_1_1" ||
            groupName == "prolonging_byTwo_1_2" ||
            groupName == "prolonging_byTwo_1_3" ||
            groupName == "prolonging_byTwo_1_4" ||
            groupName == "prolonging_byTwo_2" ||
            groupName == "prolonging_byTwo_3_1" ||
            groupName == "prolonging_lin" ||
            groupName == "prolonging_ivad" ||
            groupName == "prolonging_lazim_2" ||
            groupName == "silentLetter" ||
            groupName == "hamzatulWasli") {
          final matchText = Aya.substring(m.start, m.end);
          final lastPartIx = matchText.indexOf(groupValue);
          matchStart = m.start + lastPartIx;
          matchEnd = matchStart + groupValue.length;
        }

        part = Aya.substring(matchStart, matchEnd);

        final groupNameParts = groupName.split('_');
        final rule = groupNameParts[0];
        final subrule = groupNameParts.length > 1 ? groupNameParts[1] : null;
        final subruleSubindex = groupNameParts.length > 2
            ? int.parse(groupNameParts[2])
            : null;
        results.add(
          TajweedToken(
            TajweedRule.values.byName(rule),
            subrule != null ? TajweedSubrule.values.byName(subrule) : null,
            subruleSubindex,
            part,
            matchStart,
            matchEnd,
            groupName,
          ),
        );

        break; //no need to enumate other groups, as only one has value.
      }
    }

    return results;
  }

  static void applyIzharMutlaq(
    String AyaText,
    int sura,
    int aya,
    List<TajweedToken> tokens,
  ) {
    // A noon sakin before ya or waw inside one word is read clearly (izhar
    // mutlaq): دُنۡیَا, بُنۡیَـٰن, قِنۡوَان, صِنۡوَان. The idgham the general rule
    // found after [from] becomes an izhar on the noon and its sukun, the span
    // every other noon izhar has.
    void izharInsteadOfIdgham(int from) {
      // The tokens are still in the order the rules found them (one idgham
      // rule, position order), so the first after [from] is the word's noon.
      final idgham = tokens
          .where(
            (t) => t.rule == TajweedRule.idghamWithGhunna && t.startIx > from,
          )
          .firstOrNull;
      final noon = idgham == null
          ? null
          : RegExp(r'^\u0646[\u0652\u06E1]?').stringMatch(idgham.text);
      if (idgham == null || noon == null) return;
      tokens.remove(idgham);
      tokens.add(
        TajweedToken(
          TajweedRule.izhar,
          TajweedSubrule.noonSakinAndTanweens,
          null,
          noon,
          idgham.startIx,
          idgham.startIx + noon.length,
          'izhar_noonSakinAndTanweens',
        ),
      );
    }

    final dunya = RegExp(
      r'\u062F\u0651?\u064F\u0646\u06E1\u06CC\u064E\u0627',
      unicode: true,
    );
    var dunyaIndex = AyaText.indexOf(dunya);
    while (dunyaIndex != -1) {
      izharInsteadOfIdgham(dunyaIndex);
      dunyaIndex = AyaText.indexOf(dunya, dunyaIndex + 1);
    }

    //Al-Anam 6
    if (sura == 6 && aya == 99) {
      final ginvan = RegExp(
        r'\u0642\u0650\u0646(\u0652|\u06E1)\u0648\u064E\u0627',
        unicode: true,
      );
      final ginvanIndex = AyaText.indexOf(ginvan);
      if (ginvanIndex != -1) {
        izharInsteadOfIdgham(ginvanIndex);
      }
    }

    //Ar-Rad 4
    if (sura == 13 && aya == 4) {
      final sinvan = RegExp(
        r'\u0635\u0650\u0646\u06e1\u0648\u064e\u0627\u0646',
        unicode: true,
      );

      var sinvanIndex = AyaText.indexOf(sinvan);
      if (sinvanIndex != -1) {
        izharInsteadOfIdgham(sinvanIndex);
      }

      //2 times
      sinvanIndex = AyaText.indexOf(sinvan, sinvanIndex + 5);
      if (sinvanIndex != -1) {
        izharInsteadOfIdgham(sinvanIndex);
      }
    }

    //Tauba 109
    //Tauba 110
    //An-Nahl 26
    //Al-Kahf 21
    //As-Saaffaat 97
    //As-Saff 4
    if ((sura == 9 && (aya == 109 || aya == 110)) ||
        (sura == 16 && aya == 26) ||
        (sura == 18 && aya == 21) ||
        (sura == 37 && aya == 97) ||
        (sura == 61 && aya == 4)) {
      final bunyan = RegExp(
        r'\u0628\u064F\u0646\u06E1\u06CC\u064E\u0640\u0670',
        unicode: true,
      );
      var bunyanIndex = AyaText.indexOf(bunyan);
      while (bunyanIndex != -1) {
        izharInsteadOfIdgham(bunyanIndex);
        bunyanIndex = AyaText.indexOf(bunyan, bunyanIndex + 5);
      }
    }
  }

  static final _pauseMark = RegExp(pauseMarks);

  /// Pause marks (ۖ ۗ ۚ ۛ ۘ ۙ) are signs for the reader, not part of any rule:
  /// they are drawn in the text colour, as in the printed mushafs. A rule token
  /// holding one is cut around it (the gap is filled with plain text later); a
  /// piece left with only a space is dropped too.
  static List<TajweedToken> withoutPauseMarks(List<TajweedToken> tokens) {
    final out = <TajweedToken>[];
    void piece(TajweedToken t, int from, int to) {
      if (t.text.substring(from, to).trim().isEmpty) return;
      out.add(t.piece(from, to));
    }

    for (final t in tokens) {
      var from = 0;
      for (final m in _pauseMark.allMatches(t.text)) {
        piece(t, from, m.start);
        from = m.end;
      }
      if (from == 0) {
        out.add(t);
      } else {
        piece(t, from, t.text.length);
      }
    }
    return out;
  }

  ///returns positions until which Muqatta continues, or 0 if continues until end. -1 if not Muqatta aya.
  static int isMuqattaAya(int sura, int aya) {
    // Ash-Shura has two: حم (42:1) and عسق (42:2).
    if (sura == 42 && aya == 2) {
      return 0;
    }
    if (aya != 1) {
      return -1;
    }
    switch (sura) {
      case 2:
      case 3:
      case 7:
      case 19:
      case 20:
      case 26:
      case 28:
      case 29:
      case 30:
      case 31:
      case 32:
      case 36:
      case 40:
      case 41:
      case 42:
      case 43:
      case 44:
      case 45:
      case 46:
        return 0;
      case 10:
      case 11:
      case 12:
        return 6;
      case 13:
        return 8;
      case 14:
      case 15:
        return 6;
      case 27:
        return 5;
      case 38:
      case 50:
      case 68:
        return 4;
      default:
        return -1;
    }
  }
}
