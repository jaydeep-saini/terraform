#---- Provider for current region

provider "aws" {
  alias = "this"
  region = "${var.region}"
}

#---- Provider for peer region

provider "aws" {
  alias = "peer"
  region = "${var.peer_region}"
  profile = "${var.profile}"
}



data "aws_caller_identity" "this" {
  provider = "aws.this"
}

data "aws_region" "this" {
  provider = "aws.this"
}

data "aws_caller_identity" "peer" {
  provider = "aws.peer"
}

data "aws_region" "peer" {
  provider = "aws.peer"
}

data "aws_vpc" "this_vpc" {
  provider = "aws.this"
  id       = "${var.this_vpc_id}"
}

data "aws_vpc" "peer_vpc" {
  provider = "aws.peer"
  id       = "${var.peer_vpc_id}"
}

data "aws_route_tables" "this_vpc_rts" {
  provider = "aws.this"
  vpc_id   = "${var.this_vpc_id}"
}

data "aws_route_tables" "peer_vpc_rts" {
  provider = "aws.peer"
  vpc_id   = "${var.peer_vpc_id}"
}

##########################
# VPC peering connection #
##########################
resource "aws_vpc_peering_connection" "this" {
  provider      = "aws.this"
  peer_owner_id = "${data.aws_caller_identity.peer.account_id}"
  peer_vpc_id   = "${var.peer_vpc_id}"
  vpc_id        = "${var.this_vpc_id}"
  peer_region   = "${var.peer_region}"

}

######################################
# VPC peering accepter configuration #
######################################
resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  provider                  = "aws.peer"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.this.id}"
  auto_accept               = "${var.auto_accept_peering}"

}

###################
# This VPC Routes #
###################
resource "aws_route" "this_routes_region" {
  provider                  = "aws.this"
  route_table_id            = "${data.aws_route_tables.this_vpc_rts.ids[count.index]}"
  destination_cidr_block    = "${data.aws_vpc.peer_vpc.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.this.id}"
}

###################
# Peer VPC Routes #
###################
resource "aws_route" "peer_routes_region" {
  provider                  = "aws.peer"
  route_table_id            = "${data.aws_route_tables.peer_vpc_rts.ids[count.index]}"
  destination_cidr_block    = "${data.aws_vpc.this_vpc.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.this.id}"
}
