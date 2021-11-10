locals {
    default_vpc_cidr  = tolist([data.terraform_remote_state.vpc.outputs.default_vpc_cidr, ""])
    all_vpc_cidr = compact(concat(data.terraform_remote_state.vpc.outputs.vpc_cidr, local.default_vpc_cidr))
    //all_instance_ip = concat(aws_instance.od_ins.*.private_ip, aws_spot_instance_request.spot_ins.*.private_ip) 
    //all_instance_id = concat(aws_instance.od_ins.*.id, aws_spot_instance_request.spot_ins.*.spot_instance_id)
}