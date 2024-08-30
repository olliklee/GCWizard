
enum TEXTMAGIC_OPTION {
  LINESTART, WORDSTART, SENTENCESTART, PUNCTUATIONMARK,
  CHARACTER, UPPER_CHAR, DIGIT, NUMBER, TAG }

RegExp _createRegEx(TEXTMAGIC_OPTION option, {int charCount = 1, String htmlTag = 'em', String specialChar = 'a'}) {
  late String pattern;
  switch (option) {
    case TEXTMAGIC_OPTION.LINESTART:
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
      pattern = '$specialChar{$charCount}';
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
      break;
  }

  return RegExp(pattern, multiLine: (option == TEXTMAGIC_OPTION.LINESTART));
}

void main() {
  int anzZeichen = 1;
  String text = 'Dies ist ein BeispielText <em>MIT</em> Großbuchstaben. Und <em> tags</em>';
  TEXTMAGIC_OPTION option = TEXTMAGIC_OPTION.CHARACTER;

  var regExp = _createRegEx(option, htmlTag: 'em');
  Iterable<RegExpMatch> matches = regExp.allMatches(text);

  StringBuffer founds = StringBuffer();
  for (final match in matches) {
    founds.write(match.group(0));
  }
  print(founds.toString());
}