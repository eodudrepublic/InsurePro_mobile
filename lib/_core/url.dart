class URL {
  static const BASE_URL = 'http://3.38.101.62:8080';

  static const email_url = '$BASE_URL/v1/email';

  static const emailcheck_url = '$BASE_URL/v1/email/check';

  static const team_url = '$BASE_URL/v1/teams';

  static const signup_url = '$BASE_URL/v1/employee/signin';

  static const signin_url = '$BASE_URL/v1/login';

  static const get_employee_url = '$BASE_URL/v1/employee';

  static const get_team_planner = '$BASE_URL/v1/photos/team?employee-pk=';

  static const get_customer_latest = '$BASE_URL/v1/customers/latest';

  static const add_costomer = '$BASE_URL/v1/customer';

  static const my_planner = '$BASE_URL/v1/photos?employee-pk='; // 끝에 사용자 pk 붙여 사용

  static const delete_planner = '$BASE_URL/v1/photos/'; // 끝에 삭제할 이미지 pk 붙여 사용
}