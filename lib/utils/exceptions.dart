class UnauthorizedException implements Exception {
  final String message;
  
  UnauthorizedException([this.message = 'Sesi telah berakhir, silakan login kembali']);
  
  @override
  String toString() => message;
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  ApiException(this.message, [this.statusCode]);
  
  @override
  String toString() => message;
}
