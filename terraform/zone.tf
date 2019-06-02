resource "aws_route53_zone" "cloud-kyiro-net" {
  name = "cloud.kyiro.net"
}

resource "aws_route53_record" "cloud-kyiro-net-ns" {
  zone_id = "${aws_route53_zone.cloud-kyiro-net.zone_id}"
  name    = "cloud.kyiro.net"
  type    = "NS"
  ttl     = "1800"

  records = [
    "${aws_route53_zone.cloud-kyiro-net.name_servers.0}",
    "${aws_route53_zone.cloud-kyiro-net.name_servers.1}",
    "${aws_route53_zone.cloud-kyiro-net.name_servers.2}",
    "${aws_route53_zone.cloud-kyiro-net.name_servers.3}",
  ]
}
