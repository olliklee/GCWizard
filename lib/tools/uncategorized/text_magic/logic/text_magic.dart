
enum TEXTMAGIC_OPTION {
  LINESTART, WORDSTART, SENTENCESTART, PUNCTUATIONMARK,
  CHARACTER, UPPER_CHAR, DIGIT, NUMBER, TAG }

class RegExpGroup {
  final RegExp regExp;
  final int group;

  RegExpGroup(this.regExp, this.group);
}

RegExpGroup _createRegExpGroup(TEXTMAGIC_OPTION option, {int charCount = 1, String? htmlTag = 'em', String? specialChar = 'a'}) {
  late String pattern;
  int group = 0;

  switch (option) {
    case TEXTMAGIC_OPTION.LINESTART: // check
      pattern = '^.{$charCount}';
      break;
    case TEXTMAGIC_OPTION.WORDSTART:
      pattern = '\\b\\w{$charCount}';
      break;
    case TEXTMAGIC_OPTION.SENTENCESTART:
      pattern = '(^|(?<=[.!?]\\s))\\w{$charCount}';
      break;
    case TEXTMAGIC_OPTION.PUNCTUATIONMARK:
      pattern = '(^|(?<=[.!?,;-_"\'/()]\\s))\\w{$charCount}';
      break;
    case TEXTMAGIC_OPTION.CHARACTER:
      pattern = '$specialChar{$charCount}(?=(.{$charCount}))';
      group = 1;
      break;
    case TEXTMAGIC_OPTION.UPPER_CHAR:
      pattern = '[A-Z]';
      break;
    case TEXTMAGIC_OPTION.DIGIT:
      pattern = '[0-9]';
      break;
    case TEXTMAGIC_OPTION.NUMBER:
      pattern = r'\d' + '{$charCount}';
      break;
    case TEXTMAGIC_OPTION.TAG:
      pattern = '<$htmlTag>([^<]+)</$htmlTag>';
      group = 1;
      break;
  }

  return RegExpGroup(RegExp(pattern, multiLine: (option == TEXTMAGIC_OPTION.LINESTART)), group);
}

void main() {
  String text = 'Dies ist ein BeispielText <em>MIT</em> Großbuchstaben. Und 2 <em> tags</em>. Insgesamt 231!';
  print(text);
  Map<TEXTMAGIC_OPTION, List<dynamic>> parameters = {
    TEXTMAGIC_OPTION.LINESTART: [2, '', ''],
    TEXTMAGIC_OPTION.WORDSTART: [2, '', ''],
    TEXTMAGIC_OPTION.SENTENCESTART: [3, '', ''],
    TEXTMAGIC_OPTION.PUNCTUATIONMARK: [1, '', ''],
    TEXTMAGIC_OPTION.CHARACTER: [1, '', 'e'],
    TEXTMAGIC_OPTION.UPPER_CHAR: [1, '', ''],
    TEXTMAGIC_OPTION.DIGIT: [1, '', ''],
    TEXTMAGIC_OPTION.NUMBER: [1, '', ''],
    TEXTMAGIC_OPTION.TAG: [1 , 'strong', ''],
  };

  for (var mode in parameters.keys) {
    var regExpGroup = _createRegExpGroup(
        mode,
        charCount: parameters[mode]?[0] as int,
        htmlTag: parameters[mode]?[1] as String?,
        specialChar: parameters[mode]?[2] as String?
    );
    Iterable<RegExpMatch> matches = regExpGroup.regExp.allMatches(text);

    StringBuffer founds = StringBuffer();
    for (final match in matches) {
      founds.write(match.group(regExpGroup.group));
    }

    print('Mode: $mode + Prams: ${parameters[mode].toString()}' );
    print('Found: ${founds.toString()}\n');
  }
}