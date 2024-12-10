resource "aws_rds_cluster" "aurora_cluster" {
    cluster_identifier      = "aurora-cluster-demo"
    engine                  = var.rds_config.engine
    engine_version          = var.rds_config.engine_version
    availability_zones      = ["${var.global.region}a", "${var.global.region}b", "${var.global.region}c"]
    master_username         = var.db_username
    master_password         = var.db_password
    database_name           = var.db_name
    backup_retention_period = 5
    preferred_backup_window = "07:00-09:00"
    preferred_maintenance_window = "mon:03:00-mon:04:00"
    vpc_security_group_ids = [aws_security_group.default.id]
    port = var.db_port
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
    skip_final_snapshot = true # for easier cleanup in prod environment it is recommended to set this to false
}

resource "aws_rds_cluster_instance" "aurora_instances" {
    count              = var.rds_config.instance_count
    identifier         = "aurora-instance-${count.index}"
    cluster_identifier = aws_rds_cluster.aurora_cluster.id
    instance_class     = "db.${var.rds_config.instance_type}.${var.rds_config.instance_size}"
    engine             = aws_rds_cluster.aurora_cluster.engine
    engine_version     = aws_rds_cluster.aurora_cluster.engine_version
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
}