import 'dart:io';
import 'dart:math';

/// Script to create demo sound files for testing
/// 
/// This creates simple WAV files with different frequencies
/// to simulate different celebration sounds
void main() async {
  print('🎵 Creating demo sound files...');
  
  final soundsDir = Directory('assets/sounds');
  if (!soundsDir.existsSync()) {
    soundsDir.createSync(recursive: true);
  }

  // Sound configurations
  final soundConfigs = {
    'success': {'frequency': 800, 'duration': 0.2, 'description': 'Soft success chime'},
    'achievement': {'frequency': 1000, 'duration': 0.3, 'description': 'Achievement unlocked'},
    'celebration': {'frequency': 1200, 'duration': 0.4, 'description': 'Major celebration'},
    'reward': {'frequency': 600, 'duration': 0.25, 'description': 'Reward earned'},
    'milestone': {'frequency': 900, 'duration': 0.35, 'description': 'Progress milestone'},
    'victory': {'frequency': 1100, 'duration': 0.5, 'description': 'Victory moment'},
  };

  for (final entry in soundConfigs.entries) {
    final soundName = entry.key;
    final config = entry.value;
    final frequency = config['frequency'] as int;
    final duration = config['duration'] as double;
    final description = config['description'] as String;

    print('Creating $soundName.wav - $description');
    
    // Create a simple WAV file with a sine wave
    final wavData = _generateWavData(frequency, duration);
    final file = File('assets/sounds/$soundName.wav');
    await file.writeAsBytes(wavData);
  }

  print('✅ Demo sound files created successfully!');
  print('📁 Location: assets/sounds/');
  print('🎧 These are simple test sounds - replace with professional audio files');
}

/// Generate WAV file data with a sine wave
List<int> _generateWavData(int frequency, double duration) {
  final sampleRate = 44100;
  final samples = (sampleRate * duration).round();
  final bytesPerSample = 2;
  final channels = 1;
  
  final dataSize = samples * bytesPerSample * channels;
  final fileSize = 44 + dataSize;
  
  final wavData = <int>[];
  
  // WAV header
  wavData.addAll('RIFF'.codeUnits);
  wavData.addAll(_intToBytes(fileSize - 8, 4));
  wavData.addAll('WAVE'.codeUnits);
  
  // fmt chunk
  wavData.addAll('fmt '.codeUnits);
  wavData.addAll(_intToBytes(16, 4)); // chunk size
  wavData.addAll(_intToBytes(1, 2));  // audio format (PCM)
  wavData.addAll(_intToBytes(channels, 2));
  wavData.addAll(_intToBytes(sampleRate, 4));
  wavData.addAll(_intToBytes(sampleRate * channels * bytesPerSample, 4)); // byte rate
  wavData.addAll(_intToBytes(channels * bytesPerSample, 2)); // block align
  wavData.addAll(_intToBytes(bytesPerSample * 8, 2)); // bits per sample
  
  // data chunk
  wavData.addAll('data'.codeUnits);
  wavData.addAll(_intToBytes(dataSize, 4));
  
  // Generate sine wave data
  for (int i = 0; i < samples; i++) {
    final time = i / sampleRate;
    final amplitude = 0.3 * sin(2 * pi * frequency * time);
    final sample = (amplitude * 32767).round().clamp(-32768, 32767);
    wavData.addAll(_intToBytes(sample, 2, signed: true));
  }
  
  return wavData;
}

/// Convert integer to little-endian bytes
List<int> _intToBytes(int value, int length, {bool signed = false}) {
  final bytes = <int>[];
  for (int i = 0; i < length; i++) {
    bytes.add((value >> (i * 8)) & 0xFF);
  }
  return bytes;
}
