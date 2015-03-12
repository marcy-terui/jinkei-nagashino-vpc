ec2_instance_types = %w{
  t1.micro
  t2.micro t2.small t2.medium
  m1.small m1.medium m1.large m1.xlarge
  m2.xlarge m2.2xlarge m2.4xlarge
  m3.xlarge m3.2xlarge
  c1.medium c1.xlarge
  cc1.4xlarge cc2.8xlarge
  cg1.4xlarge
}

rds_instance_types = %w{
  db.t1.micro
  db.t2.micro db.t2.small db.t2.medium
  db.m1.small db.m1.medium db.m1.large db.m1.xlarge
  db.m3.medium db.m3.large db.m3.xlarge
  db.m2.xlarge db.m2.2xlarge db.m2.4xlarge
  db.cr1.8xlarge
}

AWSTemplateFormatVersion "2010-09-09"
Parameters do
  KeyName do
    Description "Name of an existing EC2 KeyPair to enable SSH access to the instances"
    Type "String"
    MinLength 1
    MaxLength 64
    AllowedPattern "[-_ a-zA-Z0-9]*"
    ConstraintDescription "can contain only alphanumeric characters, spaces, dashes and underscores."
  end
  MySQLPassword do
    Description "Password of RDS User"
    Type "String"
    MinLength 8
    MaxLength 64
  end
  InstanceType do
    Description "Front EC2 instance type"
    Type "String"
    Default "t2.small"
    AllowedValues ec2_instance_types
    ConstraintDescription "must be a valid EC2 instance type."
  end
  MasterInstanceType do
    Description "Master EC2 instance type"
    Type "String"
    Default "t2.medium"
    AllowedValues ec2_instance_types
    ConstraintDescription "must be a valid EC2 instance type."
  end
  RDSInstanceType do
    Description "RDS instance type"
    Type "String"
    Default "db.m3.medium"
    AllowedValues rds_instance_types
    ConstraintDescription "must be a valid EC2 instance type."
  end
  DBAllocatedStorage do
    Default 20
    Description "The size of the database (Gb)"
    Type "Number"
    MinValue 5
    MaxValue 3072
    ConstraintDescription "must be between 5 and 3072Gb."
  end
  MultiAZDatabase do
    Default "true"
    Description "Create a multi-AZ MySQL Amazon RDS database instance"
    Type "String"
    AllowedValues "true", "false"
    ConstraintDescription "must be either true or false."
  end
end
Mappings do
  MPAmimotov4(
    {"us-east-1"=>{"AMI"=>"ami-ca148fa2", "Location"=>"Virginia"},
     "us-west-2"=>{"AMI"=>"ami-83e8bfb3", "Location"=>"Oregon"},
     "us-west-1"=>{"AMI"=>"ami-950d1ed0", "Location"=>"N.California"},
     "eu-west-1"=>{"AMI"=>"ami-d275c8a5", "Location"=>"EU_Ireland"},
     "ap-southeast-1"=>{"AMI"=>"ami-bf725eed", "Location"=>"Singapore"},
     "ap-southeast-2"=>{"AMI"=>"ami-4fcfa675", "Location"=>"Sydney"},
     "ap-northeast-1"=>{"AMI"=>"ami-0e00030f", "Location"=>"Tokyo"},
     "sa-east-1"=>{"AMI"=>"ami-63de6e7e", "Location"=>"Sao_Paul"}})
end
