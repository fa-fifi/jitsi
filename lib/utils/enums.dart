enum Server {
  public(url: 'https://meet.jit.si', isTokenNeeded: false),
  private(url: 'https://8x8.vc', isTokenNeeded: true);

  final String url;
  final bool isTokenNeeded;

  const Server({required this.url, required this.isTokenNeeded});
}
