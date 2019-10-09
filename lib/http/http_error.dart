//not found异常
class NotFoundException implements Exception{
  final String message;

  NotFoundException(this.message);
}

//服务器异常
class ServerErrorException implements Exception{
  final String message;

  ServerErrorException(this.message);
}

//未知异常
class UnKnownException implements Exception{
  final String message;

  UnKnownException(this.message);
}

//token异常
class TokenException implements Exception{
  final String message;

  TokenException(this.message);
}