{
  pkgs,
  config,
  ...
}: {
  users.users.kelvas = {
    isNormalUser = true;
    uid = 1002;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys =
      [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNNLMQFqQvcw2/OyVIsKTxi8WUqcBKFIcYGwZZYM3DT2wQ3uJ1Z2u5KGoJI9DEaf8nZPsIsQnYHNAwYqeMbxdgenLgbtJmS2Afxzv7wD/3w/Ydn2HTTLMmm7gUbJ7RT3NWo5nYHhBTXiPmuYCGJ5TggbXuZhT3kN4Gy5czItpIQlDHUzVrgYbvkUQEhxB+rt5bgwAtk2V8QGFaOo7qkXK3hlq/Ff3SLRvtXQo3v3wEUr7ULO/xkzp5go+Tn5iM0ZyTyzOyBqHmqZKeuCc3P087WuUNn7WH0qTwbQUrHS7anXv5AB23J/bf3A7OSmLx9oEyJQ42r5KRfG/SITjKo5VtrOMMn6sADjF2B7vbGBWisQVbIRdvtEdRhpPGfs7Cz0QCphjNlGCGdghSY2e51p/IUoWWUIA+m6AtACFXr2ZOSBzi4OL5GXpmFpV/dgY6T01CXKPfrkML6vGnw8kwLk7ERng6nn3Gpl1yOi+Bt07qzXu8OKJDP0EFv+BW/wMIFcU="
      ]
      ++ config.users.users.mat.openssh.authorizedKeys.keys;
  };
}
