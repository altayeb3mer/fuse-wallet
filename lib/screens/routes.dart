import 'package:auto_route/auto_route_annotations.dart';
import 'package:local_champions/screens/buy/business.dart';
import 'package:local_champions/screens/buy/map.dart';
import 'package:local_champions/screens/cash_home/cash_mode.dart';
import 'package:local_champions/screens/cash_home/prize.dart';
import 'package:local_champions/screens/cash_home/transaction_details.dart';
import 'package:local_champions/screens/signup/recovery.dart';
import 'package:local_champions/screens/signup/username.dart';
import 'package:local_champions/screens/signup/signup.dart';
import 'package:local_champions/screens/signup/verify.dart';
import 'package:local_champions/screens/splash/splash.dart';
import 'package:local_champions/screens/misc/pincode.dart';

@MaterialAutoRouter()
class $Router {
  SplashScreen splashScreen;
  SignupScreen signupScreen;
  VerifyScreen verifyScreen;
  UserNameScreen userNameScreen;
  PincodeScreen pincodeScreen;
  @initial
  CashModeScaffold cashHomeScreen;
  TransactionDetailsScreen transactionDetailsScreen;
  BusinessPage businessPage;
  RecoveryPage recoveryPage;
  MapScreen mapScreen;
  PrizeScreen prizeScreen;
}
