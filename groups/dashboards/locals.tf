locals {
  all_instances_by_cw_namespace = {
    "Tuxedo" : [
      for id in data.aws_instances.tuxedo.ids : data.aws_instance.all[id]
    ]
    "DPS" : [
      for id in data.aws_instances.dps.ids : data.aws_instance.all[id]
    ]
  }
}
