AmimotoFrontRole do
  Type "AWS::IAM::Role"
  Properties do
    AssumeRolePolicyDocument do
      Statement [
        _{
          Effect "Allow"
          Principal do
            Service ["ec2.amazonaws.com"]
          end
          Action ["sts:AssumeRole"]
        }
      ]
    end
    Path "/"
    Policies [
      _{
        PolicyName "AmazonEC2ReadOnlyAccess"
        PolicyDocument do
          Statement [
            _{
              Effect "Allow"
              Action "ec2:Describe*"
              Resource "*"
            }
          ]
        end
      }
    ]
  end
end
AmimotoFrontRoleInstanceProfile do
  Type "AWS::IAM::InstanceProfile"
  Properties do
    Path "/"
    Roles [
      _{
        Ref "AmimotoFrontRole"
      }
    ]
  end
end
