Outputs do
  WebSiteURL do
    Description "WordPress Site URL (Please wait a few minutes for the upgrade of WordPress to access for the first time.)"
    Value do
      Fn__Join [
        "",
        [
          "http://",
          _{
            Fn__GetAtt "LoadBalancer", "DNSName"
          }
        ]
      ]
    end
  end
  RDSEndpoint do
    Description "Endpoint of RDS"
    Value do
      Fn__GetAtt "AmimotoRDS", "Endpoint.Address"
    end
  end
end
