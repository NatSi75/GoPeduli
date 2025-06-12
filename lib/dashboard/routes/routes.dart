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

  static const orders = '/orders';
  static const detailOrder = '/detail-order';

  static const doctors = '/doctors';
  static const createDoctor = '/create-doctor';

  static const authors = '/authors';
  static const createAuthor = '/create-author';
  static const editAuthor = '/edit-author';

  static const users = '/users';

  static const couriers = '/couriers';
  static const createCourier = '/create-courier';

  static List sidebarMenuItems = [
    dashboard,
    articles,
    medicines,
    orders,
    doctors,
    authors,
    users,
    couriers
  ];
}
