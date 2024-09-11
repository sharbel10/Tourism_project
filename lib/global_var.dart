class GlobalState {
  static final GlobalState _instance = GlobalState._internal();

  factory GlobalState() {
    return _instance;
  }

  GlobalState._internal();

  String currentPackageType = '';  // Default value

// Add any other global state or methods as needed
}
