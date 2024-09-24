import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tajweed/tajweed_token.dart';
import 'arabic_number_converter.dart';

import 'tajweed.dart';

class TokenizedAya {
  List<TajweedToken> tokens = [];

  TokenizedAya(this.tokens);
}

class TajweedViewer extends StatefulWidget {
  const TajweedViewer({super.key});

  @override
  State<TajweedViewer> createState() => _TajweedViewerState();
}

class _TajweedViewerState extends State<TajweedViewer> {
  final Ayas = 286;
  final loadOnly = 20;

  Future<List<TokenizedAya>> loadAyas() async {
    final content = await rootBundle
        .loadString('assets/metadata/Quran/quran-uthmani-kitab.txt');
    //load sura Al-Bagara
    final splitter = LineSplitter.split(content).skip(7);
    final result = <TokenizedAya>[];

    int loaded = 0;

    for (final line in splitter) {
      result.add(TokenizedAya(Tajweed.tokenize(line, 2, loaded + 1)));
      if (++loaded >= loadOnly) {
        //load first 20 Ayas only
        break;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final loader = loadAyas();
    return FutureBuilder(
      future: loader,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const Text('Loading...');
        }
        if (snapshot.data == null) {
          return const Text('No data');
        }
        return Container(
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.builder(
                itemCount: loadOnly,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          for (final token in snapshot.data![index].tokens)
                            TextSpan(
                              text: token.text,
                              style: TextStyle(
                                fontFamily: 'Kitab',
                                fontWeight: FontWeight.w400,
                                fontSize: 30,
                                height: 1.9,
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
                              height: 1.9,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
