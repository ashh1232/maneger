import 'package:maneger/class/statusrequest.dart';

StatusRequest handlingData(respo) {
  if (respo is StatusRequest) {
    return respo;
  } else {
    return StatusRequest.success;
  }
}
