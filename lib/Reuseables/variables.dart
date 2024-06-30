String? currenUserId, currentUserName;

extension AssetImageExtension on String {
  String jpgAsset() {
    return "assets/$this.jpg";
  }
}
