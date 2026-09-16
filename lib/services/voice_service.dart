abstract class VoiceService {
  Future<String> listenForCommand();
  Future<void> speakText(String text);
}

class MockVoiceService implements VoiceService {
  @override
  Future<String> listenForCommand() async {
    await Future.delayed(const Duration(seconds: 2));
    return "Show nearby pickups";
  }

  @override
  Future<void> speakText(String text) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
