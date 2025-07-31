import 'package:logger/logger.dart';

abstract class LoggerService {
  void i(dynamic message);
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]);
  void d(dynamic message);
  void w(dynamic message);
}

class LoggerServiceImpl implements LoggerService {
  late final Logger _logger;

  LoggerServiceImpl() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 1,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
    );
  }

  @override
  void i(dynamic message) {
    _logger.i(message);
  }

  @override
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  @override
  void d(dynamic message) {
    _logger.d(message);
  }

  @override
  void w(dynamic message) {
    _logger.w(message);
  }
}
