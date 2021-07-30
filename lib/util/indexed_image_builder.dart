import 'package:flutter/widgets.dart';

/// Works exactly like [IndexedWidgetBuilder], it only returns an [Image]
/// instead of a [Widget].
typedef IndexedImageBuilder = Image Function(BuildContext context, int index);
