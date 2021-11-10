locals {
    default_vpc_cidr  = tolist([data.terraform_remote_state.vpc.outputs.default_vpc_cidr, ""])
    all_vpc_cidr = compact(concat(data.terraform_remote_state.vpc.outputs.vpc_cidr, local.default_vpc_cidr))
}