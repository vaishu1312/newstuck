import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:newstuck/clement_activities/home.dart';

void checkTokenValid() async{

  var prefs = await SharedPreferences.getInstance();
  var tokenValid = prefs.getString("tokenValid");
  var validDate = DateTime.parse(tokenValid);
  print("Valid Date is : $validDate");
  if(DateTime.now().toUtc().isAfter(validDate)){
    Get.offAll(Home());
  }
}