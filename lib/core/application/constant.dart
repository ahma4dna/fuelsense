const String anaoKey =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZlcGJpcndkcmRybGJvdnNjaHNhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY2MTAyNDQsImV4cCI6MjA5MjE4NjI0NH0.3ox1-A-5eq92y0-i5jIlufkyUHibWplE75sbpxM703s";
const String urlSupabase = "https://fepbirwdrdrlbovschsa.supabase.co";

const contentType = "content-type";
const accept = "accept";
const authorization = "authorization";
const apiKey = "apiKey";
const String baseUrl = "https://ejpuomdhzypwzjpvejfb.supabase.co/rest/v1";

///value
const applicationJson = "application/json";

///custom headers
const defaultLanguage = "language";
const clientId = "clientId";

bool isEmoji(String text) {
  final emojiRegex = RegExp(
    r'['
    r'\u{1F600}-\u{1F64F}'
    r'\u{1F300}-\u{1F5FF}'
    r'\u{1F680}-\u{1F6FF}'
    r'\u{1F900}-\u{1F9FF}'
    r'\u{1FA70}-\u{1FAFF}'
    r'\u{2600}-\u{26FF}'
    r'\u{2700}-\u{27BF}'
    r'\u{1F1E6}-\u{1F1FF}'
    r']',
    unicode: true,
  );

  return emojiRegex.hasMatch(text);
}
