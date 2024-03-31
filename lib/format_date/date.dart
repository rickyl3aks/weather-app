import 'package:intl/intl.dart';


var calendar = DateFormat("EEEE, MMMM y", 'en');
var clock = DateFormat("HH:mm", 'en');

var currentDate = DateTime.now();
var date = calendar.format(currentDate);
var time = clock.format(currentDate);


