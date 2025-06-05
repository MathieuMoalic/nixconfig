{...}: {
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age.keyFile = "/home/mat/.ssh/age_key";
  };
}
