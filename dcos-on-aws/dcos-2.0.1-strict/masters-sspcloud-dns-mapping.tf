#resource "aws_route53_record" "www" {
 # zone_id = "xxx"
 # name    = "xxx.xxx.fr"
 # type    = "A"

  #alias {
   # name                   = "${module.dcos-infrastructure.lb.masters_dns_name}"
    #zone_id                = "${TODO : find the right terraform output}"
    #evaluate_target_health = true
  #}
#}
resource "aws_route53_record" "www" {
  zone_id = "xxx"
  name    = "xxx.fr"
  type    = "CNAME"
  ttl     = "300"
  records = ["${module.dcos-infrastructure.lb.masters_dns_name}"]
}
