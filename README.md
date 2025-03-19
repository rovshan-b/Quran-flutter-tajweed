# Quran Tajweed rules highlighter

بسم الله الرحمن الرحيم
_In the name of Allah, Most Gracious, Most Merciful_

This is an example project that shows how to implement Quran Tajweed rules in flutter.  
You can extract highlighting logic from it and use in your projects.
Following rules are implemented:

- Ghunna
- Ikhfaa - Noon sakin and tanweens
- Ikhfaa - Meem sakin
- Idgham with ghunna - Noon sakin and tanweens
- Idgham with ghunna - Meem sakin
- Idgham without ghunna - Noon sakin and tanweens
- Idgham without ghunna - Shamsiyya
- Idgham without ghunna - Misleyn
- Idgham without ghunna - Mutajaniseyn
- Idgham without ghunna - Mutagaribeyn
- Iqlab - Noon sakin and tanweens
- Izhar - Noon sakin and tanweens
- Qalqala
- Prolonging - by 2, 4, 6
- Prolonging - Lin
- Prolonging - Ivad
- Prolonging - Muttasil
- Prolonging - Munfasil
- Prolonging - Lazim
- Alef tafreeq
- Hamzatul wasl

## Getting Started

Main class that does tokenization is called `Tajweed`.  
You call it like this: `Tajweed.tokenize(String AyaText, int sura, int aya)` and it returns `List<TajweedToken>` that
you can later pass to `RichText` widget for displaying:

```dart
Text.rich(
    TextSpan(
        children: <TextSpan>[
        for (final token in tokens)
            TextSpan(
            text: token.text,
            style: TextStyle(
                fontFamily: 'Kitab',
                fontWeight: FontWeight.w400,
                fontSize: 30,
                color: token.rule.color(context) ??
                    Theme.of(context).colorScheme.onSurface,
            ),
            ),
        TextSpan(
            text: '\u06DD${(index + 1).toArabicDigits()}',
            style: TextStyle(
            fontFamily: 'Kitab',
            fontWeight: FontWeight.w400,
            fontSize: 30,
            color: Theme.of(context).colorScheme.onSurface,
            ),
        )
        ],
    ),
)
```

`TajweedToken` contains properties to indicate what rule and subrule were matched, so that you can for example display documentation of rule.

If you need to get tokens grouped by words (for example for highlighting in UI etc) you can call
`Tajweed.tokenizeAsWords(String AyaText, int sura, int aya)` method and it will return `List<TajweedWord>` where every
`TajweedWord` is one word that contains `TajweedToken`s inside it.

For performance use some cache variable in application and do not re-tokenize on every `build` method call.

## Using pre-cached tokens

Project also contains a file called `cached_tajweed_tokens.dart` that contains a class called `CachedTajweedTokens` with a static field `suraTokens`. That field is a **zero-indexed** list of pre-cached tokens for all Suras and all Ayas. That file is quite large in size, but if you decide to use it, below is how.

```dart
//To retrieve tokens for last (7th) Aya of Sura Al Fatiha
final ayaTokens = CachedTajweedTokens.suraTokens[0][6]; //0 - Al Fatiha, 6 - Aya number 7

//To retrieve tokens word-by-word in List<TajweedWord>
final ayaTokens = CachedTajweedTokens.suraTokens[0][6];
final wordByWordTokens = Tajweed.tokensToWords(ayaTokens); //this operation is fast
```

![screenshot](/screenshot.png?raw=true "Screenshot")

![screenshot](/screenshot_dark.png?raw=true "Screenshot (Dark theme)")
