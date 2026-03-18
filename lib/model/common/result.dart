class Result<T, E> {
  const Result._({
    this.data,
    this.error,
    required this.isOk,
  });

  const Result.ok(T value) : this._(data: value, isOk: true);

  const Result.err(E value) : this._(error: value, isOk: false);

  final T? data;
  final E? error;
  final bool isOk;

  bool get isErr => !isOk;

  R when<R>({
    required R Function(T data) ok,
    required R Function(E error) err,
  }) {
    if (isOk) {
      return ok(data as T);
    }
    return err(error as E);
  }
}
