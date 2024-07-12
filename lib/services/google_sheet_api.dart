import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "contadorentradadespertar",
  "private_key_id": "765b2719c82d9ca2fd7ddf41b1e8841af473b43f",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCicl5A67bItyJ3\nXRpa72Sk9hQ3NhLQKdaJhdriAxJzmYylXTgbW99wnx98cI+Ta988yHBfaWmcWp8y\nFsvKm5GMQBUtBZ//XfRUx78r/hg3No9bKimEBCWdlsEMUQWJLutvG+vgx9mjspk/\nZOlxuFerbRC3bKzSVSJK/az0ZC9S7lxNGOy5nPHM9ZzLTfOwAFrHRxh5TytA4Yk/\nDZhtHcEz6v59yX5kxSod5lSkwPrz3ukChCTWcb/tDON44KWbLCT41VtIh1m3SHUm\nlJ57AoKUiD0+g5zu9PYmiInxgGQlUXdPLlpxo7vLiA1TPhuAWNa07ARwda69h5lp\n+rDtHiL3AgMBAAECggEABw4ii9KboKyw1tr4pGRrTELSbpzERRLcGiLxy7PIdF7X\nM0NmMWypuqbJOPVb4aeODYIYZ1HDtXe2HE3N0gyJo2a7xLXO1MohgiEewMFgud0p\nGBOFCWfIs8cdYUnk4f1jWkhYfphkxRhM/D+HaASn7MO9ix8xg6e7ko2L78f+H4Lg\nSsAE67B0QXqHKdlDGTMmowV4FPEeR+BEATf2X1D2KumbUzzNrHvmysSP2LjPNbNp\nsaHfYD8TTRV6rU+20fBEZIunNfl3cTD2VapJNhhyPagd7fuKlP7UnuxlOsmrhS03\neuokgCaXgeHVQWtNyvS7oYSM1+zN49psYdaFQJB0gQKBgQDXMldHdWGbaJlX+Jr9\nQ6lfDUd+LuHe4EUEGRgo2p1X7EGogCtYY2TaQpSTBqN1IFLnq+BnQNjCPjLZyFJe\n8oos2PpDaSegggiLfyR4EAL9r59MnnFjlCQu1V0UJVrTS43zsPHDn+1u4MlCAg7f\nJjxcubQHPBPICMQDe7xDdgQltwKBgQDBP4tC5ekjEnlpZRVkWUAA1nCl+do52abf\nvArCLB6aR1obbHFOZIdSOZMtdeIMZB1nNOvIL8ZNNLPdXjH8R4Ty3WLGa49TCWHk\nj5upi+rFyrSDEa7wbMQ4saTs+1gsq8SYJIV+TI/tPOPeAISKPzOohJI6BX7J5WS8\nypOIcI/swQKBgQCoWlrLrbohwbANkZF3R6LOmO3weq78FQoJTbSH6ZekvFEViMfg\nS0oQMnxXlZ71N8eENQPG44VwWQahOEWwwCB3O3x2lmKJAJG8yEf4odYlL2r5nw7o\nL3IrLYK3Cw5GNVqlZi2NtKUk1Di/KisGSrx4clO0QTzchncKnpfHUyGlewKBgEgm\nxoMavjn3Cte8AwmtfQUTC4ocyEqzJegBGG8489AcddspWQCw7glYL8hYbCa+NnAz\nRRlAJSTsWX98TONpfI0E9X0p6aBSL3eb2r2p3OUucslBD/T6VyTnxrEogtpi44r+\nj80BHvevtVBNFy9au5nerY32QUl2WW9Xn0/g3wvBAoGBAI7/9IbGk750HQ1Jskej\nsEAVN6ueHs6oNFvanxcTlbNoBvzRTUV1FZRFsWfzCCylixoAViD/9QX48WJJ0j6W\nDqNKBNWd6BCF7wcktxo9eIN8yex9PFl/JTeIVTJw0vXcgaq/DbGpZFooXj1D9ONV\nJNmVn8WMIWiORD1cTqzP/bUf\n-----END PRIVATE KEY-----\n",
  "client_email": "contadorentradadespertar@contadorentradadespertar.iam.gserviceaccount.com",
  "client_id": "100064017679839884926",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/contadorentradadespertar%40contadorentradadespertar.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
 ''';

  static final _spreadsheetId = '16AVjYjNXlL8v7yfFHtCB217dxISMoPzh4eQcOQsJdpQ';
  static final gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  Future init() async {
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('EntradaTeste');
  }

  static Future insert(String title, String quantity, String date) async {
    if (_worksheet == null) return;
    await _worksheet!.values.appendRow([title, quantity, date]);
  }
}
