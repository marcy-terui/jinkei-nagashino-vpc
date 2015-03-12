AmimotoVPC do
  Type "AWS::EC2::VPC"
  Properties do
    CidrBlock "10.0.0.0/16"
    Tags [
      _{
        Key "Name"
        Value "mp-amimoto-vpc"
      }
    ]
  end
end
AmimotoFrontSubnet1 do
  Type "AWS::EC2::Subnet"
  Properties do
    VpcId do
      Ref "AmimotoVPC"
    end
    CidrBlock "10.0.1.0/24"
    AvailabilityZone do
      Fn__Select ["0", _{ Fn__GetAZs { Ref "AWS::Region" } }]
    end
    Tags [
      _{
        Key "Name"
        Value "mp-amimoto-front-subnet-1"
      }
    ]
  end
end
AmimotoFrontSubnet2 do
  Type "AWS::EC2::Subnet"
  Properties do
    VpcId do
      Ref "AmimotoVPC"
    end
    CidrBlock "10.0.2.0/24"
    AvailabilityZone do
      Fn__Select ["1", _{ Fn__GetAZs { Ref "AWS::Region" } }]
    end
    Tags [
      _{
        Key "Name"
        Value "mp-amimoto-front-subnet-2"
      }
    ]
  end
end
AmimotoWithRDSNFSSubnet do
  Type "AWS::EC2::Subnet"
  Properties do
    VpcId do
      Ref "AmimotoVPC"
    end
    CidrBlock "10.0.10.0/24"
    AvailabilityZone do
      Fn__Select ["0", _{ Fn__GetAZs { Ref "AWS::Region" } }]
    end
    Tags [
      _{
        Key "Name"
        Value "mp-amimoto-server-subnet"
      }
    ]
  end
end
AmimotoRDSSubnet1 do
  Type "AWS::EC2::Subnet"
  Properties do
    VpcId do
      Ref "AmimotoVPC"
    end
    CidrBlock "10.0.101.0/24"
    AvailabilityZone do
      Fn__Select ["0", _{ Fn__GetAZs { Ref "AWS::Region" } }]
    end
    Tags [
      _{
        Key "Name"
        Value "mp-amimoto-rds-subnet-1"
      }
    ]
  end
end
AmimotoRDSSubnet2 do
  Type "AWS::EC2::Subnet"
  Properties do
    VpcId do
      Ref "AmimotoVPC"
    end
    CidrBlock "10.0.102.0/24"
    AvailabilityZone do
      Fn__Select ["1", _{ Fn__GetAZs { Ref "AWS::Region" } }]
    end
    Tags [
      _{
        Key "Name"
        Value "mp-amimoto-rds-subnet-2"
      }
    ]
  end
end
AmimotoInternetGateway do
  Type "AWS::EC2::InternetGateway"
  Properties do
    Tags [
      _{
        Key "Name"
        Value "mp-amimoto-igw"
      }
    ]
  end
end
AttachGateway do
  Type "AWS::EC2::VPCGatewayAttachment"
  Properties do
    VpcId do
      Ref "AmimotoVPC"
    end
    InternetGatewayId do
      Ref "AmimotoInternetGateway"
    end
  end
end
AmimotoRouteTable do
  Type "AWS::EC2::RouteTable"
  Properties do
    VpcId do
      Ref "AmimotoVPC"
    end
    Tags [
      _{
        Key "Name"
        Value "mp-amimoto-rtb"
      }
    ]
  end
end
Route do
  Type "AWS::EC2::Route"
  DependsOn "AttachGateway"
  Properties do
    RouteTableId do
      Ref "AmimotoRouteTable"
    end
    DestinationCidrBlock "0.0.0.0/0"
    GatewayId do
      Ref "AmimotoInternetGateway"
    end
  end
end
SubnetRouteTableAssociationFront1 do
  Type "AWS::EC2::SubnetRouteTableAssociation"
  Properties do
    SubnetId do
      Ref "AmimotoFrontSubnet1"
    end
    RouteTableId do
      Ref "AmimotoRouteTable"
    end
  end
end
SubnetRouteTableAssociationFront2 do
  Type "AWS::EC2::SubnetRouteTableAssociation"
  Properties do
    SubnetId do
      Ref "AmimotoFrontSubnet2"
    end
    RouteTableId do
      Ref "AmimotoRouteTable"
    end
  end
end
SubnetRouteTableAssociationNFS do
  Type "AWS::EC2::SubnetRouteTableAssociation"
  Properties do
    SubnetId do
      Ref "AmimotoWithRDSNFSSubnet"
    end
    RouteTableId do
      Ref "AmimotoRouteTable"
    end
  end
end
