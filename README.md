# بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ

# Quran Tajweed rules highlighter

This is an example project that shows how to implement Quran Tajweed rules in flutter.  
You can extract highlighting logic from it and use in your projects.
At the moment some highlighting rules are not implemented, but most are.  

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

For performance reasons I recommend saving tokenization results to some XML file or database and later loading and displaying instead of tokenizing every time. Or at least use some cache variable in application and do not re-tokenize on every `build` method call.

![screenshot](/screenshot.png?raw=true "Screenshot")