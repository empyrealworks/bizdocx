class SmartField {
  final String key;
  final String value;

  SmartField({required this.key, required this.value});
}

class SmartFieldUtility {
  static final RegExp _regex = RegExp(
    r'<span[^>]*data-smart-field="([^"]+)"[^>]*>(.*?)</span>',
    caseSensitive: false,
    dotAll: true,
  );

  /// Parses the HTML and returns a list of [SmartField]s.
  static List<SmartField> parse(String html) {
    final matches = _regex.allMatches(html);
    final fields = <SmartField>[];
    final seenKeys = <String>{};

    for (final match in matches) {
      final key = match.group(1)!;
      final value = match.group(2)!;
      
      if (!seenKeys.contains(key)) {
        fields.add(SmartField(key: key, value: value));
        seenKeys.add(key);
      }
    }
    return fields;
  }

  /// Updates the HTML by replacing the values of the specified [fields].
  static String update(String html, Map<String, String> updates) {
    var result = html;
    
    // We iterate over the updates to replace values in the HTML
    updates.forEach((key, newValue) {
      final keyRegex = RegExp(
        r'(<span[^>]*data-smart-field="' + key + r'"[^>]*>)(.*?)(</span>)',
        caseSensitive: false,
        dotAll: true,
      );
      
      result = result.replaceAllMapped(keyRegex, (match) {
        return '${match.group(1)}$newValue${match.group(3)}';
      });
    });

    return result;
  }

  /// Injects the signature HTML into the placeholder.
  static String injectSignature(String html, String signatureHtml) {
    final keyRegex = RegExp(
      r'(<span[^>]*data-smart-field="signature"[^>]*>)(.*?)(</span>)',
      caseSensitive: false,
      dotAll: true,
    );
    
    return html.replaceFirstMapped(keyRegex, (match) {
      return signatureHtml;
    });
  }
}
