class GoPeduliRoutes {
  static const login = '/login';
  static const logout = '/login';
  static const dashboard = '/dashboard';

  static const articles = '/articles';
  static const createArticle = '/create-article';
  static const editArticle = '/edit-article';

  static const medicines = '/medicines';
  static const createMedicine = '/create-medicine';
  static const editMedicine = '/edit-medicine';

  static List sidebarMenuItems = [
    dashboard,
    articles,
    medicines,
  ];
}
