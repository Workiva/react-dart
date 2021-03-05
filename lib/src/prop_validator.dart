/// Typedef for `Component2.propTypes` - used to check the validity of one or more of the [props].
///
/// [info] is a [PropValidatorInfo] class that contains metadata about the prop referenced as
/// the key within the `Component2.propTypes` map.
/// `propName`, `componentName`, `location` and `propFullName` are available.
typedef PropValidator<T> = Error Function(T props, PropValidatorInfo info);

/// Metadata about a prop being validated by a [PropValidator].
class PropValidatorInfo {
  final String? propName;
  final String? componentName;
  final String? location;
  final String? propFullName;

  const PropValidatorInfo({
    this.propName,
    this.componentName,
    this.location,
    this.propFullName,
  });
}
