AmimotoWithRDSNFS do
  Type "AWS::EC2::Instance"
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
              serverid "dummy(value_will_update_by_AmimotoFrontLC)"
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
    DisableApiTermination "FALSE"
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
      Ref "MasterInstanceType"
    end
    KeyName do
      Ref "KeyName"
    end
    SecurityGroupIds [
      _{
        Ref "sgAMIMOTO11AutogenByAWSMPNFS"
      }
    ]
    SubnetId do
      Ref "AmimotoWithRDSNFSSubnet"
    end
    Monitoring "false"
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
    Tags [
      _{
        Key "Name"
        Value "mp-amimoto-server"
      }
    ]
  end
end
