class GoPeduliRoutes {
  static const login = '/login';
  static const logout = '/login';
  static const dashboard = '/dashboard';

  static const articles = '/articles';
  static const createArticle = '/create-articles';
  static const editArticle = '/edit-articles';

  static const medicines = '/medicines';
  static const createMedicine = '/create-medicines';
  static const editMedicine = '/edit-medicines';

  static List sidebarMenuItems = [
    dashboard,
    articles,
    medicines,
  ];
}
