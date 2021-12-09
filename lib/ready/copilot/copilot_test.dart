class CopilotTest {
  // 今天周几
  static int getWeekDay() {
    DateTime now = new DateTime.now();
    int weekDay = now.weekday;
    return weekDay;
  }

  // 今天是否是周末
  static bool isWeekend() {
    int weekDay = getWeekDay();
    if (weekDay == 7 || weekDay == 1) {
      return true;
    }
    return false;
  }

  // 润年判断
  static bool isLeapYear(int year) {
    // 判断是否为闰年
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
      return true;
    }
    return false;
  }

  // 今天是否是润年
  static bool isLeapYearToday() {
    int year = getYear();
    return isLeapYear(year);
  }

  // 获取今天的年份
  static int getYear() {
    // 获取今天的年份
    DateTime now = new DateTime.now();
    int year = now.year;
    return year;
  }

  // 获取今天的月份
  static int getMonth() {
    DateTime now = new DateTime.now();
    int month = now.month;
    return month;
  }

  // 今天是否是闰月
  static bool isLeapMonth() {
    int month = getMonth();
    if (month == 2) {
      return isLeapYearToday();
    }
    return false;
  }


  // 打印你好
  static void printHello() {
    print("Hello");
  }

  // 排序
  static void sort(List<int> list) {
    list.sort((a, b) => a - b);
  }

  // 打印数组
  static void printList(List<int> list) {
    for (int i = 0; i < list.length; i++) {
      print(list[i]);
    }
  }
}
