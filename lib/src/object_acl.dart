/// Object级别的权限访问控制
enum ObjectACL {
  /// 默认权限
  inherited,

  /// 公共读写
  publicReadWrite,

  /// 公共读，私有写
  publicRead,

  /// 私有读写
  private,
}

extension ObjectACLExtension on ObjectACL {
  /// 作为请求参数的值
  String get parameter {
    switch (this) {
      case ObjectACL.publicReadWrite:
        return 'public-read-write';
      case ObjectACL.publicRead:
        return 'public-read';
      case ObjectACL.private:
        return 'private';
      case ObjectACL.inherited:
        return 'default';
      default:
        return '';
    }
  }
}
