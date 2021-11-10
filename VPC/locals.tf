locals {
    public_cidr  = tolist([var.vpc_public_cidr, ""])
    all_vpc_cidr = compact(concat(var.vpc_private_cidr, local.public_cidr))
}