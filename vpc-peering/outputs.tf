#---- VPC peering outputs

locals {
  this_vpc_route_tables = "${data.aws_route_tables.this_vpc_rts.ids}"
  peer_vpc_route_tables = "${data.aws_route_tables.peer_vpc_rts.ids}"
}

output "aws_vpc_peering_connection" {
  value = "${aws_vpc_peering_connection.this.id}"
}

output "aws_vpc_peering_connection_accepter" {
  value = "${aws_vpc_peering_connection_accepter.peer_accepter.id}"
}


output "vpc_peering_id" {
  description = "Peering connection ID"
  value       = "${aws_vpc_peering_connection.this.id}"
}

output "vpc_peering_accept_status" {
  description = "Accept status for the connection"
  value       = "${aws_vpc_peering_connection_accepter.peer_accepter.accept_status}"
}

output "peer_vpc_id" {
  description = "The ID of the accepter VPC"
  value       = "${aws_vpc_peering_connection_accepter.peer_accepter.vpc_id}"
}

output "this_vpc_id" {
  description = "The ID of the requester VPC"
  value       = "${aws_vpc_peering_connection_accepter.peer_accepter.peer_vpc_id}"
}

output "this_owner_id" {
  description = "The AWS account ID of the owner of the requester VPC"
  value       = "${aws_vpc_peering_connection_accepter.peer_accepter.peer_owner_id}"
}

output "peer_owner_id" {
  description = "The AWS account ID of the owner of the accepter VPC"
  value       = "${data.aws_caller_identity.peer.account_id}"
}

output "peer_region" {
  description = "The region of the accepter VPC"
  value       = "${var.peer_region}"
}

