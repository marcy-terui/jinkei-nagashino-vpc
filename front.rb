AmimotoFrontSG do
  Type "AWS::AutoScaling::AutoScalingGroup"
  Properties do
    AvailabilityZones do
      Fn__GetAZs do
        Ref "AWS::Region"
      end
    end
    VPCZoneIdentifier [
      _{ Ref "AmimotoFrontSubnet1" },
      _{ Ref "AmimotoFrontSubnet2" }
    ]
    LaunchConfigurationName do
      Ref "AmimotoFrontLC"
    end
    LoadBalancerNames [
      _{
        Ref "LoadBalancer"
      }
    ]
    HealthCheckGracePeriod 300
    MaxSize 10
    MinSize 3
    Tags [
      _{
        Key "Name"
        Value "mp-amimoto-ac-front"
        PropagateAtLaunch true
      }
    ]
  end
end
AmimotoFrontSP do
  Type "AWS::AutoScaling::ScalingPolicy"
  Properties do
    AdjustmentType "ChangeInCapacity"
    AutoScalingGroupName do
      Ref "AmimotoFrontSG"
    end
    Cooldown 180
    ScalingAdjustment 1
  end
end
AmimotoFrontLC do
  Type "AWS::AutoScaling::LaunchConfiguration"
  Metadata do
    AWS__CloudFormation__Init do
      config do
        files do
          _path("/opt/aws/cloud_formation.json") do
            source "https://s3-ap-northeast-1.amazonaws.com/cf-amimoto-templates/cfn_file_templates/rds_nfs.json.template"
            context do
              endpoint do
                Fn__GetAtt "AmimotoRDS", "Endpoint.Address"
              end
              password do
                Ref "MySQLPassword"
              end
              serverid do
                Ref "AmimotoWithRDSNFS"
              end
            end
            mode "00644"
            owner "root"
            group "root"
          end
        end
      end
    end
  end
  Properties do
    AssociatePublicIpAddress "true"
    ImageId do
      Fn__FindInMap [
        "MPAmimotov4",
        _{
          Ref "AWS::Region"
        },
        "AMI"
      ]
    end
    InstanceType do
      Ref "InstanceType"
    end
    IamInstanceProfile do
      Ref "AmimotoFrontRoleInstanceProfile"
    end
    KeyName do
      Ref "KeyName"
    end
    SecurityGroups [
      _{
        Ref "sgAMIMOTO11AutogenByAWSMP"
      }
    ]
    UserData do
      Fn__Base64 do
        Fn__Join [
          "",
          [
            "#!/bin/bash\n",
            "/opt/aws/bin/cfn-init -s ",
            _{
              Ref "AWS::StackName"
            },
            " -r AmimotoFrontLC ",
            " --region ",
            _{
              Ref "AWS::Region"
            },
            "\n"
          ]
        ]
      end
    end
  end
end
