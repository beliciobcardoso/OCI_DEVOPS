resource "oci_core_virtual_network" "VCN" {
  cidr_block     = lookup(var.network_cidrs, "VCN-CIDR")
  compartment_id = var.compartment_id
  display_name   = "VCN ${var.app_name}"
  dns_label      = "VCN${var.app_name}"
}

resource "oci_core_subnet" "public_subnet" {
  cidr_block                 = lookup(var.network_cidrs, "SUBNET-PUBLIC-CIDR")
  compartment_id             = var.compartment_id
  display_name               = "public-subnet"
  dns_label                  = "publicsubnet"
  vcn_id                     = oci_core_virtual_network.VCN.id
  prohibit_public_ip_on_vnic = true
  route_table_id             = oci_core_route_table.public_route_table[0].id
  dhcp_options_id            = oci_core_virtual_network.oke_vcn[0].default_dhcp_options_id
  security_list_ids          = [oci_core_security_list.oke_endpoint_security_list[0].id]

  count        = var.create_new_oke_cluster ? 1 : 0
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_route_table" "public_route_table" {
  compartment_id = local.oke_compartment_id
  vcn_id         = oci_core_virtual_network.oke_vcn[0].id
  display_name   = "oke-public-route-table-${local.app_name_normalized}-${random_string.deploy_id.result}"

  route_rules {
    description       = "Traffic to/from internet"
    destination       = lookup(var.network_cidrs, "ALL-CIDR")
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.oke_internet_gateway[0].id
  }
}

resource "oci_core_internet_gateway" "oke_internet_gateway" {
  compartment_id = local.oke_compartment_id
  display_name   = "oke-internet-gateway-${local.app_name_normalized}-${random_string.deploy_id.result}"
  enabled        = true
  vcn_id         = oci_core_virtual_network.oke_vcn[0].id

  count        = var.create_new_oke_cluster ? 1 : 0
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
