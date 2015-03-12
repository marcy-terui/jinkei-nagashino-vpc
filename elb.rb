LoadBalancer do
  Type "AWS::ElasticLoadBalancing::LoadBalancer"
  Properties do
    CrossZone "true"
    Subnets [
      _{ Ref "AmimotoFrontSubnet1"},
      _{ Ref "AmimotoFrontSubnet2"}
    ]
    HealthCheck do
      HealthyThreshold 2
      Interval 30
      Target "TCP:80"
      Timeout 10
      UnhealthyThreshold 2
    end
    Listeners [
      _{
        InstancePort 80
        LoadBalancerPort 80
        Protocol "HTTP"
        InstanceProtocol "HTTP"
      },
      _{
        InstancePort 443
        LoadBalancerPort 443
        Protocol "TCP"
        InstanceProtocol "TCP"
      }
    ]
  end
end
