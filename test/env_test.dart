// Test file for .env file

// Imports 
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Load .env file
Future init() async {
  await dotenv.load(fileName: ".env");
}

// Test
void main() {

  test("import variables", () async {
    await init();
    expect(dotenv.env['API_KEY'], '65614265142654');
  });

}