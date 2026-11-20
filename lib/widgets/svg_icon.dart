import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Icon SVG dùng chung. Truyền đường dẫn trong assets/icons/.
/// Có [color] thì icon được tô một màu (lấy từ FigmaColors).
class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.asset, {
    super.key,
    this.size = 24,
    this.color,
    this.fit = BoxFit.contain,
  });

  final String asset;
  final double size;
  final Color? color;

  /// Icon có khung rộng hơn hình (ví dụ 80x52) thì dùng BoxFit.none để giữ
  /// đúng kích thước gốc và cắt phần trong suốt thừa.
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    // Center: icon luôn đúng cỡ [size] và nằm giữa, kể cả khi bị khung cha ép lớn hơn
    // (ví dụ prefixIcon của ô nhập).
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: SvgPicture.asset(
        asset,
        width: size,
        height: size,
        fit: fit,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color!, BlendMode.srcIn),
      ),
    );
  }
}
