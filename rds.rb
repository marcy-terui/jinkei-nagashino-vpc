AmimotoDBSubnetGroup do
  Type "AWS::RDS::DBSubnetGroup"
  Properties do
    DBSubnetGroupDescription "Subnets available for the RDS DB Instance"
    SubnetIds [
      _{ Ref "AmimotoRDSSubnet1" },
      _{ Ref "AmimotoRDSSubnet2" }
    ]
  end
end
AmimotoRDS do
  Type "AWS::RDS::DBInstance"
  Properties do
    AutoMinorVersionUpgrade "true"
    DBInstanceClass do
      Ref "RDSInstanceType"
    end
    Port 3306
    AllocatedStorage do
      Ref "DBAllocatedStorage"
    end
    BackupRetentionPeriod 1
    DBName "wordpress"
    Engine "mysql"
    MultiAZ do
      Ref "MultiAZDatabase"
    end
    MasterUsername "amimoto"
    MasterUserPassword do
      Ref "MySQLPassword"
    end
    PreferredBackupWindow "00:00-00:30"
    PreferredMaintenanceWindow "sun:16:00-sun:17:30"
    VPCSecurityGroups [
      _{
        Ref "sgAMIMOTO11AutogenByAWSMPforRDB"
      }
    ]
    Tags [
      _{
        Key "workload-type"
        Value "other"
      }
    ]
    DBSubnetGroupName do
      Ref "AmimotoDBSubnetGroup"
    end
  end
end
