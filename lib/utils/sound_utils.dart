import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';

// https://stackoverflow.com/questions/75740528/how-to-convert-audio-file-to-mp3-in-flutter

Future<bool> convertAudio({
  required String inputAudioPath,
  required String outputAudioPath,
}) async {
  // -y is to overwrite an output file if it already exists.
  final session = await FFmpegKit.execute(
    '-y -i $inputAudioPath $outputAudioPath',
  );
  final returnCode = await session.getReturnCode();
  return ReturnCode.isSuccess(returnCode);
}

