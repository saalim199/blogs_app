class CategoryCache {
  static List<String> _categories = [];

  static void saveCategories(List<String> categories) {
    _categories = categories;
  }

  static List<String> loadCategories() {
    return _categories;
  }
}
