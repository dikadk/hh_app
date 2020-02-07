class Article {
  final String text;
  final String domain;
  final String by;
  final String age;
  final int score;
  final int commentCount;

  const Article(
      {this.text,
      this.domain,
      this.by,
      this.age,
      this.score,
      this.commentCount});
}

final articles = [
  new Article(
      text: "Example of an animated",
      domain:
          "www.theverge.com/2020/2/6/21127243/tesla-model-s-autopilot-disabled-remotely-used-car-update",
      by: "kjah",
      age: "123",
      score: 785,
      commentCount: 12),
  Article(
      text: "Uses a Canvas",
      domain:
          "blogs.nasa.gov/commercialcrew/2020/02/07/nasa-shares-initial-findings-from-boeing-starliner-orbital-flight-test-investigation/",
      by: "kjah",
      age: "123",
      score: 145,
      commentCount: 5),
  Article(
      text: "Shows how and dark themes.",
      domain: "jahsdkjasjkdhaksj",
      by: "kjah",
      age: "123",
      score: 12,
      commentCount: 0),
  Article(
      text: "Shows",
      domain: "jahsdkjasjkdhaksj",
      by: "kjah",
      age: "123",
      score: 12,
      commentCount: 100),
];
